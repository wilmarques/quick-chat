import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:quick_chat/pages/home_page.dart';
import 'package:quick_chat/theme.dart';
import 'package:quick_chat/utils/link_opener.dart';
import 'package:quick_chat/utils/recent_numbers_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeLinkOpener extends LinkOpener {
  final opened = <String>[];
  bool fail = false;

  @override
  Future<void> openLink({
    String? link,
    required LinkOpenerTarget target,
  }) async {
    if (fail) throw StateError('Unavailable');
    opened.add(link!);
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> showHome(WidgetTester tester, FakeLinkOpener opener) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: quickChatLightTheme,
        localizationsDelegates: PhoneFieldLocalization.delegates,
        home: HomePage(linkOpener: opener),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('records successful opens, reopens and restores history', (
    tester,
  ) async {
    final opener = FakeLinkOpener();
    await showHome(tester, opener);
    expect(find.text('Recent numbers'), findsNothing);
    await tester.enterText(
      find.byKey(const Key('phone_number_field')),
      '2025550148',
    );
    await tester.tap(find.byKey(const Key('open_in_whatsapp_button')));
    await tester.pumpAndSettle();
    expect(opener.opened, ['+12025550148']);
    expect(find.text('Recent numbers'), findsOneWidget);
    const row = ValueKey('recent_+12025550148');
    expect(
      find.text(PhoneNumber.parse('+12025550148').international),
      findsOneWidget,
    );
    await tester.tap(find.byKey(row));
    await tester.pumpAndSettle();
    expect(opener.opened, ['+12025550148', '+12025550148']);
    expect(find.byKey(row), findsOneWidget);
    expect((await const RecentNumbersStore().load()).length, 1);
    await tester.pumpWidget(const SizedBox());
    await showHome(tester, opener);
    expect(find.byKey(row), findsOneWidget);
  });

  testWidgets('invalid numbers and failed launches do not enter history', (
    tester,
  ) async {
    final opener = FakeLinkOpener()..fail = true;
    await showHome(tester, opener);
    await tester.tap(find.byKey(const Key('open_in_whatsapp_button')));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid phone number.'), findsOneWidget);
    expect(opener.opened, isEmpty);
    await tester.enterText(
      find.byKey(const Key('phone_number_field')),
      '2025550148',
    );
    await tester.tap(find.byKey(const Key('open_in_whatsapp_button')));
    await tester.pumpAndSettle();
    expect(find.text('Recent numbers'), findsNothing);
    expect(await const RecentNumbersStore().load(), isEmpty);
  });

  testWidgets('clearing history requires confirmation and persists', (
    tester,
  ) async {
    await const RecentNumbersStore().save([
      RecentNumber(phone: '+12025550148', openedAt: DateTime.now()),
    ]);
    await showHome(tester, FakeLinkOpener());
    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Recent numbers'), findsOneWidget);
    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear history'));
    await tester.pumpAndSettle();
    expect(find.text('Recent numbers'), findsNothing);
    expect(await const RecentNumbersStore().load(), isEmpty);
  });
}
