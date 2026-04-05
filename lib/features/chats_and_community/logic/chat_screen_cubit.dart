// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import '../data/chat_message.dart';

// class ChatScreenState {
//   final List<ChatMessage> messages;
//   final String? selectedChip;

//   const ChatScreenState({required this.messages, this.selectedChip});

//   ChatScreenState copyWith({
//     List<ChatMessage>? messages,
//     String? selectedChip,
//   }) {
//     return ChatScreenState(
//       messages: messages ?? this.messages,
//       selectedChip: selectedChip ?? this.selectedChip,
//     );
//   }
// }

// class ChatScreenCubit extends Cubit<ChatScreenState> {
//   ChatScreenCubit()
//     : super(
//         const ChatScreenState(
//           messages: [
//             ChatMessage(
//               text: 'اهلا يا أحمد! 👋 أنا سند، أقدر أساعدك ازاي انهارده؟',
//               isUser: false,
//               time: '10:21 AM',
//             ),
//           ],
//         ),
//       );

//   String get _now => DateFormat('hh:mm a').format(DateTime.now());

//   void sendMessage(String text) {
//     final userMsg = ChatMessage(text: text, isUser: true, time: _now);
//     final loadingMsg = ChatMessage(
//       text: 'جاري معالجة طلبك...',
//       isUser: false,
//       time: _now,
//       isLoading: true,
//     );

//     emit(
//       state.copyWith(
//         messages: [...state.messages, userMsg, loadingMsg],
//         selectedChip: text,
//       ),
//     );

//     _fetchBotReply(text);
//   }

//   Future<void> _fetchBotReply(String userText) async {
//     await Future.delayed(const Duration(seconds: 2));

//     final updatedMessages = state.messages.where((m) => !m.isLoading).toList();

//     final botReply = userText.contains('مهامي اليومية')
//         ? ChatMessage(
//             text: '',
//             isUser: false,
//             time: _now,
//             spans: const [
//               ChatMessageSpan(
//                 text: 'عندك 2 مهام متاحة انهارده يا أحمد\n',
//                 isHighlighted: false,
//               ),
//               ChatMessageSpan(
//                 text: 'منطقة أكتوبر — 10:00 AM\nمنطقة المعادي — 2:30 PM',
//                 isHighlighted: true,
//               ),
//             ],
//           )
//         : ChatMessage(
//             text: '',
//             isUser: false,
//             time: _now,
//             spans: const [
//               ChatMessageSpan(
//                 text: 'أقرب حملة ليك دلوقتي يا أحمد\n',
//                 isHighlighted: false,
//               ),
//               ChatMessageSpan(
//                 text: 'حملة التوعية بالجيزة — 10:00 AM',
//                 isHighlighted: true,
//               ),
//             ],
//           );

//     emit(state.copyWith(messages: [...updatedMessages, botReply]));
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sanad/features/chats_and_community/data/api_service/chat_bot_service.dart';
import '../data/chat_message.dart';
import '../../../core/di/dependency_injection.dart';

class ChatScreenState {
  final List<ChatMessage> messages;
  final String? selectedChip;
  final bool isTyping;

  const ChatScreenState({
    required this.messages,
    this.selectedChip,
    this.isTyping = false,
  });

  ChatScreenState copyWith({
    List<ChatMessage>? messages,
    String? selectedChip,
    bool? isTyping,
  }) {
    return ChatScreenState(
      messages: messages ?? this.messages,
      selectedChip: selectedChip ?? this.selectedChip,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatScreenCubit extends Cubit<ChatScreenState> {
  final ChatbotService _chatbotService = getIt<ChatbotService>();

  ChatScreenCubit()
    : super(
        const ChatScreenState(
          messages: [
            ChatMessage(
              text:
                  'أهلاً! 👋 أنا سند، مساعدك الذكي. ازيك؟ أقدر أساعدك في إيه النهارده؟',
              isUser: false,
              time: '10:21 AM',
            ),
          ],
        ),
      );

  String get _now => DateFormat('hh:mm a').format(DateTime.now());

  // بيتبعت من HomeSuccess عشان يعرف بيانات المتطوع
  void initWithVolunteerData({
    required String volunteerName,
    required int points,
    required int totalHours,
    required List<String> todayTasks,
  }) {
    _chatbotService.initChat(
      volunteerName: volunteerName,
      points: points,
      totalHours: totalHours,
      todayTasks: todayTasks,
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(text: text, isUser: true, time: _now);

    // أضف رسالة المستخدم + loading
    emit(
      state.copyWith(
        messages: [...state.messages, userMsg],
        selectedChip: text,
        isTyping: true,
      ),
    );

    // اجيب الرد من Gemini
    final reply = await _chatbotService.sendMessage(text);

    final botReply = ChatMessage(text: reply, isUser: false, time: _now);

    emit(
      state.copyWith(messages: [...state.messages, botReply], isTyping: false),
    );
  }

  void resetConversation() {
    _chatbotService.resetChat();
    emit(
      ChatScreenState(
        messages: [
          ChatMessage(
            text: 'أهلاً من جديد! 👋 أقدر أساعدك في إيه؟',
            isUser: false,
            time: _now,
          ),
        ],
      ),
    );
  }
}
