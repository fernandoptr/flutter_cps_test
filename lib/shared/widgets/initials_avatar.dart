import 'package:flutter/material.dart';

class InitialsAvatar extends StatelessWidget {
  final String initial;
  final double size;

  const InitialsAvatar({
    super.key,
    required this.initial,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      child: Text(
        _getInitials(),
        style: TextStyle(fontSize: size * 0.35, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getInitials() {
    if (initial.isEmpty) {
      return 'NA';
    } else {
      return initial.substring(0, initial.length >= 2 ? 2 : 1).toUpperCase();
    }
  }
}
