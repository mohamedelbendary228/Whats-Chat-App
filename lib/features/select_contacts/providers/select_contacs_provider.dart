import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/select_contacts/controller/select_contacts_controller.dart';
import 'package:whats_chat_app/features/select_contacts/repository/select_contancts_repository.dart';

final selectContactsRepositoryProvider = Provider((ref) {
  return SelectContactRepository(firestore: FirebaseFirestore.instance);
});

final selectContactControllerProvider = Provider((ref) {
  var selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactRepository: selectContactRepository,
  );
});
