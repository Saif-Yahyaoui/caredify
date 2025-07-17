import 'package:flutter/material.dart';

class VitalCard extends StatelessWidget {
  final String title;
  final String value;
  final String time;
  final Color color;
  const VitalCard({
    required this.title,
    required this.value,
    required this.time,
    required this.color,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withAlpha((0.15 * 255).toInt()),
            child: Icon(Icons.favorite, color: color),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          subtitle: Text(value),
          trailing: Text(
            time,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
