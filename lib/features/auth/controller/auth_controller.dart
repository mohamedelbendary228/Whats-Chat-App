import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/auth/repository/auth_repository.dart';

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});

  void signInWithPhoneNumber(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhoneNumber(context, phoneNumber);
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String smsCode}) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationId, smsCode: smsCode);
  }

  void saveUserDataToFirestore({
    required String name,
    required File? profilePic,
    required BuildContext context,
  }) {
    authRepository.saveUserDataToFirestore(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }
}
