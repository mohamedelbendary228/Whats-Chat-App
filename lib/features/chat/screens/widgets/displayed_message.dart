import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';

class DisplayedMessage extends StatelessWidget {
  final String message;
  final MessageEnum messageType;

  const DisplayedMessage(
      {Key? key, required this.message, required this.messageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return messageType == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : CachedNetworkImage(
            imageUrl: message,
            fit: BoxFit.fill,
          );
  }
}
