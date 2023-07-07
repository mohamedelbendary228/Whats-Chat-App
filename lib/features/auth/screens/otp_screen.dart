import 'package:flutter/material.dart';

class OTPPage extends StatefulWidget {
  final String verificationCode;

  const OTPPage({Key? key, required this.verificationCode}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
