import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_chat_app/models/chat_contact_model.dart';
import 'package:whats_chat_app/models/group_chat_model.dart';
import 'package:whats_chat_app/models/user_model.dart';

class ChatContactRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatContactRepository({required this.auth, required this.firestore});

  Stream<List<ChatContact>> getChatContacts() {
    final chatContactsStream = firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .snapshots()
        .asyncMap(
      (event) async {
        List<ChatContact> chatContactsList = [];
        for (var doc in event.docs) {
          // parse the to chatContact Object
          ChatContact chatContact = ChatContact.fromJson(doc.data());

          // get The receiver data and parse it to user model
          var receiverDataMap = await firestore
              .collection("users")
              .doc(chatContact.contactId)
              .get();

          var receiverData = UserModel.fromJson(receiverDataMap.data()!);

          // Add the chat contacts info from the parsed model above
          // note: both the above parsing getting info about the receiver to view it in the chat contacts list
          chatContactsList.add(
            ChatContact(
                name: receiverData.name,
                profilePic: receiverData.profilePic,
                contactId: chatContact.contactId,
                timeSent: chatContact.timeSent,
                lastMessage: chatContact.lastMessage),
          );
        }
        return chatContactsList;
      },
    );

    return chatContactsStream;
  }

  Stream<List<GroupModel>> getChatGroups() {
    final chatGroupStream = firestore.collection("groups").snapshots().map(
      (event) {
        List<GroupModel> chatGroupsList = [];
        for (var doc in event.docs) {
          // parse the to GroupModel Object
          GroupModel groupModel = GroupModel.fromJson(doc.data());
          if (groupModel.membersUid.contains(auth.currentUser!.uid)) {
            chatGroupsList.add(groupModel);
          }

          // Add the chat group info from the parsed model above
        }
        return chatGroupsList;
      },
    );

    return chatGroupStream;
  }
}
