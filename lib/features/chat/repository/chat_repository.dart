import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/models/chat_contact_model.dart';
import 'package:whats_chat_app/models/message_model.dart';
import 'package:whats_chat_app/models/user_model.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({required this.firestore, required this.firebaseAuth});

  /// This function saves the receiver and sender data to display it in main chats list view
  Future<void> _saveDataToChatsContactsCollection({
    required UserModel senderData,
    required UserModel receiverData,
    required String text,
    required DateTime timeSent,
    required String receiverId,
  }) async {
    /*
    we sent a request to firestore to sava the receiver and sender data and later we will display it
    on main chats list view (our messages and their messages).
    the following line shows how we store this data on firestore to show their messages and data.
    users collection -> receiver user id doc -> chats collection -> current user id doc -> set data
    then do another request with the following firestore collection and docs to show my messages and data
    users collection -> current user id doc -> chats collection -> receiver user id doc -> set data
    */

    // users collection -> receiver user id doc -> chats collection -> current user id doc -> set data
    var receiverChatContact = ChatContact(
        name: senderData.name,
        profilePic: senderData.profilePic,
        contactId: senderData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(firebaseAuth.currentUser!.uid)
        .set(receiverChatContact.toJson());

    //users collection -> current user id doc -> chats collection -> receiver user id doc -> set data
    var senderChatContact = ChatContact(
        name: receiverData.name,
        profilePic: receiverData.profilePic,
        contactId: receiverData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .set(senderChatContact.toJson());
  }

  Future<void> _saveMessageToMessageSubCollection({
    required String receiverId,
    required String receiverUsername,
    required String senderUsername,
    required String message,
    required String messageId,
    required DateTime timeSent,
    required MessageEnum messageType,
  }) async {
    // users collection -> sender user id doc -> chats collection -> receiver user id doc -> message collection -> message id doc -> store message
    final messageModel = MessageModel(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: receiverId,
      text: message,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    await firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc(messageId)
        .set(messageModel.toJson());

    // users collection -> receiver user id doc  -> chats collection -> sender user id doc  -> message collection -> message id doc -> store message
    await firestore
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("messages")
        .doc(messageId)
        .set(messageModel.toJson());
  }

  Future<void> sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel senderData,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;

      var userDataJson =
          await firestore.collection("users").doc(receiverId).get();

      var messageId = const Uuid().v1();

      receiverUserData = UserModel.fromJson(userDataJson.data()!);

      _saveDataToChatsContactsCollection(
        senderData: senderData,
        receiverData: receiverUserData,
        receiverId: receiverId,
        timeSent: timeSent,
        text: text,
      );

      _saveMessageToMessageSubCollection(
        receiverId: receiverId,
        receiverUsername: receiverUserData.name,
        senderUsername: senderData.name,
        message: text,
        messageId: messageId,
        timeSent: timeSent,
        messageType: MessageEnum.text,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      rethrow;
    }
  }

  Stream<List<MessageModel>> getChatStream(String receiverId) {
    final chatStreamList = firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("timeSent")
        .snapshots()
        .map(
      (event) {
        List<MessageModel> messages = [];
        for (var doc in event.docs) {
          MessageModel messageModel = MessageModel.fromJson(doc.data());
          messages.add(messageModel);
        }
        return messages;
      },
    );
    return chatStreamList;
  }
}
