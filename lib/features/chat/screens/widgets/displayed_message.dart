import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_chat_app/core/constants/app_assets.dart';
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
            placeholder: (context, _) => SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Opacity(
                      opacity: 0.5,
                      child: Icon(Icons.photo_camera_back,
                          size: MediaQuery.of(context).size.width * 0.5)),
                ),
            errorWidget: (context, _, __) => Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Opacity(
                          opacity: 0.5,
                          child: Icon(Icons.photo_camera_back,
                              size: MediaQuery.of(context).size.width * 0.5)),
                    ),
                    const Text(("Failed to load photo"))
                  ],
                ));
  }
}
