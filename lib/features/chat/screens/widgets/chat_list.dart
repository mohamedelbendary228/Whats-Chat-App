import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_chat_app/features/chat/provider/chat_provider.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/sender_message_card.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/my_message_card.dart';
import 'package:whats_chat_app/models/message_model.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverId;

  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  @override
  ConsumerState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController scrollController = ScrollController();

  void scrollerToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  late Stream<List<MessageModel>> chatStream;

  @override
  void initState() {
    super.initState();
    chatStream =
        ref.read(chatControllerProvider).getChatStream(widget.receiverId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ChatList rebuild");
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
                );
              }
              return SenderMessageCard(
                message: chatData[index].text,
                date: DateFormat.jmv().format(chatData[index].timeSent),
                messageType: chatData[index].type,
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
