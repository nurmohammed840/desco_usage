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

extension NullableWidget<T> on T? {
  Widget mapWidget(Widget Function(BuildContext context, T value) builder) =>
      Builder(
        builder: (context) {
          if (this == null) return const SizedBox.shrink();
          return builder(context, this as T);
        },
      );
}
