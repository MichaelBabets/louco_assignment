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
    this.isEmptyResponse = false,
    this.retryText,
  });

  final String id;
  final String text;
  final MessageRole role;
  final DateTime timestamp;
  final List<Event>? events;
  final MessageStatus status;
  final bool isEmptyResponse;
  final String? retryText;

  ChatMessage copyWith({
    List<Event>? events,
    MessageStatus? status,
    bool? isEmptyResponse,
  }) => ChatMessage(
    id: id,
    text: text,
    role: role,
    timestamp: timestamp,
    events: events ?? this.events,
    status: status ?? this.status,
    isEmptyResponse: isEmptyResponse ?? this.isEmptyResponse,
    retryText: retryText,
  );

  @override
  List<Object?> get props => [
    id,
    text,
    role,
    timestamp,
    events,
    status,
    isEmptyResponse,
    retryText,
  ];
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
