import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/auth/controller/auth_controller.dart';
import 'package:whats_chat_app/features/status/repository/status_repoistory.dart';
import 'package:whats_chat_app/models/status_model.dart';

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({required this.statusRepository, required this.ref});

  Future<void> addStatus(File file, BuildContext context) async {
    ref.watch(userDataProvider).whenData((userData) async {
      await statusRepository.uploadStatus(
          username: userData!.name,
          profilePic: userData.profilePic,
          phoneNumber: userData.phoneNumber,
          statusImage: file,
          context: context);
    });
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statusList = await statusRepository.getStatus(context);
    return statusList;
  }
}
