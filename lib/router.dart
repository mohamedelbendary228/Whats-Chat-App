import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_chat_app/core/widgets/error_screen.dart';
import 'package:whats_chat_app/features/auth/screens/login_screen.dart';
import 'package:whats_chat_app/features/auth/screens/otp_screen.dart';
import 'package:whats_chat_app/features/auth/screens/user_info_screen.dart';

class RoutesNames {
  RoutesNames._();

  static const String LOGIN_SCREEN = "/login_screen";
  static const String OTP_SCREEN = "/otp_screen";
  static const String USER_INFO_SCREEN = "/user_info_screen";
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesNames.LOGIN_SCREEN:
      return MaterialPageRoute(
        builder: (context) => const LoinPage(),
      );
    case RoutesNames.OTP_SCREEN:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPPage(verificationId: verificationId),
      );
    case RoutesNames.USER_INFO_SCREEN:
      return MaterialPageRoute(
        builder: (context) => const UserInfoPage(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorPage(error: "This page doesn't exist"),
        ),
      );
  }
}
