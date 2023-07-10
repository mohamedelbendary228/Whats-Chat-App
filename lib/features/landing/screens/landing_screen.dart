import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/core/widgets/error_screen.dart';
import 'package:whats_chat_app/core/widgets/loading_screen.dart';
import 'package:whats_chat_app/features/auth/provider/auth_provider.dart';
import 'package:whats_chat_app/features/landing/screens/welcome_screen.dart';
import 'package:whats_chat_app/screens/mobile_layout_screen.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userDataProvider);
    return userRef.when(
        data: (user) {
          if (user == null) {
            return const WelcomePage();
          }
          return const MobileLayoutScreen();
        },
        error: (e, _) {
          return ErrorPage(error: e.toString());
        },
        loading: () => const LoaderPage());
  }
}
