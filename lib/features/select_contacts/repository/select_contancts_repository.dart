import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_codes/country_codes.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/model/user_model.dart';
import 'package:whats_chat_app/router.dart';

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  Future<void> selectContact(
      Contact selectedContact, BuildContext context) async {
    final CountryDetails details = CountryCodes.detailsForLocale();
    String countryCode = details.dialCode.toString();
    bool isContactFound = false;
    try {
      var userCollection = await firestore.collection("users").get();
      for (var doc in userCollection.docs) {
        var userModel = UserModel.fromJson(doc.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (!selectedPhoneNumber.contains("+")) {
          selectedPhoneNumber = countryCode + selectedPhoneNumber;
        }
        if (selectedPhoneNumber == userModel.phoneNumber) {
          isContactFound = true;
          if (context.mounted) {
            await Navigator.of(context).pushReplacementNamed(
                RoutesNames.CHAT_SCREEN,
                arguments: {"name": userModel.name, "uid": userModel.uid});
          }
        }
      }
      if (!isContactFound) {
        if (context.mounted) {
          showSnackBar(
              context: context, content: "Contact not found on WhatsChatApp");
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
