import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/features/chats_contacts/provider/chats_contacts_provider.dart';
import 'package:whats_chat_app/features/chats_contacts/screens/widgets/chat_contact_list_tile.dart';
import 'package:whats_chat_app/info.dart';
import 'package:whats_chat_app/features/chat/screens/chat_screen.dart';
import 'package:whats_chat_app/models/chat_contact_model.dart';

class ChatsContactsScreen extends ConsumerWidget {
  const ChatsContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatsContactsControllerProvider).getChatContacts(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final chatContact = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: chatContact!.length,
              itemBuilder: (context, index) {
                return ChatContactListTile(
                  name: chatContact[index].name,
                  lastMessage: chatContact[index].lastMessage,
                  profilePicUrl: chatContact[index].profilePic,
                  timeSent: DateFormat.jmv().format(chatContact[index].timeSent),
                );
              },
            );
          }),
    );
  }
}
