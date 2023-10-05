import 'package:flutter/material.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/models/status_model.dart';
import 'package:whats_chat_app/router.dart';

class StatusList extends StatelessWidget {
  final StatusModel status;

  const StatusList({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(RoutesNames.STATUS_VIEWER_SCREEN, arguments: status);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text(
                status.username,
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  status.profilePic,
                ),
                radius: 30,
              ),
            ),
          ),
        ),
        const Divider(color: AppColors.dividerColor, indent: 85),
      ],
    );
  }
}
