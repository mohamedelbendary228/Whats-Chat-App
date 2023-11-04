import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/auth/repository/auth_repository.dart';
import 'package:whats_chat_app/models/user_model.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataProvider = FutureProvider<UserModel?>((ref) async {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});


class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel> userData(String uid) {
    return authRepository.userData(uid);
  }

  Future<void> signInWithPhoneNumber(
      BuildContext context, String phoneNumber) async {
    await authRepository.signInWithPhoneNumber(context, phoneNumber);
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String smsCode}) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationId, smsCode: smsCode);
  }

  Future<void> saveUserDataToFirestore({
    required String name,
    required File? profilePic,
    required BuildContext context,
  }) async {
    await authRepository.saveUserDataToFirestore(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  Future<void> setUserState(bool isOnline) async {
    await authRepository.setUserState(isOnline);
  }
}
