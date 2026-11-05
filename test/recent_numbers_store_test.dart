import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:quick_chat/utils/recent_numbers_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const store = RecentNumbersStore();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('persists newest-first unique numbers with a bounded history', () async {
    var entries = <RecentNumber>[];
    for (var index = 0; index < 25; index++) {
      entries = store.record(
        entries,
        '+1202555${index.toString().padLeft(4, '0')}',
        DateTime(2026, 1, 1, index),
      );
    }
    entries = store.record(entries, '+12025550010', DateTime(2026, 2));
    await store.save(entries);
    final loaded = await store.load();
    expect(loaded.length, RecentNumbersStore.maxEntries);
    expect(loaded.first.phone, '+12025550010');
    expect(loaded.where((entry) => entry.phone == '+12025550010').length, 1);
    expect(loaded.first.openedAt, DateTime(2026, 2));
    expect(loaded.any((entry) => entry.phone == '+12025550000'), isFalse);
  });

  test('ignores corrupted data and malformed entries', () async {
    SharedPreferences.setMockInitialValues({
      RecentNumbersStore.storageKey: 'not json',
    });
    expect(await store.load(), isEmpty);
    SharedPreferences.setMockInitialValues({
      RecentNumbersStore.storageKey: jsonEncode([
        null,
        {'phone': '+12025550148', 'openedAt': 'bad date'},
        {'phone': 'not a number', 'openedAt': '2026-01-01T00:00:00Z'},
        {'phone': '+12025550148', 'openedAt': '2026-01-01T00:00:00Z'},
      ]),
    });
    expect((await store.load()).single.phone, '+12025550148');
  });

  test('clearing removes persisted history', () async {
    await store.save([
      RecentNumber(phone: '+12025550148', openedAt: DateTime.now()),
    ]);
    await store.save([]);
    expect(await store.load(), isEmpty);
    expect(
      (await SharedPreferences.getInstance()).containsKey(
        RecentNumbersStore.storageKey,
      ),
      isFalse,
    );
  });
}
