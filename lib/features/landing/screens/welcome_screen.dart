import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/widgets/custom_button.dart';
import 'package:whats_chat_app/router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Text(
                "Welcome to WhatsChatApp",
                style: TextStyle(fontSize: 27.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height / 13),
              Image.asset(
                "assets/bg.png",
                height: 320.h,
                width: 320.w,
                color: AppColors.tabColor,
              ),
              SizedBox(height: size.height / 15),
              const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Read out Privacy Policy, Tap "Agree and Continue" To accept the Terms and Services',
                  style: TextStyle(
                    color: AppColors.greyColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: size.width * 0.80,
                child: CustomButton(
                  text: "AGREE AND CONTINUE",
                  onPressed: () =>
                      Navigator.of(context).pushNamed(RoutesNames.LOGIN_SCREEN),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
