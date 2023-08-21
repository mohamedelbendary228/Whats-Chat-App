import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/features/chat/provider/chat_provider.dart';

class BottomChatTextField extends ConsumerStatefulWidget {
  final String receiverId;

  const BottomChatTextField({super.key, required this.receiverId});

  @override
  ConsumerState createState() => _BottomChatTextFieldState();
}

class _BottomChatTextFieldState extends ConsumerState<BottomChatTextField> {
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  bool isSendButtonVisible = false;
  bool isEmojiPickerVisible = false;

  void toggleSendButton(String val) {
    if (val.isNotEmpty) {
      setState(() {
        isSendButtonVisible = true;
      });
    } else {
      setState(() {
        isSendButtonVisible = false;
      });
    }
  }

  Future<void> selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  Future<void> selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  Future<void> sendTextMessage() async {
    if (isSendButtonVisible) {
      await ref.read(chatControllerProvider).sendTextMessage(
          context: context,
          text: messageController.text.trim(),
          receiverId: widget.receiverId);
      messageController.clear();
    }
  }

  void hideEmojiPicker() {
    setState(() {
      isEmojiPickerVisible = false;
    });
  }

  void showEmojiPicker() {
    setState(() {
      isEmojiPickerVisible = true;
    });
  }

  void showKeyboard() {
    debugPrint("requestFocussss");
    FocusScope.of(context).requestFocus();
  }

  void hideKeyboard() {
    debugPrint("unfocus");
    FocusScope.of(context).unfocus();
  }

  void toggleEmojiPicker() {
    if (isEmojiPickerVisible) {
      showKeyboard();
      hideEmojiPicker();
    } else {
      hideKeyboard();
      showEmojiPicker();
    }
  }

  Future<void> sendFileMessage(File file, MessageEnum messageEnum) async {
    await ref.read(chatControllerProvider).sendFileMessage(
        context: context,
        file: file,
        receiverId: widget.receiverId,
        messageEnum: messageEnum);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if(FocusScope.of(context).hasFocus && isEmojiPickerVisible) {
      setState(() {
        isEmojiPickerVisible = false;
      });
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                onChanged: toggleSendButton,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: size.width * 0.25,
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: toggleEmojiPicker,
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
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
                    width: size.width * 0.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: selectVideo,
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
              padding: const EdgeInsets.only(bottom: 8, right: 5, left: 8),
              child: CircleAvatar(
                backgroundColor: AppColors.sendMessageButtonColor,
                radius: 25,
                child: GestureDetector(
                    onTap: sendTextMessage,
                    child: Icon(isSendButtonVisible ? Icons.send : Icons.mic)),
              ),
            )
          ],
        ),
        isEmojiPickerVisible
            ? SizedBox(
                height: size.height * 0.36,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      messageController.text =
                          messageController.text + emoji.emoji;
                    });

                    if(!isSendButtonVisible) {
                      setState(() {
                        isSendButtonVisible = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
