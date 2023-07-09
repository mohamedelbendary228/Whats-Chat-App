import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/features/landing/screens/landing_screen.dart';
import 'package:whats_chat_app/firebase_options.dart';
import 'package:whats_chat_app/router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WhatsAppChat',
          theme: ThemeData.dark().copyWith(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.backgroundColor,
          ),
          onGenerateRoute: (settings) => generateRoute(settings),
          home: const LandingPage(),
        );
      },
    );
  }
}
