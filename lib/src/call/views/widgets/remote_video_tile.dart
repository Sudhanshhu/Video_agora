import 'package:ecommerce/core/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../../../core/services/agora_service.dart';

class RemoteVideoTile extends StatelessWidget {
  final int uid;

  const RemoteVideoTile({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: AgoraService().engine,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: AppConfig().channel),
      ),
    );
  }
}
