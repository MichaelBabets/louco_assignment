import 'package:flutter_test/flutter_test.dart';
import 'package:louco_assignment/features/ai_chat/data/ai_chat_data_source.dart';

void main() {
  group('MockAiChatDataSource.sendMessage', () {
    // Each test creates a fresh instance so _callCount starts at 0

    test('returns events for "tonight" query', () async {
      final ds = MockAiChatDataSource();
      final response = await ds.sendMessage("What's happening tonight?");
      expect(
        response.text,
        'Here are the events happening tonight in Frankfurt',
      );
      expect(response.events, isNotEmpty);
    });

    test('returns events for "near me" query', () async {
      final ds = MockAiChatDataSource();
      final response = await ds.sendMessage('Show events near me');
      expect(response.text, 'Here are events near your location');
      expect(response.events, isNotEmpty);
    });

    test('returns social events for "join" query', () async {
      final ds = MockAiChatDataSource();
      final response = await ds.sendMessage(
        'Find someone to join me at an event',
      );
      expect(
        response.text,
        'Here are some social events where you can meet people',
      );
      expect(response.events, isNotEmpty);
      expect(
        response.events.every(
          (e) =>
              e.category.toLowerCase().contains('party') ||
              e.category.toLowerCase().contains('nightlife'),
        ),
        isTrue,
      );
    });

    test('returns music events for "pop" query', () async {
      final ds = MockAiChatDataSource();
      final response = await ds.sendMessage('Show me pop events');
      expect(response.text, 'Here are upcoming music events in Frankfurt');
      expect(response.events, isNotEmpty);
    });

    test('returns only free events for "free" query', () async {
      final ds = MockAiChatDataSource();
      final response = await ds.sendMessage('Show me free events');
      expect(response.text, 'Here are free events happening near you');
      expect(response.events.every((e) => e.isFree), isTrue);
    });

    test('returns generic response for unrecognised query', () async {
      final ds = MockAiChatDataSource();
      final response = await ds.sendMessage('something random xyz');
      expect(response.text, 'Here are some great events I found for you');
      expect(response.events, isNotEmpty);
    });

    test('second call throws a network exception', () async {
      final ds = MockAiChatDataSource(initialCallCount: 1);
      await expectLater(ds.sendMessage('any message'), throwsException);
    });

    test('third call succeeds after the second fails', () async {
      final ds = MockAiChatDataSource(initialCallCount: 1);
      // 2nd call fails
      try {
        await ds.sendMessage('fail');
      } catch (_) {}
      // 3rd call succeeds
      final response = await ds.sendMessage('retry');
      expect(response.events, isNotEmpty);
    });
  });
}
