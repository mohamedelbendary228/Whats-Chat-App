import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/config/agora_config.dart';
import 'package:whats_chat_app/core/widgets/loading_screen.dart';
import 'package:whats_chat_app/features/call/controller/call_controller.dart';
import 'package:whats_chat_app/models/call_model.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final CallModel callModel;
  final bool isGroupChat;

  const CallScreen({
    super.key,
    required this.channelId,
    required this.callModel,
    required this.isGroupChat,
  });

  @override
  ConsumerState createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? agoraClient;
  String baseUrl = "https://whatsapp-clone-rrr.herokuapp.com";

  @override
  void initState() {
    super.initState();
    agoraClient = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  Future<void> initAgora() async {
    await agoraClient!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: agoraClient == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: agoraClient!),
                  AgoraVideoButtons(
                    client: agoraClient!,
                    disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await agoraClient!.engine.leaveChannel();
                        if (context.mounted) {
                          ref.read(callControllerProvider).endCall(
                              widget.callModel.callerId,
                              widget.callModel.receiverId,
                              context);
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.call_end),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
