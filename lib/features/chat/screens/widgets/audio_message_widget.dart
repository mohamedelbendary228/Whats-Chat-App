import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:whats_chat_app/colors.dart';

class AudioMessageWidget extends StatelessWidget {
  final String audioUrl;
  final bool isMe;

  const AudioMessageWidget(
      {Key? key, required this.audioUrl, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return VoiceMessage(
      audioSrc: audioUrl,
      me: isMe,
      meBgColor: AppColors.messageColor,
      contactBgColor: AppColors.appBarColor,
      contactFgColor: Colors.white,
      contactCircleColor: Colors.white,
      formatDuration: (duration){
        return duration.toString().substring(2,7);
      },

    );
  }
}
