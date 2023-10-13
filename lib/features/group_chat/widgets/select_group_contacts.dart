import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/widgets/error_screen.dart';
import 'package:whats_chat_app/core/widgets/loading_screen.dart';
import 'package:whats_chat_app/features/group_chat/provider/group_chat_provider.dart';
import 'package:whats_chat_app/features/select_contacts/controller/select_contacts_controller.dart';
import 'package:whats_chat_app/features/select_contacts/providers/select_contacs_provider.dart';

class SelectGroupContacts extends ConsumerStatefulWidget {
  const SelectGroupContacts({super.key});

  @override
  ConsumerState createState() => _SelectGroupContactsState();
}

class _SelectGroupContactsState extends ConsumerState<SelectGroupContacts> {
  List<int> selectedContactsIndexList = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndexList.contains(index)) {
      selectedContactsIndexList.remove(index);
    } else {
      selectedContactsIndexList.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContactsProvider.notifier).update(
          (state) => [...state, contact],
        );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (contactList) {
            return Expanded(
              child: ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    return InkWell(
                      onTap: () => selectContact(index, contact),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                          trailing: selectedContactsIndexList.contains(index)
                              ? IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.done),
                                )
                              : null,
                        ),
                      ),
                    );
                  }),
            );
          },
          error: (err, trace) => Expanded(
            child: ErrorPage(
              error: err.toString(),
            ),
          ),
          loading: () => const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}
