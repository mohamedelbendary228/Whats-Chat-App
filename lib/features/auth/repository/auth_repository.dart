import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/router.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  void signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
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
      if(context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.USER_INFO_SCREEN, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context, content: e.message ?? "Something went wrong!");
    }
  }
}
