import 'package:flutter/material.dart';

import 'theme.dart';

import 'pages/home_page.dart';

class QuickChatApp extends StatelessWidget {
  const QuickChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Chat',
      theme: quickChatLightTheme,
      home: const HomePage(),
    );
  }
}
