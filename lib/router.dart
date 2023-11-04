import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_chat_app/core/widgets/error_screen.dart';
import 'package:whats_chat_app/features/auth/screens/login_screen.dart';
import 'package:whats_chat_app/features/auth/screens/otp_screen.dart';
import 'package:whats_chat_app/features/auth/screens/user_info_screen.dart';
import 'package:whats_chat_app/features/group_chat/screens/create_group_chat_screen.dart';
import 'package:whats_chat_app/features/landing/screens/landing_screen.dart';
import 'package:whats_chat_app/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whats_chat_app/features/chat/screens/chat_screen.dart';
import 'package:whats_chat_app/features/status/screens/confirm_status_screen.dart';
import 'package:whats_chat_app/features/status/screens/status_viewer_screen.dart';
import 'package:whats_chat_app/models/status_model.dart';

class RoutesNames {
  RoutesNames._();

  static const String LANDING_SCREEN = "/";
  static const String LOGIN_SCREEN = "/login_screen";
  static const String OTP_SCREEN = "/otp_screen";
  static const String USER_INFO_SCREEN = "/user_info_screen";
  static const String SELECT_CONTACT = "/select_contact";
  static const String CHAT_SCREEN = "/chat_screen";
  static const String CONFIRM_STATUS_SCREEN = "/confirm_status_screen";
  static const String STATUS_VIEWER_SCREEN = "/status_viewer_screen";
  static const String CREATE_GROUP_CHAT_SCREEN = "/create_group_chat_screen";
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
    case RoutesNames.CHAT_SCREEN:
      final args = settings.arguments as Map<String, dynamic>;
      String name = args["name"];
      String uid = args["uid"];
      String profilePic = args["profilePic"];
      bool isGroupChat = args["isGroup"];
      return MaterialPageRoute(
        builder: (context) => ChatScreen(name: name, uid: uid, isGroupChat: isGroupChat, profilePic: profilePic),
      );
    case RoutesNames.CONFIRM_STATUS_SCREEN:
      File file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(file: file),
      );
    case RoutesNames.STATUS_VIEWER_SCREEN:
      StatusModel statusModel = settings.arguments as StatusModel;
      return MaterialPageRoute(
        builder: (context) => StatusViewerScreen(status: statusModel),
      );
    case RoutesNames.CREATE_GROUP_CHAT_SCREEN:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupChatScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorPage(error: "This page doesn't exist"),
        ),
      );
  }
}
