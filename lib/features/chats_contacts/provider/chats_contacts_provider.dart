import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/chats_contacts/controller/chats_contacts_controller.dart';
import 'package:whats_chat_app/features/chats_contacts/repository/chats_contact_repository.dart';

final chatsContactsRepositoryProvider = Provider((ref) {
  return ChatContactRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

final chatsContactsControllerProvider =
    Provider<ChatsContactsController>((ref) {
  final chatContactRepository = ref.watch(chatsContactsRepositoryProvider);
  return ChatsContactsController(chatContactRepository: chatContactRepository);
});
