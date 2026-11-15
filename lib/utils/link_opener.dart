import 'package:url_launcher/url_launcher.dart';

enum LinkOpenerTarget {
  whatsapp('WhatsApp'),
  telegram('Telegram');

  const LinkOpenerTarget(this.label);

  final String label;
}

class LinkOpener {
  const LinkOpener();

  Future<void> openLink({
    String? link,
    required LinkOpenerTarget target,
  }) async {
    if (link == null || link == '') {
      throw 'No valid number provided';
    }

    switch (target) {
      case LinkOpenerTarget.whatsapp:
        await _openLinkInWhatsApp(link);
      case LinkOpenerTarget.telegram:
        await _openLinkInTelegram(link);
    }
  }

  Future<void> _openLinkInWhatsApp(String link) async {
    final whatsAppUri = Uri(
      scheme: 'whatsapp',
      host: 'send',
      queryParameters: {'phone': link},
    );

    if (!await launchUrl(whatsAppUri)) {
      throw StateError('Could not open WhatsApp');
    }
  }

  Future<void> _openLinkInTelegram(String link) async {
    final telegramUri = Uri.https('t.me', '/$link');

    if (!await launchUrl(telegramUri, mode: LaunchMode.externalApplication)) {
      throw StateError('Could not open Telegram');
    }
  }
}
