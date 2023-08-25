import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/features/auth/provider/auth_provider.dart';
import 'package:whats_chat_app/features/chat/repository/chat_repository.dart';
import 'package:whats_chat_app/models/message_model.dart';

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Future<void> sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required isGifMessage,
    String? gifUrl,
  }) async {
    /// we use ref.read(userDataProvider) to get the current user data
    ref.read(userDataProvider).whenData(
      (userData) async {
        await chatRepository.sendTextOrGIFMessage(
          context: context,
          text: text,
          receiverId: receiverId,
          senderData: userData!,
          gifUrl: gifUrl,
          isGifMessage: isGifMessage,
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
        );
      },
    );
  }
}
