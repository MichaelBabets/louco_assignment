part of 'ai_chat_bloc.dart';

enum MessageRole { user, assistant }

enum MessageStatus { sending, sent, failed }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.role,
    required this.timestamp,
    this.events,
    this.status = MessageStatus.sent,
  });

  final String id;
  final String text;
  final MessageRole role;
  final DateTime timestamp;
  final List<Event>? events;
  final MessageStatus status;

  ChatMessage copyWith({List<Event>? events, MessageStatus? status}) =>
      ChatMessage(
        id: id,
        text: text,
        role: role,
        timestamp: timestamp,
        events: events ?? this.events,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [id, text, role, timestamp, events, status];
}

class AiChatState extends Equatable {
  const AiChatState({this.messages = const [], this.isTyping = false});

  final List<ChatMessage> messages;
  final bool isTyping;

  AiChatState copyWith({List<ChatMessage>? messages, bool? isTyping}) =>
      AiChatState(
        messages: messages ?? this.messages,
        isTyping: isTyping ?? this.isTyping,
      );

  @override
  List<Object?> get props => [messages, isTyping];
}
