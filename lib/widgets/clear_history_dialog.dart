import 'package:flutter/material.dart';

Future<bool> confirmClearHistory(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Clear recent numbers?'),
      content: const Text(
        'This removes the history saved on this device. Your WhatsApp chats are not affected.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Clear history'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
