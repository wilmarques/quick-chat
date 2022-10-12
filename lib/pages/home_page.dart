import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  final _phoneNumberController = PhoneController(PhoneNumber(
      isoCode: IsoCode.values.byName(ui.window.locale.countryCode ?? 'US'),
      nsn: ''));

  String _parseCompleteNumber() {
    final parsedNumber = _phoneNumberController.value?.international ?? '';
    return parsedNumber;
  }

  void _pasteFromClipboard() {
    FlutterClipboard.paste().then((value) {
      setState(() {
        _phoneNumberController.value = PhoneNumber(
            isoCode:
                IsoCode.values.byName(ui.window.locale.countryCode ?? 'US'),
            nsn: '');
      });
    });
  }

  void _openInWhatsapp() async {
    final whatsAppUri = Uri(scheme: 'whatsapp', host: 'send', queryParameters: {
      'phone': _parseCompleteNumber(),
    });

    try {
      await launchUrl(whatsAppUri);
    } catch (exception) {
      throw 'Could not launch $whatsAppUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Chat'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 60.0),
            PhoneFormField(
              autofocus: true,
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Enter Phone Numer',
              ),
            ),
            const SizedBox(height: 40.0),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _openInWhatsapp,
                  icon: const Icon(Icons.whatsapp, size: 18),
                  label: const Text('Open in WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                  ),
                ),
                TextButton(
                  onPressed: _pasteFromClipboard,
                  child: const Text('Paste'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
