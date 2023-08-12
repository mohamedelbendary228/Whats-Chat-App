import 'package:flutter/material.dart';
import 'package:whats_chat_app/colors.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
  }) : super(key: key);
  final String message;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        decoration: const BoxDecoration(
          color: AppColors.senderMessageColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 5, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Align(
    //   alignment: Alignment.centerLeft,
    //   child: ConstrainedBox(
    //     constraints: BoxConstraints(
    //       maxWidth: MediaQuery.of(context).size.width - 45,
    //     ),
    //     child: Card(
    //       elevation: 1,
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //       color: AppColors.senderMessageColor,
    //       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    //       child: Stack(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(
    //               left: 10,
    //               right: 30,
    //               top: 5,
    //               bottom: 20,
    //             ),
    //             child: Text(
    //               message,
    //               style: const TextStyle(
    //                 fontSize: 16,
    //               ),
    //             ),
    //           ),
    //           Positioned(
    //             bottom: 2,
    //             right: 10,
    //             child: Text(
    //               date,
    //               style: TextStyle(
    //                 fontSize: 13,
    //                 color: Colors.grey[600],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
