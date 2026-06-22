import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/event.dart';
import '../data/ai_chat_repository.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc({required String greetingText, AiChatRepository? repository})
    : _repository = repository ?? AiChatRepositoryImpl(),
      super(
        AiChatState(
          messages: [
            ChatMessage(
              id: 'greeting',
              text: greetingText,
              role: MessageRole.assistant,
              timestamp: DateTime.now(),
            ),
          ],
        ),
      ) {
    on<SendMessageEvent>(_onSendMessage);
    on<ResendMessageEvent>(_onResendMessage);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ResetChatEvent>(_onResetChat);
  }

  final AiChatRepository _repository;

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final messageId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final userMessage = ChatMessage(
      id: messageId,
      text: event.message,
      role: MessageRole.user,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Message appears immediately — no loader
    emit(state.copyWith(messages: [...state.messages, userMessage]));

    await _dispatchToRepository(messageId, event.message, emit);
  }

  Future<void> _onResendMessage(
    ResendMessageEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final failed = state.messages.firstWhere(
      (m) => m.id == event.messageId,
      orElse: () => throw StateError('Message not found: ${event.messageId}'),
    );

    emit(
      state.copyWith(
        messages: _updateStatus(
          state.messages,
          event.messageId,
          MessageStatus.sending,
        ),
      ),
    );

    await _dispatchToRepository(event.messageId, failed.text, emit);
  }

  // Shared send + result handling for both send and resend
  Future<void> _dispatchToRepository(
    String messageId,
    String text,
    Emitter<AiChatState> emit,
  ) async {
    try {
      final response = await _repository.sendMessage(text);

      final withSent = _updateStatus(
        state.messages,
        messageId,
        MessageStatus.sent,
      );

      final aiMessage = ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: response.text,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        events: response.events.isNotEmpty ? response.events : null,
      );

      emit(state.copyWith(messages: [...withSent, aiMessage]));
    } catch (_) {
      emit(
        state.copyWith(
          messages: _updateStatus(
            state.messages,
            messageId,
            MessageStatus.failed,
          ),
        ),
      );
    }
  }

  void _onToggleFavorite(ToggleFavoriteEvent event, Emitter<AiChatState> emit) {
    final updated = state.messages.map((msg) {
      if (msg.events == null) return msg;
      return msg.copyWith(
        events: msg.events!
            .map(
              (e) => e.id == event.eventId
                  ? e.copyWith(isFavorited: !e.isFavorited)
                  : e,
            )
            .toList(),
      );
    }).toList();

    emit(state.copyWith(messages: updated));
  }

  void _onResetChat(ResetChatEvent event, Emitter<AiChatState> emit) {
    final greeting = state.messages.firstWhere(
      (m) => m.id == 'greeting',
      orElse: () => state.messages.first,
    );
    emit(AiChatState(messages: [greeting]));
  }

  static List<ChatMessage> _updateStatus(
    List<ChatMessage> messages,
    String messageId,
    MessageStatus status,
  ) => messages
      .map((m) => m.id == messageId ? m.copyWith(status: status) : m)
      .toList();
}
