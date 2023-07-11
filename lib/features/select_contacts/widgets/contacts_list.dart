import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_chat_app/core/contants/app_constants.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;

  const ContactsList({Key? key, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: ListTile(
              title: Text(
                contact.displayName,
                style: TextStyle(fontSize: 18.sp),
              ),
              leading: contact.photo == null
                  ? const CircleAvatar(
                      backgroundImage:
                          NetworkImage(AppConstants.DUMMY_PROFILE_PIC),
                    )
                  : CircleAvatar(
                      backgroundImage: MemoryImage(contact.photo!),
                    ),
            ),
          );
        },
      ),
    );
  }
}
