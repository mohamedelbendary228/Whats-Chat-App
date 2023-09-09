import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/core/providers/message_reply_provider.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/displayed_message.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageType;
  final VoidCallback onSwipeRight;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.username,
    required this.repliedMessageType,
    required this.repliedText,
    required this.onSwipeRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SwipeTo(
      onRightSwipe: onSwipeRight,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width - 45,
          ),
          decoration: const BoxDecoration(
            color: AppColors.senderMessageColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.appBarColor.withOpacity(0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: DisplayedMessage(
                    message: repliedText,
                    messageType: repliedMessageType,
                    isMe: true,
                  ),
                ),

                DisplayedMessage(
                    message: message, messageType: messageType, isMe: false),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
