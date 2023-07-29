import 'package:flutter/material.dart';
import 'package:whats_chat_app/core/widgets/sender_message_card.dart';
import 'package:whats_chat_app/info.dart';
import 'package:whats_chat_app/core/widgets/my_message_card.dart';


class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        if (messages[index]['isMe'] == true) {
          return MyMessageCard(
            message: messages[index]['text'].toString(),
            date: messages[index]['time'].toString(),
          );
        }
        return SenderMessageCard(
          message: messages[index]['text'].toString(),
          date: messages[index]['time'].toString(),
        );
      },
    );
  }
}
