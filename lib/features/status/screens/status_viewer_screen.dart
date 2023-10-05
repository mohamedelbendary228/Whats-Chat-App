import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whats_chat_app/colors.dart';
import 'package:whats_chat_app/core/widgets/loading_screen.dart';
import 'package:whats_chat_app/models/status_model.dart';

class StatusViewerScreen extends StatefulWidget {
  final StatusModel status;

  const StatusViewerScreen({Key? key, required this.status}) : super(key: key);

  @override
  State<StatusViewerScreen> createState() => _StatusViewerScreenState();
}

class _StatusViewerScreenState extends State<StatusViewerScreen> {
  late StoryController controller;
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    controller = StoryController();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (var imageUrl in widget.status.statusImagesUrls) {
      storyItems.add(
        StoryItem.pageImage(url: imageUrl, controller: controller),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: storyItems.isEmpty
          ? const LoaderPage()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.of(context).pop();
                }
              },
              onComplete: () {
                Navigator.of(context).pop();
              },
            ),
    );
  }
}
