import 'package:clipboard/clipboard.dart';

class ClipboardHandler {
  const ClipboardHandler();

  paste() async {
    return FlutterClipboard.paste();
  }

  copy(String text) async {
    return FlutterClipboard.copy(text);
  }
}
