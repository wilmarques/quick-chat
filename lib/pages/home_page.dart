import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  // final _currentLocale = Intl.getCurrentLocale().split('_').last;
  // final _currentLocale = await Devicelocale.currentLocale;

  // final _phoneNumberInitialValue = PhoneNumber.fromIsoCode(IsoCode.US, '');

  // IsoCode f = IsoCode.values.firstWhere((e) => e.toString() == 'US');
  final _phoneNumberController = PhoneController(PhoneNumber.fromIsoCode(IsoCode.US, ''));

  String _parseCompleteNumber() {
    final parsedNumber = _phoneNumberController.value?.international ?? '';
    return parsedNumber;
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

    if (await canLaunchUrl(whatsAppUri)) {
      await launchUrl(whatsAppUri);
    } else {
      throw 'Could not launch $whatsAppUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    // final locale = Devicelocale.currentLocale;
    _phoneNumberController.value = PhoneNumber.fromIsoCode(
      IsoCode.values.byName(Intl.getCurrentLocale().split('_').last), '');
    // _phoneNumberController.value = PhoneNumber.fromIsoCode(
    //   IsoCode.values.byName('BR'), '');

    // return FutureBuilder<String>(
    //   future: locale,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return Text(snapshot.data);
    //     } else {
    //       return Text('awaiting the future');
    //     }
    //   },
    // );

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
