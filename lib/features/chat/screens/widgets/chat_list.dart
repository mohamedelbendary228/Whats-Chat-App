import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/core/providers/message_reply_provider.dart';
import 'package:whats_chat_app/features/chat/provider/chat_provider.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/sender_message_card.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/my_message_card.dart';
import 'package:whats_chat_app/models/message_model.dart';
import 'package:whats_chat_app/models/message_reply_model.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverId;

  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  @override
  ConsumerState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController scrollController = ScrollController();

  late Stream<List<MessageModel>> chatStream;

  @override
  void initState() {
    super.initState();
    chatStream =
        ref.read(chatControllerProvider).getChatStream(widget.receiverId);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void scrollerToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  void onMessageSwiped({
    required String message,
    required bool isMe,
    required MessageEnum messageEnum,
  }) {
    ref.read(messageReplyProvider.notifier).update((_) =>
        MessageReply(message: message, isMe: isMe, messageEnum: messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder<List<MessageModel>>(
      stream: chatStream,
      builder: (context, snapshot) {
        final chatData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          scrollerToBottom();
          return ListView.builder(
            controller: scrollController,
            cacheExtent: size.height * 2,
            itemCount: chatData!.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (chatData[index].senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: chatData[index].text,
                  date: DateFormat.jmv().format(chatData[index].timeSent),
                  messageType: chatData[index].type,
                  repliedText: chatData[index].repliedMessage,
                  username: chatData[index].repliedTo,
                  repliedMessageType: chatData[index].repliedMessageType,
                  onSwipeLeft: () => onMessageSwiped(
                    message: chatData[index].text,
                    isMe: true,
                    messageEnum: chatData[index].type,
                  ),
                );
              }
              return SenderMessageCard(
                message: chatData[index].text,
                date: DateFormat.jmv().format(chatData[index].timeSent),
                messageType: chatData[index].type,
                repliedText: chatData[index].repliedMessage,
                username: chatData[index].repliedTo,
                repliedMessageType: chatData[index].repliedMessageType,
                onSwipeRight: () => onMessageSwiped(
                  message: chatData[index].text,
                  isMe: false,
                  messageEnum: chatData[index].type,
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
