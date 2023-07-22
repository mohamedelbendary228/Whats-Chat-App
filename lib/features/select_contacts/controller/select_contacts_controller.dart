import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/select_contacts/providers/select_contacs_provider.dart';
import 'package:whats_chat_app/features/select_contacts/repository/select_contancts_repository.dart';
import 'package:whats_chat_app/model/user_model.dart';

final getContactsProvider = FutureProvider<List<Contact>>((ref) async {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  Future<void> selectContact(
      Contact selectedContact, BuildContext context) async {
    await selectContactRepository.selectContact(selectedContact, context);
  }
}
