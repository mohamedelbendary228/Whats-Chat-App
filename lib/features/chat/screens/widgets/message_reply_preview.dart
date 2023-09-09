import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/core/providers/message_reply_provider.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/displayed_message.dart';
import 'package:whats_chat_app/models/message_reply_model.dart';

class MessageReplyPreview extends ConsumerWidget {

  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: AppColors.appBarColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? "You" : "Opposite",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  ref
                      .read(messageReplyProvider.notifier)
                      .update((state) => null);
                },
                child: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
              height: messageReply.messageEnum != MessageEnum.text ? 50 : null,
              width: messageReply.messageEnum != MessageEnum.text ? 100 : null,
              child: DisplayedMessage(
                  message: messageReply.message,
                  messageType: messageReply.messageEnum,
                  isMe: messageReply.isMe)),
        ],
      ),
    );
  }
}
