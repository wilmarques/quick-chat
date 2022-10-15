import 'package:url_launcher/url_launcher.dart';

enum LinkOpenerTarget {
  whatsapp,
  telegram,
}

class LinkOpener {
  const LinkOpener();

  openLink({String? link, required LinkOpenerTarget target}) async {
    if (link == null || link == '') {
      throw 'No valid number provided';
    }

    if (target == LinkOpenerTarget.whatsapp) {
      _openLinkInWhatsApp(link);
    } else {
      throw 'Target not available';
    }
  }

  _openLinkInWhatsApp(String link) async {
    final whatsAppUri = Uri(scheme: 'whatsapp', host: 'send', queryParameters: {
      'phone': link,
    });

    await launchUrl(whatsAppUri);
  }
}
