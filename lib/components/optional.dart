import 'package:flutter/material.dart';

class Optional extends StatelessWidget {
  const Optional({super.key, required this.condition, required this.child});

  final bool condition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (condition) return child;
    return const SizedBox.shrink();
  }
}
