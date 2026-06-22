part of 'ai_chat_bloc.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends AiChatEvent {
  const SendMessageEvent(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ResendMessageEvent extends AiChatEvent {
  const ResendMessageEvent(this.messageId);

  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

class ToggleFavoriteEvent extends AiChatEvent {
  const ToggleFavoriteEvent(this.eventId);

  final String eventId;

  @override
  List<Object?> get props => [eventId];
}

class RetryEmptyResponseEvent extends AiChatEvent {
  const RetryEmptyResponseEvent(this.aiMessageId);

  final String aiMessageId;

  @override
  List<Object?> get props => [aiMessageId];
}

class ResetChatEvent extends AiChatEvent {
  const ResetChatEvent();
}
