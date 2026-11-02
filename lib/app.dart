import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import 'theme.dart';

import 'pages/home_page.dart';

class QuickChatApp extends StatelessWidget {
  const QuickChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Chat',
      theme: quickChatLightTheme,
      localizationsDelegates: PhoneFieldLocalization.delegates,
      home: const HomePage(),
    );
  }
}
