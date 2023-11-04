import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/features/call/controller/call_controller.dart';
import 'package:whats_chat_app/features/call/screens/call_pickup_screen.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/chat_list.dart';
import 'package:whats_chat_app/features/auth/controller/auth_controller.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/bottom_chat_text_field.dart';
import 'package:whats_chat_app/models/user_model.dart';

class ChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  final String profilePic;
  final bool isGroupChat;

  const ChatScreen(
      {Key? key,
      required this.name,
      required this.uid,
      required this.profilePic,
      required this.isGroupChat})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("ChatScreen rebuild");
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          /// Name and online statue
          title: isGroupChat
              ? Text(name)
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userData(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                        ),
                        Text(
                          snapshot.data!.isOnline ? "online" : "offline",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      ],
                    );
                  },
                ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                /// Make a call
                ref.read(callControllerProvider).makeCall(
                      context,
                      name,
                      uid,
                      profilePic,
                      isGroupChat,
                    );
              },
              icon: const Icon(Icons.video_call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(receiverId: uid, isGroupChat: isGroupChat),
            ),
            BottomChatTextField(receiverId: uid, isGroupChat: isGroupChat),
          ],
        ),
      ),
    );
  }
}
