import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/features/status/provider/status_provider.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  final File file;

  const ConfirmStatusScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(statusControllerProvider).addStatus(file, context);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        backgroundColor: AppColors.tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
