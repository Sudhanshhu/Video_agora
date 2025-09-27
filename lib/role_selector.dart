import 'package:ecommerce/broadcast.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Broadcast")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BroadCastAgora(
                      isBroadcaster: true,
                    ),
                  ),
                );
              },
              child: const Text("Start as Broadcaster"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BroadCastAgora(
                      isBroadcaster: false,
                    ),
                  ),
                );
              },
              child: const Text("Join as Audience"),
            ),
          ],
        ),
      ),
    );
  }
}
