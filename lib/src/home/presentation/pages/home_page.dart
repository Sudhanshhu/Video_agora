import 'package:ecommerce/core/common/widget/common_scaffold.dart';
import 'package:ecommerce/core/common/widget/error_view.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/agora_config.dart';
import '../../../call/views/call_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Users",
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          // When a new user is added
          if (state.status == HomeStatus.success) {
            final previousLength = _listKey.currentState == null
                ? 0
                : _listKey.currentState!.widget.initialItemCount;

            if (state.users.length > previousLength) {
              _listKey.currentState?.insertItem(0);
            }
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case HomeStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case HomeStatus.failure:
              return ErrorViewWidget(
                msg: state.error ?? "An error occurred",
                onRetry: () {
                  context.read<HomeBloc>().add(FetchUsers());
                },
              );

            case HomeStatus.success:
              return AnimatedList(
                key: _listKey,
                initialItemCount: state.users.length,
                itemBuilder: (context, index, animation) {
                  final user = state.users[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: _buildUserDetail(
                      title: user.name,
                      subtitle: user.email,
                      email: user.email,
                      icon: Icons.person,
                      color: Colors.blue,
                      onTap: () {
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
                    ),
                  );
                },
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildUserDetail({
    required String title,
    required String subtitle,
    required IconData icon,
    required String email,
    required VoidCallback onTap,
    Color color = Colors.green,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.video_call, color: color, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
