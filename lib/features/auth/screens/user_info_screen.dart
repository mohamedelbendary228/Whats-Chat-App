import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/constants/app_constants.dart';
import 'package:whats_chat_app/core/utils/utils.dart';
import 'package:whats_chat_app/core/widgets/custom_button.dart';
import 'package:whats_chat_app/features/auth/provider/auth_provider.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  const UserInfoPage({super.key});

  @override
  ConsumerState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final TextEditingController nameController = TextEditingController();
  File? image;
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  Future<void> storeUserData() async {
    String name = nameController.text.trim();
    FocusScope.of(context).unfocus();
    if (name.isNotEmpty) {
      setState(() {
        loading = true;
        debugPrint("loading $loading");
      });
      await Future.delayed(const Duration(seconds: 1));
      if(mounted) {
         await ref.read(authControllerProvider).saveUserDataToFirestore(
            name: name, profilePic: image, context: context);
      }
      setState(() {
        loading = false;
        debugPrint("loading $loading");
      });
    } else {
      showSnackBar(context: context, content: "Please enter your name!");
    }

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          backgroundImage: NetworkImage(
                            AppConstants.DUMMY_PROFILE_PIC,
                          ),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: size.width * 0.85,
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                  ),
                ),
              ),
              const Spacer(),
              loading? const CircularProgressIndicator(color: AppColors.tabColor) : SizedBox(
                width: 90.w,
                child:   CustomButton(
                  onPressed: storeUserData,
                  text: 'DONE',
                ),
              ),
              SizedBox(
                height: 50.h,
              )
            ],

          ),
        ),
      ),
    );
  }
}
