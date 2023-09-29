import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/core/providers/message_reply_provider.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/displayed_message.dart';

class MyMessageCard extends ConsumerWidget {
  final String message;
  final String date;
  final MessageEnum messageType;
  final VoidCallback onSwipeLeft;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.username,
    required this.repliedMessageType,
    required this.repliedText,
    required this.onSwipeLeft,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final messageReply = ref.watch(messageReplyProvider);

    return SwipeTo(
      onLeftSwipe: onSwipeLeft,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width - 45,
          ),
          decoration: const BoxDecoration(
            color: AppColors.messageColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// Replied Message Preview
                Container(
                  height: repliedMessageType != MessageEnum.text
                      ? 50
                      : repliedText.isNotEmpty
                          ? null
                          : 0,
                  width: repliedMessageType != MessageEnum.text
                      ? 100
                      : repliedText.isNotEmpty
                          ? null
                          : 0,
                  margin: EdgeInsets.symmetric(
                      horizontal: 5, vertical: repliedText.isNotEmpty ? 5 : 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: AppColors.appBarColor.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: DisplayedMessage(
                    message: repliedText,
                    messageType: repliedMessageType,
                    isMe: true,
                  ),
                ),
                DisplayedMessage(
                    message: message, messageType: messageType, isMe: true),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    Icon(
                      isSeen ? Icons.done_all : Icons.done,
                      size: 20,
                      color: isSeen ? Colors.blue : Colors.white60,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
