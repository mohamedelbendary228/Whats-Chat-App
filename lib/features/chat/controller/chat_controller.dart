import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  }) async {
    ref.read(userDataProvider).whenData(
      (userData) async {
        await chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverId: receiverId,
            senderData: userData!);
      },
    );
  }

  Stream<List<MessageModel>> getChatStream(String receiverId) {
    return chatRepository.getChatStream(receiverId);
  }
}
