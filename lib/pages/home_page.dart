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

  final _phoneNumberController = PhoneController(PhoneNumber.fromIsoCode(
      IsoCode.values.byName(ui.window.locale.countryCode ?? 'US'), ''));

  String _parseCompleteNumber() {
    final parsedNumber = _phoneNumberController.value?.international ?? '';
    return parsedNumber;
  }

  void _pasteFromClipboard() {
    FlutterClipboard.paste().then((value) {
      setState(() {
        _phoneNumberController.value = PhoneNumber.fromIsoCode(
            IsoCode.values.byName(ui.window.locale.countryCode ?? 'US'), value);
      });
    });
  }

  void _openInWhatsapp() async {
    final whatsAppUri = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {
        'phone': _parseCompleteNumber(),
      },
    );

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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Welcome to Quick Chat!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              PhoneFormField(
                controller: _phoneNumberController,
              ),
              ElevatedButton.icon(
                onPressed: _pasteFromClipboard,
                icon: const Icon(Icons.paste, size: 18),
                label: const Text('Paste'),
              ),
              ElevatedButton.icon(
                onPressed: _openInWhatsapp,
                icon: const Icon(Icons.whatsapp, size: 18),
                label: const Text('Open in WhatsApp'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
