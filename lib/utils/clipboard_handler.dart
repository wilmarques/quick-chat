import 'package:clipboard/clipboard.dart';

class ClipboardHandler {
  const ClipboardHandler();

  Future<String> paste() async {
    return FlutterClipboard.paste();
  }

  Future<void> copy(String text) async {
    return FlutterClipboard.copy(text);
  }
}
