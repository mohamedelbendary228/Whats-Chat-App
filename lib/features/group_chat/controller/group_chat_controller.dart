import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/group_chat/repository/group_chat_repository.dart';

final groupChatControllerProvider = Provider<GroupChatController>(
  (ref) {
    return GroupChatController(
        groupChatRepository: ref.read(groupChatRepositoryProvider), ref: ref);
  },
);

class GroupChatController {
  final GroupChatRepository groupChatRepository;
  final ProviderRef ref;

  GroupChatController({required this.groupChatRepository, required this.ref});

  Future<void> createGroupChat({
    required BuildContext context,
    required File groupImage,
    required String groupName,
    required List<Contact> selectedContacts,
  }) async {
    await groupChatRepository.createGroupChat(
        context: context,
        groupImage: groupImage,
        groupName: groupName,
        selectedContacts: selectedContacts);


  }
}
