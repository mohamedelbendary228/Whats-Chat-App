import 'package:flutter/material.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/audio_message_widget.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/cached_image_widget.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/cached_video_widget.dart';

class DisplayedMessage extends StatelessWidget {
  final String message;
  final MessageEnum messageType;
  final bool isMe;

  const DisplayedMessage(
      {Key? key, required this.message, required this.messageType, required this.isMe})
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
        : messageType == MessageEnum.audio
            ? AudioMessageWidget(audioUrl: message, isMe: isMe)
            : messageType == MessageEnum.video
                ? VideoItemWidget(videoUrl: message)
                : messageType == MessageEnum.gif

                    /// For GIF
                    ? CachedImageWidget(imageUrl: message)

                    /// For normal Images
                    : CachedImageWidget(imageUrl: message);
  }
}
