import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/core/widgets/custom_button.dart';

class LoinPage extends StatefulWidget {
  const LoinPage({Key? key}) : super(key: key);

  @override
  State<LoinPage> createState() => _LoinPageState();
}

class _LoinPageState extends State<LoinPage> {
  final TextEditingController phoneController = TextEditingController();
  Country? selectedCountry;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          setState(() {
            selectedCountry = country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    FocusScope.of(context).unfocus();
    if (selectedCountry != null && phoneNumber.isNotEmpty) {

    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            children: [
              const Text('WhatsChatApp will need to verify your phone number.'),
              SizedBox(height: 10.h),
              TextButton(
                onPressed: pickCountry,
                child: const Text('Pick Country'),
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  if (selectedCountry != null)
                    Text('+${selectedCountry!.phoneCode}'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          hintText: 'phone number',
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.tabColor))),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 90.w,
                child: CustomButton(
                  onPressed: sendPhoneNumber,
                  text: 'NEXT',
                ),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
