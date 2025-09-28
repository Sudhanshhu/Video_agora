// import 'package:flutter/material.dart';
// import '../../controllers/call_controller.dart';

// class CallControls extends StatelessWidget {
//   const CallControls({super.key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         // Mute / Unmute
//         FloatingActionButton(
//           heroTag: 'fab_mute',
//           onPressed: controller.toggleMute,
//           backgroundColor: Colors.white,
//           child: Icon(
//             controller.isMuted ? Icons.mic_off : Icons.mic,
//             color: Colors.black,
//           ),
//         ),

//         // Enable / Disable Camera
//         FloatingActionButton(
//           heroTag: 'fab_videotoogle',
//           onPressed: controller.toggleVideo,
//           backgroundColor: Colors.white,
//           child: Icon(
//             controller.isVideoEnabled ? Icons.videocam : Icons.videocam_off,
//             color: Colors.black,
//           ),
//         ),

//         // Screen Share
//         FloatingActionButton(
//           heroTag: 'fab_videosharing', // <-- unique tag
//           onPressed: controller.isScreenSharing
//               ? controller.stopScreenShare
//               : () => controller.startScreenShare("token", "test_channel"),
//           backgroundColor: Colors.white,
//           child: Icon(
//             controller.isScreenSharing
//                 ? Icons.stop_screen_share
//                 : Icons.screen_share,
//             color: Colors.black,
//           ),
//         ),

//         // End Call
//         FloatingActionButton(
//           onPressed: () async {
//             controller.leaveCall();
//             Navigator.of(context).pop();
//           },
//           backgroundColor: Colors.red,
//           child: const Icon(Icons.call_end, color: Colors.white),
//         ),
//       ],
//     );
//   }
// }
