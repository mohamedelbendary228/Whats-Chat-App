import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/core/providers/message_reply_provider.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/features/chat/controller/chat_controller.dart';
import 'package:whats_chat_app/features/chat/screens/widgets/message_reply_preview.dart';

class BottomChatTextField extends ConsumerStatefulWidget {
  final String receiverId;
  final bool isGroupChat;

  const BottomChatTextField(
      {super.key, required this.receiverId, required this.isGroupChat});

  @override
  ConsumerState createState() => _BottomChatTextFieldState();
}

class _BottomChatTextFieldState extends ConsumerState<BottomChatTextField> {
  final TextEditingController messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;

  bool isSendButtonVisible = false;
  bool isEmojiPickerVisible = false;
  bool isRecorderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  Future<void> openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Mic permission not allowed!");
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  Future<void> sendMessage() async {
    if (isSendButtonVisible) {
      await ref.read(chatControllerProvider).sendTextOrGIFMessage(
            context: context,
            text: messageController.text.trim(),
            receiverId: widget.receiverId,
            isGifMessage: false,
            isGroupChat: widget.isGroupChat,
          );
      messageController.clear();
      setState(() {
        isSendButtonVisible = false;
      });
      ref.read(messageReplyProvider.notifier).update((state) => null);
    } else {
      final tempDir = await getTemporaryDirectory();
      String path = "${tempDir.path}/WhatsChatSound.aac";
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  Future<void> sendFileMessage(File file, MessageEnum messageEnum) async {
    await ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          receiverId: widget.receiverId,
          messageEnum: messageEnum,
          isGroupChat: widget.isGroupChat,
        );
  }

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

  Future<void> selectGIF() async {
    GiphyGif? gif = await pickGIF(context);
    if (gif != null) {
      if (mounted) {
        await ref.read(chatControllerProvider).sendTextOrGIFMessage(
              context: context,
              text: "",
              isGifMessage: true,
              gifUrl: gif.url,
              receiverId: widget.receiverId,
              isGroupChat: widget.isGroupChat,
            );
      }
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
    FocusScope.of(context).requestFocus();
  }

  void hideKeyboard() {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (FocusScope.of(context).hasFocus && isEmojiPickerVisible) {
      setState(() {
        isEmojiPickerVisible = false;
      });
    }
    final messageReply = ref.watch(messageReplyProvider);
    return Column(
      children: [
        messageReply != null
            ? const MessageReplyPreview()
            : const SizedBox.shrink(),
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
                    width: size.width * 0.30,
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
                          onPressed: selectGIF,
                          icon: const Icon(
                            Icons.gif,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: size.width * 0.30,
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
                  onTap: sendMessage,
                  child: Icon(
                    isSendButtonVisible
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                  ),
                ),
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

                    if (!isSendButtonVisible) {
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
