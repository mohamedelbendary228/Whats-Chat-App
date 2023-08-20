import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;

  const CachedImageWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, _) => SizedBox(
        width: size.width * 0.5,
        child: Opacity(
            opacity: 0.5,
            child: Icon(Icons.photo_camera_back, size: size.width * 0.5)),
      ),
      errorWidget: (context, _, __) => Column(
        children: [
          SizedBox(
            width: size.width * 0.5,
            child: Opacity(
                opacity: 0.5,
                child: Icon(Icons.photo_camera_back, size: size.width * 0.5)),
          ),
          const Text(("Failed to load photo"))
        ],
      ),
    );
  }
}
