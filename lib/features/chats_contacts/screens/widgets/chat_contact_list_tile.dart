import 'package:flutter/material.dart';
import 'package:whats_chat_app/colors.dart';

class ChatContactListTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String profilePicUrl;
  final String timeSent;
  final VoidCallback? onTap;

  const ChatContactListTile({
    Key? key,
    required this.name,
    required this.lastMessage,
    required this.profilePicUrl,
    required this.timeSent,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  lastMessage,
                  style: const TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  profilePicUrl,
                ),
                radius: 30,
              ),
              trailing: Text(
                timeSent,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
        const Divider(color: AppColors.dividerColor, indent: 85),
      ],
    );
  }
}
