import 'package:flutter/material.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/displayed_message.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageType;

  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.messageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Align(
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
              DisplayedMessage(message: message, messageType: messageType, isMe: true),
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
                  const Icon(
                    Icons.done_all,
                    size: 20,
                    color: Colors.white60,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
