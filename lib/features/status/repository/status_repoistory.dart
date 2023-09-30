import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_chat_app/core/repository/common_firbase_sotrage_repository.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/models/status_model.dart';
import 'package:whats_chat_app/models/user_model.dart';

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.firebaseAuth,
    required this.ref,
  });

  Future<void> uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      final statusId = const Uuid().v1();

      final uid = firebaseAuth.currentUser!.uid;

      final imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase("/status/$statusId/$uid", statusImage);

      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, deduplicateProperties: false);
      }

      List<String> uidsWhoCanSeeStatus = [];

      for (int i = 0; i < contacts.length; i++) {
        final userData = await firestore
            .collection("user")
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .get();
        if (userData.docs.isNotEmpty) {
          var user = UserModel.fromJson(userData.docs[0].data());
          uidsWhoCanSeeStatus.add(user.uid);
        }
      }

      List<String> statusImagesUrls = [];
      final statusesSnapShot = await firestore
          .collection("status")
          .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
          .get();

      if (statusesSnapShot.docs.isNotEmpty) {
        StatusModel statusModel =
            StatusModel.fromMap(statusesSnapShot.docs[0].data());
        statusImagesUrls = statusModel.statusImagesUrls;
        statusImagesUrls.add(imageUrl);
        await firestore
            .collection("status")
            .doc(statusesSnapShot.docs[0].id)
            .update({
          "photoUrl": statusImagesUrls,
        });
        return;
      } else {
        statusImagesUrls = [imageUrl];
      }
      StatusModel status = StatusModel(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        statusImagesUrls: statusImagesUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSeeStatus: uidsWhoCanSeeStatus,
      );

      await firestore.collection("status").doc(statusId).set(status.toJson());
      
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      rethrow;
    }
  }
}
