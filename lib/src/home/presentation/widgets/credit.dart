// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreditWidget extends StatefulWidget {
  final String userId;
  final VoidCallback? onPressed;
  const CreditWidget({
    super.key,
    required this.userId,
    this.onPressed,
  });

  @override
  State<CreditWidget> createState() => _CreditWidgetState();
}

class _CreditWidgetState extends State<CreditWidget>
    with SingleTickerProviderStateMixin {
  int oldCredits = 0;
  bool showLottie = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() async {
    await _controller.forward(from: 0.0);
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasData) {
          final credits = (snapshot.data?.data() ?? {})['credits'] ?? 0;

          if (credits > oldCredits) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onPressed?.call();
              _playAnimation();
            });
          }
          oldCredits = credits;

          return ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 2.3).animate(
              CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.yellow),
                  const SizedBox(width: 4),
                  Text(
                    credits.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
