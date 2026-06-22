import '../../../core/models/event.dart';
import 'ai_chat_data_source.dart';

class AiResponse {
  const AiResponse({required this.text, required this.events});

  final String text;
  final List<Event> events;
}

abstract class AiChatRepository {
  Future<AiResponse> sendMessage(String message);
}

class AiChatRepositoryImpl implements AiChatRepository {
  AiChatRepositoryImpl({AiChatDataSource? dataSource})
    : _dataSource = dataSource ?? MockAiChatDataSource();

  final AiChatDataSource _dataSource;

  @override
  Future<AiResponse> sendMessage(String message) =>
      _dataSource.sendMessage(message);
}
