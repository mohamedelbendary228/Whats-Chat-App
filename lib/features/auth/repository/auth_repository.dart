import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/core/constants/app_constants.dart';
import 'package:whats_chat_app/core/repository/common_firbase_sotrage_repository.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/features/home_screen.dart';
import 'package:whats_chat_app/models/user_model.dart';
import 'package:whats_chat_app/router.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });



  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection("users").doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromJson(userData.data()!);
    }
    return user;
  }


  /// A stream of user data that update the ui based on it
  Stream<UserModel> userData(String uid) {
    return firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()!));
  }

  Future<void> signInWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.of(context)
              .pushNamed(RoutesNames.OTP_SCREEN, arguments: verificationId);
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context, content: e.message ?? "Something went wrong!");
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String smsCode}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await auth.signInWithCredential(credential);
      if (context.mounted) {
        await Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.USER_INFO_SCREEN, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context, content: e.message ?? "Something went wrong!");
    }
  }

  /// Set the authenticated user data model to firestore
  Future<void> saveUserDataToFirestore({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = AppConstants.DUMMY_PROFILE_PIC;

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase("profilePic/$uid", profilePic);
      }

      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);

      await firestore.collection("users").doc(uid).set(user.toJson());
      if (context.mounted) {
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) {
            return const MainHomeScreen();
          },
        ), (route) => false);
      }
    } catch (e) {
      showSnackBar(
          context: context, content: e.toString() ?? "Something went wrong!");
    }
  }


  /// update "isOnline" field in firestore
  Future<void> setUserState(bool isOnline) async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({"isOnline": isOnline});
  }
}
