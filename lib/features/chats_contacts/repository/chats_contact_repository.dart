import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_chat_app/models/chat_contact_model.dart';
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
}
