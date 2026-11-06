import 'package:flutter/services.dart';

class ClipboardHandler {
  const ClipboardHandler();

  Future<String> paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text ?? '';
  }

  Future<void> copy(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }
}
