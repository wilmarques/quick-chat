import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'dart:ui' as ui;

import '../utils/clipboard_handler.dart';
import '../utils/link_opener.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final linkOpener = const LinkOpener();
  final clipboardHandler = const ClipboardHandler();

  final _phoneNumberController = PhoneController(PhoneNumber(
      isoCode: IsoCode.values.byName(ui.window.locale.countryCode ?? 'US'),
      nsn: ''));

  void _pasteFromClipboard() async {
    try {
      final clipboardValue = await clipboardHandler.paste();
      setState(() {
        _phoneNumberController.value = PhoneNumber.parse(clipboardValue,
            callerCountry:
                IsoCode.values.byName(ui.window.locale.countryCode ?? 'US'));
      });
    } catch (exception) {
      throw 'Could not read from clipboard';
    }
  }

  void _openInWhatsapp() async {
    final phone = _phoneNumberController.value?.international;
    _openPhoneOnTarget(phone, LinkOpenerTarget.whatsapp);
  }

  void _openPhoneOnTarget(String? phone, LinkOpenerTarget target) async {
    try {
      await linkOpener.openLink(
        link: phone,
        target: target,
      );
    } catch (exception) {
      // TODO: Handle exception and give visual feedback to users
      throw 'Could not launch $phone';
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
