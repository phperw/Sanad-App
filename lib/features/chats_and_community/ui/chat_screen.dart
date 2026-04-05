import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/features/chats_and_community/ui/widgets_chat_screen/bot_message_bubble.dart';
import 'package:sanad/features/chats_and_community/ui/widgets_chat_screen/quick_action_chip.dart';
import 'package:sanad/features/chats_and_community/ui/widgets_chat_screen/user_message_bubble.dart';
import '../../../core/helper/responsive_extensions.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/widgets/typing_indicator_widget.dart';
import '../logic/chat_screen_cubit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const List<String> quickActions = [
    'مهامي اليومية 📋',
    'أقرب حملة 📍',
    'نقاطي ⭐',
    'كيف أسجل الحضور؟ ✅',
  ];

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatScreenCubit, ChatScreenState>(
      listener: (context, state) {
        _scrollToBottom();
      },
      builder: (context, state) {
        final cubit = context.read<ChatScreenCubit>();

        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(vertical: 16.h(context)),
          children: [
            BotMessageBubble(
              message: state.messages.first.text,
              time: state.messages.first.time,
            ),
            verticalSpace(context, height: 12),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Wrap(
                spacing: 8.w(context),
                runSpacing: 8.h(context),
                children: quickActions.map((label) {
                  final isActive = state.selectedChip == label;
                  return QuickActionChip(
                    label: label,
                    isActive: isActive,
                    onTap: () => cubit.sendMessage(label),
                  );
                }).toList(),
              ),
            ),
            verticalSpace(context, height: 12),
            ...state.messages
                .skip(1)
                .map(
                  (msg) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h(context)),
                    child: msg.isUser
                        ? UserMessageBubble(message: msg.text, time: msg.time)
                        : BotMessageBubble(
                            message: msg.text,
                            time: msg.time,
                            isLoading: msg.isLoading,
                            spans: msg.spans,
                          ),
                  ),
                ),

            // Typing Indicator
            if (state.isTyping)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: TypingIndicatorWidget(),
              ),
          ],
        );
      },
    );
  }
}
