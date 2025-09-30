import 'package:ecommerce/core/common/widget/common_scaffold.dart';
import 'package:ecommerce/core/toast.dart';
import 'package:ecommerce/role_selector.dart';
import 'package:flutter/material.dart';

import '../../../../call_screen.dart';
import '../../../../core/constants/agora_config.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../call/views/call_screen.dart';

class HomePage extends StatefulWidget {
  final UserEntity user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> loadAppConfig() async {
    return AgoraConfig().loadInitialConfig();
  }

  @override
  void initState() {
    loadAppConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Home Dashboard",
      showAppBar: true,
      body: Stack(
        children: [
          Column(
            children: [
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
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: "call",
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CallScreen(
                      channelName: AgoraConfig().channel,
                      token: AgoraConfig().token,
                      appId: AgoraConfig().appId,
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
              if (AgoraConfig().config == null ||
                  AgoraConfig().config!.channel.isEmpty) {
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
              if (AgoraConfig().config == null ||
                  AgoraConfig().config!.channel.isEmpty) {
                fToast("No channel found");
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CallScreenDemo(
                      channelName: AgoraConfig().config!.channel,
                      token: AgoraConfig().config!.token,
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
