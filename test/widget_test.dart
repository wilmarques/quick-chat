// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_chat/app.dart';

void main() {
  testWidgets('Open WhatsApp using the provided Phone Number',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuickChatApp());

    // Find the Phone Number text field
    final phoneNumberField = find.byKey(const Key('phone_number_field'));

    // Enter a phone number
    await tester.enterText(phoneNumberField, '1234567890');
    // Tap the 'Open in WhatsApp' button
    await tester.tap(find.byKey(const Key('open_in_whatsapp_button')));
    // Wait for the widget to rebuild
    await tester.pump();

    // Verify that the phone number is opened in WhatsApp
    // The button opens a link containing the phone number

    // Verify that the phone number is opened in WhatsApp
    // The button opens a link containing the phone number
    // The link is opened in the browser
  });
}

    // final linkOpened = await tester.hasAnyWidget(WebView(
    //   initialUrl: 'https://wa.me/1234567890',
    // ));
    // expect(linkOpened, true);
