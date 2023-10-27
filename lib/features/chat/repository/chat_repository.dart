import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_chat_app/core/enums/message_enum.dart';
import 'package:whats_chat_app/core/repository/common_firbase_sotrage_repository.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/models/chat_contact_model.dart';
import 'package:whats_chat_app/models/message_model.dart';
import 'package:whats_chat_app/models/message_reply_model.dart';
import 'package:whats_chat_app/models/user_model.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({required this.firestore, required this.firebaseAuth});

  /// This function saves the receiver and sender data to display it in main chats list view
  /// we sent a request to firestore to sava the receiver and sender data and later we will display it
  /// on main chats list view (our messages and their messages).
  /// the following line shows how we store this data on firestore to show their messages and data.
  /// users collection -> receiver user id doc -> chats collection -> current user id doc -> set data
  /// then do another request with the following firestore collection and docs to show my messages and data
  /// users collection -> current user id doc -> chats collection -> receiver user id doc -> set data

  /// users collection -> receiver user id doc -> chats collection -> current user id doc -> set data
  Future<void> _saveDataToChatsContactsCollection({
    required UserModel senderData,
    required UserModel? receiverData,
    required String text,
    required DateTime timeSent,
    required String receiverId,
    required bool isGroupChat,
  }) async {
    if (isGroupChat) {
      await firestore
          .collection("groups")
          .doc(receiverId /*receiverId means here groupId*/)
          .update({
        "lastMessage": text,
        "timeSent": DateTime.now().millisecondsSinceEpoch,
      });
    } else {
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

      ///users collection -> current user id doc -> chats collection -> receiver user id doc -> set data
      var senderChatContact = ChatContact(
          name: receiverData!.name,
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
  }

  /// Initialize a messageModel and save it to the following firestore collections
  /// note: we save the message model to firestore collection two times with two different paths
  /// like in [_saveDataToChatsContactsCollection] method
  /// Path for the current user [sender] and Path for fro the receiver user

  /// Current User Path [Sender]
  /// users collection -> sender user id doc -> chats collection -> receiver user id doc -> message collection -> message id doc -> store message

  Future<void> _saveMessageToMessagesCollection({
    required String receiverId,
    required String? receiverUsername,
    required String senderUsername,
    required String message,
    required String messageId,
    required DateTime timeSent,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    final messageModel = MessageModel(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: receiverId,
      text: message,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? "" : messageReply.message,
      repliedTo: messageReply == null
          ? ""
          : messageReply.isMe
              ? senderUsername
              : receiverUsername ?? "",
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    if (isGroupChat) {
      await firestore
          .collection("groups")
          .doc(receiverId /*receiverId means here groupId*/)
          .collection("chats")
          .doc(messageId)
          .set(messageModel.toJson());
    } else {
      await firestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("chats")
          .doc(receiverId)
          .collection("messages")
          .doc(messageId)
          .set(messageModel.toJson());

      /// receiver User Path
      /// users collection -> receiver user id doc  -> chats collection -> sender user id doc  -> message collection -> message id doc -> store message
      await firestore
          .collection("users")
          .doc(receiverId)
          .collection("chats")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("messages")
          .doc(messageId)
          .set(messageModel.toJson());
    }
  }

  /// Using this method when send Text message or GIF Message
  Future<void> sendTextOrGIFMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel senderData,
    required bool isGifMessage,
    required MessageReply? messageReply,
    required bool isGroupChat,
    String? gifUrl,
  }) async {
    try {
      /// initialize the following objects to use it when send data to chatsContacts and messages collection
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      UserModel? receiverUserData;

      if (!isGroupChat) {
        var userDataJson =
            await firestore.collection("users").doc(receiverId).get();
        receiverUserData = UserModel.fromJson(userDataJson.data()!);
      }

      /// we send the above data to the chats contacts collection to show it in to show it in [ChatContactListTile
      _saveDataToChatsContactsCollection(
        senderData: senderData,
        receiverData: receiverUserData,
        receiverId: receiverId,
        timeSent: timeSent,
        text: isGifMessage ? "GIF" : text,
        isGroupChat: isGroupChat,
      );

      /// and then send the message with the above additional info to the messages collection
      _saveMessageToMessagesCollection(
        receiverId: receiverId,
        receiverUsername: receiverUserData?.name,
        senderUsername: senderData.name,
        message: isGifMessage ? gifUrl ?? "" : text,
        messageId: messageId,
        timeSent: timeSent,
        messageType: isGifMessage ? MessageEnum.gif : MessageEnum.text,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      rethrow;
    }
  }

  /// Using this method when send file message like Image, video, Audio or GIF
  Future<void> sendFileMessage({
    required BuildContext context,
    required File file,
    required receiverId,
    required UserModel currentUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      /// initialize the following objects to use it when send data to chatsContacts and messages collection
      DateTime timeSent = DateTime.now();
      String messageId = const Uuid().v1();

      UserModel? receiverUserData;
      if (!isGroupChat) {
        var userDataJson =
            await firestore.collection("users").doc(receiverId).get();
        receiverUserData = UserModel.fromJson(userDataJson.data()!);
      }

      /// Upload the file to firebase storage through [CommonFirebaseStorageRepository] class and get the uploaded Url
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              "chats/${messageEnum.type}/${currentUserData.uid}/$receiverId/$messageId",
              file);

      /// we declared a variable [contactMessage] and assign a value to it based on messageEnum
      /// to show it in [ChatContactListTile]
      String contactMessage;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMessage = "📷 Photo";
          break;
        case MessageEnum.audio:
          contactMessage = "🎵 Audio";
          break;
        case MessageEnum.video:
          contactMessage = "📸 Video";
          break;
        case MessageEnum.gif:
          contactMessage = "GIF";
          break;
        default:
          contactMessage = "GIF";
      }

      /// we send the above data to the chats contacts collection to show it in to show it in [ChatContactListTile]
      _saveDataToChatsContactsCollection(
        senderData: currentUserData,
        receiverData: receiverUserData,
        text: contactMessage,
        timeSent: timeSent,
        receiverId: receiverId,
        isGroupChat: isGroupChat,
      );

      /// and then send the message with the above additional info to the messages collection
      _saveMessageToMessagesCollection(
        receiverId: receiverId,
        receiverUsername: receiverUserData?.name,
        senderUsername: currentUserData.name,
        message: imageUrl,
        messageId: messageId,
        timeSent: timeSent,
        messageType: messageEnum,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      rethrow;
    }
  }

  /// Using this method on chat screen to get the chat
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

  Stream<List<MessageModel>> getGroupChatStream(String groupId) {
    final chatStreamList = firestore
        .collection("groups")
        .doc(groupId)
        .collection("chats")
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

  Future<void> setSeenStatus(
      {required BuildContext context,
      required String receiverId,
      required String messageId}) async {
    try {
      await firestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("chats")
          .doc(receiverId)
          .collection("messages")
          .doc(messageId)
          .update({"isSeen": true});

      await firestore
          .collection("users")
          .doc(receiverId)
          .collection("chats")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("messages")
          .doc(messageId)
          .update({"isSeen": true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      rethrow;
    }
  }
}
