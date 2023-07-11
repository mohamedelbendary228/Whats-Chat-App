import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_chat_app/core/widgets/error_screen.dart';
import 'package:whats_chat_app/features/auth/screens/login_screen.dart';
import 'package:whats_chat_app/features/auth/screens/otp_screen.dart';
import 'package:whats_chat_app/features/auth/screens/user_info_screen.dart';
import 'package:whats_chat_app/features/landing/screens/landing_screen.dart';
import 'package:whats_chat_app/features/select_contacts/screens/select_contacts_screen.dart';

class RoutesNames {
  RoutesNames._();

  static const String LANDING_SCREEN = "/";
  static const String LOGIN_SCREEN = "/login_screen";
  static const String OTP_SCREEN = "/otp_screen";
  static const String USER_INFO_SCREEN = "/user_info_screen";
  static const String SELECT_CONTACT = "/select_contact";
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesNames.LANDING_SCREEN:
      return MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      );
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
    case RoutesNames.SELECT_CONTACT:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsPage(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorPage(error: "This page doesn't exist"),
        ),
      );
  }
}
