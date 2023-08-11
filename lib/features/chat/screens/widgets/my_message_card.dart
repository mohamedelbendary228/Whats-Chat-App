import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whats_chat_app/colors.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;

  const MyMessageCard({Key? key, required this.message, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: const BoxDecoration(
            color: AppColors.messageColor,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), ,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    top: 5,
                    bottom: 25,
                    start: 20,
                    end: 10
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 0,
                child: Row(
                  children: [
                    Text(
                      date,
                      style:const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
