import 'package:flutter/material.dart';
import '../../domain/entities/event_entity.dart';

class EventCard extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        onTap: onTap,
        title: Text(event.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(event.description),
        trailing: event.isStreaming
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Text('LIVE', style: TextStyle(color: Colors.white)),
              )
            : null,
      ),
    );
  }
}
