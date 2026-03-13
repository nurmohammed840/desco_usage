import 'package:flutter/material.dart';

import '/components/optional.dart';
import '/signal.dart';

Future<T> showLoadingIndicator<T>(Future<T> Function() cb) async {
  final isLoading = LoadingIndicatorWidget.isLoading;
  
  isLoading.set(isLoading.value + 1);
  try {
    return await cb();
  } finally {
    isLoading.set(isLoading.value - 1);
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  static final isLoading = CreateState(0);

  @override
  Widget build(BuildContext context) {
    return isLoading.watch(
      (_) => Optional(
        condition: isLoading.value > 0,
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
