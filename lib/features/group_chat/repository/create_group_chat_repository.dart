import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_chat_app/core/repository/common_firbase_sotrage_repository.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/models/group_chat_model.dart';

class CreateGroupChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;

  CreateGroupChatRepository({
    required this.firestore,
    required this.firebaseAuth,
    required this.ref,
  });

  Future<void> createGroupChat({
    required BuildContext context,
    required File groupImage,
    required String groupName,
    required List<Contact> selectedContacts,
  }) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        final userCollection = await firestore
            .collection("users")
            .where('phoneNumber',
                isEqualTo:
                    selectedContacts[i].phones[0].number.replaceAll(' ', ''))
            .get();
        if (userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()["uid"]);
        }
      }
      final groupId = const Uuid().v1();
      final groupImageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase("groupChat/$groupId", groupImage);
      GroupModel groupModel = GroupModel(
        senderId: firebaseAuth.currentUser!.uid,
        name: groupName,
        groupId: groupId,
        lastMessage: "",
        groupPic: groupImageUrl,
        membersUid: [firebaseAuth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore
          .collection("groups")
          .doc(groupId)
          .set(groupModel.toJson());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      rethrow;
    }
  }
}
