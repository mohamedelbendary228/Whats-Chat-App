import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_chat_app/features/auth/controller/auth_controller.dart';
import 'package:whats_chat_app/features/call/repository/call_repository.dart';
import 'package:whats_chat_app/models/call_model.dart';

final callControllerProvider = Provider<CallController>(
  (ref) {
    final callRepository = ref.read(callRepositoryProvider);
    return CallController(
      callRepository: callRepository,
      ref: ref,
      auth: FirebaseAuth.instance,
    );
  },
);

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;

  CallController(
      {required this.callRepository, required this.ref, required this.auth});

  Future<void> makeCall(
    BuildContext context,
    String receiverName,
    String receiverId,
    String receiverProfilePic,
    bool isGroupChat,
  ) async {
    String callId = const Uuid().v1();
    ref.read(userDataProvider).whenData(
      (userData) {
        CallModel senderCallData = CallModel(
          callerId: auth.currentUser!.uid,
          callerName: userData!.name,
          callerPic: userData.profilePic,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialled: true,
        );

        CallModel receiverCallData = CallModel(
          callerId: auth.currentUser!.uid,
          callerName: userData.name,
          callerPic: userData.profilePic,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialled: false,
        );

        return callRepository.makeCall(
          context,
          senderCallData,
          receiverCallData,
        );
      },
    );
  }

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
}
