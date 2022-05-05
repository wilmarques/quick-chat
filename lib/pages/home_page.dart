import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  final _phoneNumberTEC = TextEditingController();

  String _parseCompleteNumber() {
    return _phoneNumberTEC.text;
  }

  void _openInWhatsapp() async {
    final completePhoneNumber = _parseCompleteNumber();
    final whatsAppUri = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {
        'phone': completePhoneNumber,
      },
    );

    if (await canLaunchUrl(whatsAppUri)) {
      await launchUrl(whatsAppUri);
    } else {
      throw 'Could not launch $whatsAppUri';
    }
  }

  void _pasteFromClipboard() async {
    final clipboardValue = await FlutterClipboard.paste();
    setState(() {
      _phoneNumberTEC.text = clipboardValue;
    });
  }

  // _openInTelegram() async {}

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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter the Phone Number',
                  hintText: 'Phone Number',
                ),
                controller: _phoneNumberTEC,
                keyboardType: TextInputType.phone,
              ),
              ElevatedButton.icon(
                onPressed: _openInWhatsapp,
                icon: const Icon(Icons.whatsapp, size: 18),
                label: const Text('Open in WhatsApp'),
                // style: ButtonStyle(
                //   backgroundColor: Color(Colors.green),
                // ),
              ),
              ElevatedButton.icon(
                onPressed: _pasteFromClipboard,
                icon: const Icon(Icons.paste, size: 18),
                label: const Text('Paste from Clipboard'),
              ),
              ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.telegram, size: 18),
                label: const Text('Open in Telegram'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
