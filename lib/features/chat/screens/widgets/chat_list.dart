import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_chat_app/features/chat/provider/chat_provider.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/sender_message_card.dart';
import 'package:whats_chat_app/info.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/my_message_card.dart';
import 'package:whats_chat_app/models/message_model.dart';


class ChatList extends ConsumerWidget {
  final String receiverId;
  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStream = ref.read(chatControllerProvider).getChatStream(receiverId);
    return StreamBuilder<List<MessageModel>>(
      stream: chatStream,
      builder: (context, snapshot) {
        final chatData = snapshot.data;
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: chatData!.length,
          scrollDirection: Axis.vertical,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (context, index) {
            if (chatData[index].senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: chatData[index].text,
                date: DateFormat.jmv().format(chatData[index].timeSent),
              );
            }
            return SenderMessageCard(
              message: chatData[index].text,
              date: DateFormat.jmv().format(chatData[index].timeSent),
            );
          },
        );
      }
    );
  }
}
