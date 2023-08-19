import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CachedVideoWidget extends StatefulWidget {
  final String videoUrl;

  const CachedVideoWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<CachedVideoWidget> createState() => _CachedVideoWidgetState();
}

class _CachedVideoWidgetState extends State<CachedVideoWidget> {
  late CachedVideoPlayerController videoPlayerController;

  bool isPlaying = false;
  bool finishPlaying = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });

  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  void playOrPauseVideo() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      videoPlayerController.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: playOrPauseVideo,
              icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 40.sp),
            ),
          )
        ],
      ),
    );
  }
}
