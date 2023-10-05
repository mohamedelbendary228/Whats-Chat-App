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

      /// upload the file to the FirebaseStorage and get the url to set it in FireStore
      final imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase("/status/$statusId/$uid", statusImage);

      /// initialize a list of contacts and add our device contacts into it
      /// we will use this list to determine who can see the status
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, deduplicateProperties: false);
      }

      /// initialize a list of users id to determine who can see the status
      /// by looping through every contact in [contacts] and check if that contact phone number
      /// exist in our fireStore collection, if it exists we will add its id to the following [uidsWhoCanSeeStatus] list
      List<String> uidsWhoCanSeeStatus = [];
      for (int i = 0; i < contacts.length; i++) {
        final userData = await firestore
            .collection("user")
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .get();

        /// note: we access the first element in [docs] because we fetch one user snapshot every loop
        if (userData.docs.isNotEmpty) {
          var user = UserModel.fromJson(userData.docs[0].data());
          uidsWhoCanSeeStatus.add(user.uid);
        }
      }

      /// initialize list of [statusImagesUrls] to uses it in [StatusModel]
      /// first we want to check if the statuses already exist or not, so we will get [statusesSnapShot] from fireStore
      List<String> statusImagesUrls = [];
      final statusesSnapShot = await firestore
          .collection("status")
          .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
          .get();

      /// if [statusesSnapShot] exist we convert it to [statusModel] and set the [statusImagesUrls] list
      /// to [statusModel.statusImagesUrls] list that coming from fireStore and also add [imageUrl] to it.
      /// then update the doc with the new [statusImagesUrls] list.

      /// if the [statusesSnapShot] not exist which means the user add his status for the first time,
      /// we just set the [imageUrl] to the [statusImagesUrls] list, after that we initialize [status] model and
      /// set a new collection for the status
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
