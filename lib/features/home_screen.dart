import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/features/auth/provider/auth_provider.dart';
import 'package:whats_chat_app/features/chats_contacts/screens/chats_contacts_screen.dart';
import 'package:whats_chat_app/features/status/screens/status_contacts_screen.dart';
import 'package:whats_chat_app/router.dart';

class MainHomeScreen extends ConsumerStatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends ConsumerState<MainHomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late TabController tabController;
  Widget floatingButton = const Icon(Icons.comment);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 3, vsync: this);
  }

  /// Change online state based on the AppLifeCycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void setFloatingButton(int index) {
    debugPrint("Indexxx $index");
    if (index == 0) {
      floatingButton = const Icon(Icons.comment);
    } else if (index == 1) {
      floatingButton = const Icon(Icons.camera_alt);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appBarColor,
        centerTitle: false,
        title: const Text(
          'WhatsAppChat',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text(
                    'Create Group',
                  ),
                  onTap: () {
                    /// using [Future] here because the [onTap] of the [PopupMenuItem] calls pop function
                    /// to dismiss itself so when you push another route it will dismiss it immediately
                    /// and Future here solve this problem
                    Future(() => Navigator.of(context)
                        .pushNamed(RoutesNames.CREATE_GROUP_CHAT_SCREEN));
                  },
                )
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorColor: AppColors.tabColor,
          indicatorWeight: 4,
          labelColor: AppColors.tabColor,
          unselectedLabelColor: Colors.grey,
          onTap: setFloatingButton,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(
              text: 'CHATS',
            ),
            Tab(
              text: 'STATUS',
            ),
            Tab(
              text: 'CALLS',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          const ChatsContactsScreen(),
          const StatusContactsScreen(),
          Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tabController.index == 0) {
            Navigator.of(context).pushNamed(RoutesNames.SELECT_CONTACT);
          } else {
            File? pickedImage = await pickImageFromGallery(context);
            if (pickedImage != null) {
              if (mounted) {
                await Navigator.of(context).pushNamed(
                    RoutesNames.CONFIRM_STATUS_SCREEN,
                    arguments: pickedImage);
              }
            }
          }
        },
        backgroundColor: AppColors.tabColor,
        child: floatingButton,
      ),
    );
  }
}
