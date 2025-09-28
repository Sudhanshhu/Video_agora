import 'package:ecommerce/core/common/widget/common_scaffold.dart';
import 'package:ecommerce/core/toast.dart';
import 'package:ecommerce/role_selector.dart';
import 'package:ecommerce/src/call/views/bloc/call_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../adv_videocall.dart';
import '../../../../call_screen.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/utils/media_res.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../call/views/call_screen.dart';
import '../bloc/home_bloc.dart';
import '../widgets/credit.dart';

class HomePage extends StatefulWidget {
  final UserEntity user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showLottie = false; // Track when to show the Lottie animation

  void _showLottie() {
    setState(() => showLottie = true);

    // Hide automatically after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => showLottie = false);
      }
    });
  }

  Future<void> loadAppConfig() async {
    return AppConfig().loadInitialConfig();
  }

  @override
  void initState() {
    loadAppConfig();
    super.initState();
  }

  void _showCreateEventDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<HomeBloc>().add(
                    CreateEventEvent(
                      titleController.text,
                      descriptionController.text,
                      DateTime.now(),
                      widget.user.uid,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = widget.user.uid;

    return CommonScaffold(
      title: "Home Dashboard",
      showAppBar: true,
      actions: [
        IconButton(
          onPressed: () {
            _showLottie(); // Show Lottie animation
          },
          icon: const Icon(Icons.refresh),
        ),
        CreditWidget(userId: userId, onPressed: _showLottie),
      ],
      body: Stack(
        children: [
          /// Your main UI
          Column(
            children: [
              // Replace this with your real dashboard widgets
              Expanded(
                child: Center(
                  child: Text(
                    'Home Content Here',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ],
          ),

          /// Lottie Animation at Bottom
          if (showLottie)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Lottie.asset(
                  MediaRes.confetti,
                  repeat: false,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: "videoCall",
            onPressed: () async {
              const myUid = 111; // Example UID: 8765

              if (AppConfig().config == null || AppConfig().channel.isEmpty) {
                fToast("No channel found");
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AdvancedVideoCallScreen(
                          channelName: AppConfig().channel,
                          token: AppConfig().token,
                          appId: AppConfig().appId,
                        )),
              );
            },
            backgroundColor: Colors.grey,
            child: const Icon(
              Icons.video_call,
            ),
          ),
          FloatingActionButton(
            heroTag: "call",
            onPressed: () async {
              const myUid = 111; // Example UID: 8765
              final userData = await fetchTokenFromFs(myUid);

              if (AppConfig().config == null ||
                  AppConfig().channel.isEmpty ||
                  userData == null) {
                fToast("No channel found");
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => CallBloc(),
                      child: CallScreen(
                        channelName: AppConfig().channel,
                        token: userData.token,
                        uid: myUid,
                      ),
                    );
                  },
                ),
              );
            },
            backgroundColor: Colors.green,
            child: const Icon(
              Icons.call,
            ),
          ),
          FloatingActionButton(
            heroTag: "broadcast",
            onPressed: () {
              if (AppConfig().config == null ||
                  AppConfig().config!.channel.isEmpty) {
                fToast("No channel found");
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const RoleSelectionScreen();
                  },
                ),
              );
            },
            child: const Icon(
              Icons.broadcast_on_personal,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              if (AppConfig().config == null ||
                  AppConfig().config!.channel.isEmpty) {
                fToast("No channel found");
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CallScreenDemo(
                      channelName: AppConfig().config!.channel,
                      token: AppConfig().config!.token,
                      uid: 0,
                    );
                  },
                ),
              );
            },
            child: const Icon(
              Icons.call_merge,
            ),
          ),
        ],
      ),
    );
  }
}
