import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:louco_assignment/core/models/event.dart';
import 'package:louco_assignment/features/ai_chat/bloc/ai_chat_bloc.dart';
import 'package:louco_assignment/features/ai_chat/data/ai_chat_repository.dart';

// ---------------------------------------------------------------------------
// Fake repositories
// ---------------------------------------------------------------------------

class _SuccessRepository implements AiChatRepository {
  const _SuccessRepository({
    this.text = 'Here are some events',
    this.events = const [],
  });

  final String text;
  final List<Event> events;

  @override
  Future<AiResponse> sendMessage(String message) async =>
      AiResponse(text: text, events: events);
}

class _ErrorRepository implements AiChatRepository {
  @override
  Future<AiResponse> sendMessage(String message) async =>
      throw Exception('Network error. Please try again.');
}

class _EmptyRepository implements AiChatRepository {
  @override
  Future<AiResponse> sendMessage(String message) async =>
      const AiResponse(text: '', events: []);
}

final _fakeEvent = Event(
  id: 'test_1',
  title: 'Test Event',
  category: 'Party',
  venue: 'Test Venue',
  city: 'Frankfurt',
  dateTime: DateTime(2025, 8, 1, 20, 0),
);

AiChatBloc _bloc({AiChatRepository? repository}) => AiChatBloc(
  greetingText: 'Hi there!',
  repository: repository ?? const _SuccessRepository(),
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AiChatBloc', () {
    test('initial state contains greeting message', () {
      final bloc = _bloc();
      expect(bloc.state.messages.length, 1);
      expect(bloc.state.messages.first.role, MessageRole.assistant);
      expect(bloc.state.messages.first.id, 'greeting');
      expect(bloc.state.messages.first.text, 'Hi there!');
      bloc.close();
    });

    blocTest<AiChatBloc, AiChatState>(
      'SendMessageEvent: user message appears immediately with status sending, '
      'then AI response is appended',
      build: () => _bloc(
        repository: _SuccessRepository(
          text: 'Here are some events',
          events: [_fakeEvent],
        ),
      ),
      act: (bloc) => bloc.add(const SendMessageEvent('Hello')),
      expect: () => [
        // 1st emit: user message added, status = sending
        predicate<AiChatState>(
          (s) =>
              s.messages.length == 2 &&
              s.messages[1].role == MessageRole.user &&
              s.messages[1].text == 'Hello' &&
              s.messages[1].status == MessageStatus.sending,
        ),
        // 2nd emit: user message sent + AI response appended
        predicate<AiChatState>(
          (s) =>
              s.messages.length == 3 &&
              s.messages[1].status == MessageStatus.sent &&
              s.messages[2].role == MessageRole.assistant &&
              s.messages[2].text == 'Here are some events' &&
              s.messages[2].events != null &&
              s.messages[2].events!.length == 1,
        ),
      ],
    );

    blocTest<AiChatBloc, AiChatState>(
      'SendMessageEvent: marks user message as failed on repository error',
      build: () => _bloc(repository: _ErrorRepository()),
      act: (bloc) => bloc.add(const SendMessageEvent('Hello')),
      expect: () => [
        predicate<AiChatState>(
          (s) =>
              s.messages.length == 2 &&
              s.messages[1].status == MessageStatus.sending,
        ),
        predicate<AiChatState>(
          (s) =>
              s.messages.length == 2 &&
              s.messages[1].status == MessageStatus.failed,
        ),
      ],
    );

    blocTest<AiChatBloc, AiChatState>(
      'ResendMessageEvent: resends a failed message and gets AI response',
      build: () => _bloc(repository: const _SuccessRepository()),
      seed: () => AiChatState(
        messages: [
          ChatMessage(
            id: 'greeting',
            text: 'Hi',
            role: MessageRole.assistant,
            timestamp: DateTime(2025),
          ),
          ChatMessage(
            id: 'user_1',
            text: 'Hello',
            role: MessageRole.user,
            timestamp: DateTime(2025),
            status: MessageStatus.failed,
          ),
        ],
      ),
      act: (bloc) => bloc.add(const ResendMessageEvent('user_1')),
      expect: () => [
        predicate<AiChatState>(
          (s) => s.messages[1].status == MessageStatus.sending,
        ),
        predicate<AiChatState>(
          (s) =>
              s.messages[1].status == MessageStatus.sent &&
              s.messages.length == 3,
        ),
      ],
    );

    blocTest<AiChatBloc, AiChatState>(
      'SendMessageEvent without events does not attach events to AI message',
      build: () => _bloc(
        repository: const _SuccessRepository(
          text: 'No events found',
          events: [],
        ),
      ),
      act: (bloc) => bloc.add(const SendMessageEvent('nothing')),
      skip: 1,
      expect: () => [
        predicate<AiChatState>(
          (s) =>
              s.messages.last.role == MessageRole.assistant &&
              s.messages.last.events == null,
        ),
      ],
    );

    blocTest<AiChatBloc, AiChatState>(
      'ToggleFavoriteEvent toggles isFavorited on matching event',
      build: _bloc,
      seed: () => AiChatState(
        messages: [
          ChatMessage(
            id: 'ai_1',
            text: 'Here are events',
            role: MessageRole.assistant,
            timestamp: DateTime(2025),
            events: [_fakeEvent],
          ),
        ],
      ),
      act: (bloc) => bloc.add(ToggleFavoriteEvent(_fakeEvent.id)),
      expect: () => [
        predicate<AiChatState>(
          (s) => s.messages.first.events!.first.isFavorited == true,
        ),
      ],
    );

    blocTest<AiChatBloc, AiChatState>(
      'ToggleFavoriteEvent toggles back to false on second call',
      build: _bloc,
      seed: () => AiChatState(
        messages: [
          ChatMessage(
            id: 'ai_1',
            text: 'Here are events',
            role: MessageRole.assistant,
            timestamp: DateTime(2025),
            events: [_fakeEvent.copyWith(isFavorited: true)],
          ),
        ],
      ),
      act: (bloc) => bloc.add(ToggleFavoriteEvent(_fakeEvent.id)),
      expect: () => [
        predicate<AiChatState>(
          (s) => s.messages.first.events!.first.isFavorited == false,
        ),
      ],
    );

    // -----------------------------------------------------------------------
    // Empty response
    // -----------------------------------------------------------------------

    blocTest<AiChatBloc, AiChatState>(
      'SendMessageEvent: empty response emits isEmptyResponse AI message',
      build: () => _bloc(repository: _EmptyRepository()),
      act: (bloc) => bloc.add(const SendMessageEvent('Hello')),
      skip: 1,
      expect: () => [
        predicate<AiChatState>(
          (s) =>
              s.messages.length == 3 &&
              s.messages.last.role == MessageRole.assistant &&
              s.messages.last.isEmptyResponse == true &&
              s.messages.last.retryText == 'Hello' &&
              s.isTyping == false,
        ),
      ],
    );

    blocTest<AiChatBloc, AiChatState>(
      'SendMessageEvent: isTyping is true while empty response is in flight',
      build: () => _bloc(repository: _EmptyRepository()),
      act: (bloc) => bloc.add(const SendMessageEvent('Hello')),
      expect: () => [
        predicate<AiChatState>((s) => s.isTyping == true),
        predicate<AiChatState>((s) => s.isTyping == false),
      ],
    );

    blocTest<AiChatBloc, AiChatState>(
      'RetryEmptyResponseEvent: removes empty message and re-sends, '
      'emitting a real AI response on success',
      build: () => _bloc(repository: const _SuccessRepository()),
      seed: () => AiChatState(
        messages: [
          ChatMessage(
            id: 'greeting',
            text: 'Hi',
            role: MessageRole.assistant,
            timestamp: DateTime(2025),
          ),
          ChatMessage(
            id: 'user_1',
            text: 'Hello',
            role: MessageRole.user,
            timestamp: DateTime(2025),
            status: MessageStatus.sent,
          ),
          ChatMessage(
            id: 'ai_empty',
            text: '',
            role: MessageRole.assistant,
            timestamp: DateTime(2025),
            isEmptyResponse: true,
            retryText: 'Hello',
          ),
        ],
      ),
      act: (bloc) =>
          bloc.add(const RetryEmptyResponseEvent('ai_empty')),
      expect: () => [
        // Empty message removed, isTyping = true
        predicate<AiChatState>(
          (s) =>
              s.messages.length == 2 &&
              s.messages.every((m) => !m.isEmptyResponse) &&
              s.isTyping == true,
        ),
        // Real AI response appended, isTyping = false
        predicate<AiChatState>(
          (s) =>
              s.messages.length == 3 &&
              s.messages.last.role == MessageRole.assistant &&
              s.messages.last.isEmptyResponse == false &&
              s.messages.last.text.isNotEmpty &&
              s.isTyping == false,
        ),
      ],
    );

    blocTest<AiChatBloc, AiChatState>(
      'RetryEmptyResponseEvent: marks user message failed '
      'when retry also throws',
      build: () => _bloc(repository: _ErrorRepository()),
      seed: () => AiChatState(
        messages: [
          ChatMessage(
            id: 'greeting',
            text: 'Hi',
            role: MessageRole.assistant,
            timestamp: DateTime(2025),
          ),
          ChatMessage(
            id: 'user_1',
            text: 'Hello',
            role: MessageRole.user,
            timestamp: DateTime(2025),
            status: MessageStatus.sent,
          ),
          ChatMessage(
            id: 'ai_empty',
            text: '',
            role: MessageRole.assistant,
            timestamp: DateTime(2025),
            isEmptyResponse: true,
            retryText: 'Hello',
          ),
        ],
      ),
      act: (bloc) =>
          bloc.add(const RetryEmptyResponseEvent('ai_empty')),
      expect: () => [
        predicate<AiChatState>(
          (s) => s.messages.length == 2 && s.isTyping == true,
        ),
        predicate<AiChatState>((s) => s.isTyping == false),
      ],
    );

    blocTest<AiChatBloc, AiChatState>(
      'ResetChatEvent resets to single greeting message',
      build: _bloc,
      seed: () => AiChatState(
        messages: [
          ChatMessage(
            id: 'greeting',
            text: 'Hi',
            role: MessageRole.assistant,
            timestamp: DateTime(2025),
          ),
          ChatMessage(
            id: 'user_1',
            text: 'Hello',
            role: MessageRole.user,
            timestamp: DateTime(2025),
          ),
        ],
      ),
      act: (bloc) => bloc.add(const ResetChatEvent()),
      expect: () => [
        predicate<AiChatState>(
          (s) =>
              s.messages.length == 1 &&
              s.messages.first.role == MessageRole.assistant &&
              s.messages.first.id == 'greeting',
        ),
      ],
    );
  });
}
