import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/status/repository/status_repoistory.dart';

final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  return StatusRepository(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
      ref: ref);
});


