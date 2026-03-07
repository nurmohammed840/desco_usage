import 'package:desco_usage/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/signal.dart';

Future<String?> showNumberInputDialog({
  required BuildContext context,
  required String title,
  String? hintText,
  String? initialValue,
  String okLabel = 'Add',
  String cancelLabel = 'Cancel',
}) async {
  final isValid = CreateState(false);
  final controller = TextEditingController(text: initialValue);

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: isValid.watch(
        (_) => TextField(
          autofocus: true,
          controller: controller,
          keyboardType: .number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: hintText ?? '',
            errorText: isValid.value ? null : "Must be at least 8 digits",
            helperText: ' ',
          ),
          onChanged: (value) {
            isValid.set(value.length >= 8);
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text(cancelLabel),
          onPressed: () => Navigator.pop(context),
        ),
        isValid.watch(
          (_) => ElevatedButton(
            onPressed: isValid.value
                ? () => Navigator.pop(context, controller.text.trim())
                : null,

            child: Text(okLabel),
          ),
        ),
      ],
    ),
  );
}

Future<MeterInfo?> acceptMeterInfo(BuildContext context) async {
  final input = await showNumberInputDialog(
    context: context,
    title: 'Add Meter',
    hintText: 'Account or Meter number',
  );

  if (input == null || input.isEmpty) {
    return null;
  }

  if (input.length <= 8) {
    return MeterInfo.fromAccountNo(input);
  }

  return MeterInfo.fromMeterNo(input);
}
