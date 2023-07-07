import 'package:flutter/cupertino.dart';
import 'package:whats_chat_app/features/auth/repository/auth_repository.dart';

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

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
}
