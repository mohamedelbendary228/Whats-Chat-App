import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/models/user_model.dart';
import 'package:whats_chat_app/router.dart';

final selectContactsRepositoryProvider = Provider((ref) {
  return SelectContactRepository(firestore: FirebaseFirestore.instance);
});

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, deduplicateProperties: false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  Future<void> selectContact(
      Contact selectedContact, BuildContext context) async {
    // get the country details so that we can know the country code form it
    final CountryDetails details = CountryCodes.detailsForLocale();
    String countryCode = details.dialCode.toString();

    bool isContactFound = false;

    try {
      var userCollection = await firestore.collection("users").get();
      for (var doc in userCollection.docs) {
        var userModel = UserModel.fromJson(doc.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');

        // This if condition detect if the selected number contains country code or not
        // if not it add the first two charaters of the country code so that it will
        // match the user number on firebase
        // Ex: 01016804509 will be ----> +201016804509
        if (!selectedPhoneNumber.contains("+")) {
          selectedPhoneNumber =
              countryCode.substring(0, 2) + selectedPhoneNumber;
        }

        debugPrint("selectedPhoneNumber $selectedPhoneNumber");

        if (selectedPhoneNumber == userModel.phoneNumber) {
          debugPrint("username ${userModel.name}");
          debugPrint("user Id ${userModel.uid}");

          isContactFound = true;
          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            await Navigator.of(context).pushReplacementNamed(
                RoutesNames.CHAT_SCREEN,
                arguments: {"name": userModel.name, "uid": userModel.uid});
          }
        }
      }

      if (!isContactFound) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showSnackBar(
              context: context, content: "Contact not found on WhatsChatApp");
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
