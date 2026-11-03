import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/networking/dio_factory.dart';

class ChatbotService {
  static const int _maxHistory = 12;

  final List<Map<String, String>> _messages = [];

  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  void initChat({
    String volunteerName = '',
    int points = 0,
    int totalHours = 0,
    List<String> todayTasks = const [],
  }) {
    _messages.clear();
  }

  Future<String> sendMessage(String userMessage) async {
    _messages.add({'role': 'user', 'content': userMessage});

    try {
      final history = _messages.length > _maxHistory
          ? _messages.sublist(_messages.length - _maxHistory)
          : _messages;

      final response = await DioFactory.getDio().post(
        ApiConstants.endpointChatbot,
        data: {'messages': history},
      );

      final reply = response.data['reply'] as String;
      _messages.add({'role': 'assistant', 'content': reply});
      return reply;
    } on DioException catch (e) {
      _messages.removeLast();
      final data = e.response?.data;
      final message = data is Map ? data['message']?.toString() : null;
      return message ?? 'تعذر الاتصال بالمساعد، حاول مرة أخرى.';
    } catch (_) {
      _messages.removeLast();
      return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }
  }

  void resetChat() {
    _messages.clear();
  }
}
