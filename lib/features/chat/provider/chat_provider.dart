import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/chat/controller/chat_controller.dart';
import 'package:whats_chat_app/features/chat/repository/chat_repository.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance));

final chatControllerProvider = Provider((ref) {
  return ChatController(
      chatRepository: ref.watch(chatRepositoryProvider), ref: ref);
});
