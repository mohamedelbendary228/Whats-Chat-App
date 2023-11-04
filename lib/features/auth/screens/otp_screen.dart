import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/features/auth/controller/auth_controller.dart';

class OTPPage extends ConsumerWidget {
  final String verificationId;

  OTPPage({Key? key, required this.verificationId}) : super(key: key);

  final verificationCodeController = TextEditingController();

  void verifyOTP(WidgetRef ref, BuildContext context, String smsCode) {
    ref.read(authControllerProvider).verifyOTP(
          context: context,
          verificationId: verificationId,
          smsCode: smsCode,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            const Text('We have sent an SMS with a code.'),
            SizedBox(height: 30.h),
            Pinput(
              controller: verificationCodeController,
              length: 6,
              defaultPinTheme: PinTheme(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: AppColors.messageColor.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onCompleted: (code) {
                debugPrint("verification code $code");
                verifyOTP(ref, context, code);
              },
            ),
          ],
        ),
      ),
    );
  }
}
