import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/widgets/loading_screen.dart';
import 'package:whats_chat_app/features/select_contacts/controller/select_contacts_controller.dart';
import 'package:whats_chat_app/features/select_contacts/providers/select_contacs_provider.dart';
import 'package:whats_chat_app/features/select_contacts/screens/widgets/contacts_list.dart';

class SelectContactsPage extends ConsumerWidget {
  const SelectContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectContactsRef = ref.watch(getContactsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select contact"),
        backgroundColor: AppColors.appBarColor,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: selectContactsRef.when(
          data: (contacts) {
            return ContactsList(contacts: contacts);
          },
          error: (error, _) {
            return ErrorWidget(error.toString());
          },
          loading: () => const LoaderPage()),
    );
  }
}
