import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_chat_app/colors.dart';

class BottomChatTextField extends StatefulWidget {
  const BottomChatTextField({Key? key}) : super(key: key);

  @override
  State<BottomChatTextField> createState() => _BottomChatTextFieldState();
}

class _BottomChatTextFieldState extends State<BottomChatTextField> {
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  bool isSendButtonVisible = false;

  void toggleSendButton(String val) {
    if(val.isNotEmpty) {
      setState(() {
        isSendButtonVisible = true;
      });
    } else {
      setState(() {
        isSendButtonVisible = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: messageController,
            onChanged: toggleSendButton,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.mobileChatBoxColor,
              prefixIcon: SizedBox(
                width: 100.w,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.gif,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              suffixIcon: SizedBox(
                width: 100.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.h, right: 5.w, left: 8.w),
          child: CircleAvatar(
            backgroundColor: AppColors.sendMessageButtonColor,
            radius: 25,
            child: Icon(isSendButtonVisible ? Icons.send : Icons.mic),
          ),
        )
      ],
    );
  }
}
