import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_chat_app/features/chats_contacts/controller/chats_contacts_controller.dart';
import 'package:whats_chat_app/features/chats_contacts/screens/widgets/chat_contact_list_tile.dart';

import 'package:whats_chat_app/models/chat_contact_model.dart';
import 'package:whats_chat_app/models/group_chat_model.dart';
import 'package:whats_chat_app/router.dart';

class ChatsContactsScreen extends ConsumerWidget {
  const ChatsContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// group chat list
            StreamBuilder<List<GroupModel>>(
                stream:
                    ref.watch(chatsContactsControllerProvider).getChatGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: SizedBox());
                  }
                  final groupData = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: groupData!.length,
                    itemBuilder: (context, index) {
                      return ChatContactListTile(
                        name: groupData[index].name,
                        lastMessage: groupData[index].lastMessage,
                        profilePicUrl: groupData[index].groupPic,
                        timeSent:
                            DateFormat.jm().format(groupData[index].timeSent),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RoutesNames.CHAT_SCREEN, arguments: {
                            "name": groupData[index].name,
                            "uid": groupData[index].groupId,
                            "isGroup": true,
                            "profilePic": groupData[index].groupPic,
                          });
                        },
                      );
                    },
                  );
                }),

            /// One to one chat list
            StreamBuilder<List<ChatContact>>(
                stream: ref
                    .watch(chatsContactsControllerProvider)
                    .getChatContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                        timeSent:
                            DateFormat.jm().format(chatContact[index].timeSent),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RoutesNames.CHAT_SCREEN,
                            arguments: {
                              "name": chatContact[index].name,
                              "uid": chatContact[index].contactId,
                              "profilePic": chatContact[index].profilePic,
                              "isGroup": false,
                            },
                          );
                        },
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
