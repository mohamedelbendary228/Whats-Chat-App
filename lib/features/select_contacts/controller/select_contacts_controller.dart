import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/select_contacts/repository/select_contancts_repository.dart';

final getContactsProvider = FutureProvider<List<Contact>>((ref) async {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});
