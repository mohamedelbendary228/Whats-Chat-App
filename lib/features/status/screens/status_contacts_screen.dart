import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/core/widgets/loading_screen.dart';
import 'package:whats_chat_app/features/status/provider/status_provider.dart';
import 'package:whats_chat_app/features/status/screens/widgets/status_list.dart';
import 'package:whats_chat_app/models/status_model.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<StatusModel>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, statusSnapshot) {
        if (statusSnapshot.connectionState == ConnectionState.waiting) {
          return const LoaderPage();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ListView.builder(
            itemCount: statusSnapshot.data!.length,
            itemBuilder: (context, index) {
              return StatusList(
                status: statusSnapshot.data![index],
              );
            },
          ),
        );
      },
    );
  }
}
