import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/core/constants/app_constants.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/core/providers/message_reply_provider.dart';
import 'package:whats_chat_app/features/auth/provider/auth_provider.dart';
import 'package:whats_chat_app/features/chat/repository/chat_repository.dart';
import 'package:whats_chat_app/models/message_model.dart';
import 'package:whats_chat_app/models/message_reply_model.dart';

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Future<void> sendTextOrGIFMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required isGifMessage,
    String? gifUrl,
  }) async {
    String formattedGIFUrl = "";
    if (isGifMessage) {
      /// We need to convert the url coming from giph to another format to work in flutter
      /// which is this format [https://i.giphy.com/media/"gif-name"/200.gif]
      int gifNameStartIndex = gifUrl!.lastIndexOf("-") + 1;
      String gifName = gifUrl.substring(gifNameStartIndex);
      formattedGIFUrl = "${AppConstants.GIPHY_URL_SCHEME}$gifName/200.gif";
    }
    final messageReply = ref.read(messageReplyProvider);

    /// we use ref.read(userDataProvider) to get the current user data
    ref.read(userDataProvider).whenData(
      (userData) async {
        await chatRepository.sendTextOrGIFMessage(
          context: context,
          text: text,
          receiverId: receiverId,
          senderData: userData!,
          gifUrl: formattedGIFUrl,
          isGifMessage: isGifMessage,
          messageReply: messageReply,
        );
      },
    );
  }

  Stream<List<MessageModel>> getChatStream(String receiverId) {
    return chatRepository.getChatStream(receiverId);
  }


  Future<void> sendFileMessage({
    required BuildContext context,
    required File file,
    required receiverId,
    required MessageEnum messageEnum,
  }) async {
    final messageReply = ref.read(messageReplyProvider);

    /// we use ref.read(userDataProvider) to get the current user data
    ref.read(userDataProvider).whenData(
      (userData) async {
        return chatRepository.sendFileMessage(
          context: context,
          file: file,
          receiverId: receiverId,
          currentUserData: userData!,
          ref: ref,
          messageEnum: messageEnum,
          messageReply: messageReply,
        );
      },
    );
  }


  Future<void> setSeenStatus(
      {required BuildContext context,
      required String receiverId,
      required String messageId}) async {
    await chatRepository.setSeenStatus(
        context: context, receiverId: receiverId, messageId: messageId);
  }
}
