import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/models/call_model.dart';

final callRepositoryProvider = Provider<CallRepository>((ref) {
  return CallRepository(
    firestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  CallRepository({
    required this.firestore,
    required this.firebaseAuth,
    required this.ref,
  });

  Future<void> makeCall(
    BuildContext context,
    CallModel senderCallData,
    CallModel receiverCallData,
  ) async {
    try {
      await firestore
          .collection("call")
          .doc(senderCallData.callerId)
          .set(senderCallData.toJson());

      await firestore
          .collection("call")
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toJson());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<DocumentSnapshot> get callStream => firestore
      .collection("call")
      .doc(firebaseAuth.currentUser!.uid)
      .snapshots();


}
