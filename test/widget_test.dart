import 'dart:async';

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
  final targets = <LinkOpenerTarget>[];
  bool fail = false;
  Completer<void>? pending;

  @override
  Future<void> openLink({
    String? link,
    required LinkOpenerTarget target,
  }) async {
    if (fail) throw StateError('Unavailable');
    opened.add(link!);
    targets.add(target);
    await pending?.future;
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
    expect(opener.targets, [
      LinkOpenerTarget.whatsapp,
      LinkOpenerTarget.whatsapp,
    ]);
    expect(find.byKey(row), findsOneWidget);
    expect((await const RecentNumbersStore().load()).length, 1);
    await tester.pumpWidget(const SizedBox());
    await showHome(tester, opener);
    expect(find.byKey(row), findsOneWidget);
  });

  for (final target in LinkOpenerTarget.values) {
    testWidgets(
      'invalid numbers and failed ${target.label} launches do not enter history',
      (tester) async {
        final opener = FakeLinkOpener()..fail = true;
        await showHome(tester, opener);
        final button = find.byKey(Key('open_in_${target.name}_button'));
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(find.text('Enter a valid phone number.'), findsOneWidget);
        expect(opener.opened, isEmpty);
        tester
            .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
            .removeCurrentSnackBar();
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('phone_number_field')),
          '2025550148',
        );
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(find.text('Recent numbers'), findsNothing);
        expect(await const RecentNumbersStore().load(), isEmpty);
        expect(
          find.text('Could not open ${target.label}. Please try again.'),
          findsOneWidget,
        );
      },
    );
  }

  testWidgets('Telegram opens, persists and reopens in Telegram', (
    tester,
  ) async {
    final opener = FakeLinkOpener();
    await showHome(tester, opener);
    expect(find.text('Open in Telegram'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('phone_number_field')),
      '2025550148',
    );
    await tester.tap(find.byKey(const Key('open_in_telegram_button')));
    await tester.pumpAndSettle();
    expect(opener.opened, ['+12025550148']);
    expect(opener.targets, [LinkOpenerTarget.telegram]);
    expect(
      (await const RecentNumbersStore().load()).single.target,
      LinkOpenerTarget.telegram,
    );

    await tester.pumpWidget(const SizedBox());
    await showHome(tester, opener);
    await tester.tap(find.byKey(const ValueKey('recent_+12025550148')));
    await tester.pumpAndSettle();
    expect(opener.opened, ['+12025550148', '+12025550148']);
    expect(opener.targets, [
      LinkOpenerTarget.telegram,
      LinkOpenerTarget.telegram,
    ]);
  });

  testWidgets('disables both chat buttons while a launch is pending', (
    tester,
  ) async {
    final opener = FakeLinkOpener()..pending = Completer<void>();
    await showHome(tester, opener);
    await tester.enterText(
      find.byKey(const Key('phone_number_field')),
      '2025550148',
    );
    await tester.tap(find.byKey(const Key('open_in_telegram_button')));
    await tester.pump();
    for (final target in LinkOpenerTarget.values) {
      final button = tester.widget<ElevatedButton>(
        find.byKey(Key('open_in_${target.name}_button')),
      );
      expect(button.onPressed, isNull);
    }
    expect(opener.opened, hasLength(1));
    opener.pending!.complete();
    await tester.pumpAndSettle();
    for (final target in LinkOpenerTarget.values) {
      final button = tester.widget<ElevatedButton>(
        find.byKey(Key('open_in_${target.name}_button')),
      );
      expect(button.onPressed, isNotNull);
    }
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
    expect(
      find.text(
        'This removes the history saved on this device. Your chats are not affected.',
      ),
      findsOneWidget,
    );
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
