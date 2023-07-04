import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_chat_app/core/widgets/error_screen.dart';
import 'package:whats_chat_app/features/auth/screens/login_screen.dart';

class RoutesNames {
  RoutesNames._();

  static const String LOGIN_SCREEN = "/login_screen";
}

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case RoutesNames.LOGIN_SCREEN:
      return MaterialPageRoute(
        builder: (context) => const LoinPage(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorPage(error: "This page doesn't exist"),
        ),
      );
  }
}
