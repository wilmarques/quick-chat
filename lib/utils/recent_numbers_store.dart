import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RecentNumber {
  const RecentNumber({required this.phone, required this.openedAt});

  final String phone;
  final DateTime openedAt;

  Map<String, String> toJson() => {
    'phone': phone,
    'openedAt': openedAt.toUtc().toIso8601String(),
  };
}

class RecentNumbersStore {
  const RecentNumbersStore();

  static const storageKey = 'recent_whatsapp_numbers';
  static const maxEntries = 20;

  Future<List<RecentNumber>> load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(storageKey);
    if (saved == null) return [];

    final dynamic decoded;
    try {
      decoded = jsonDecode(saved);
    } on FormatException {
      return [];
    }
    if (decoded is! List) return [];

    final entries = <RecentNumber>[];
    for (final item in decoded) {
      if (item is! Map) continue;
      final phone = item['phone'];
      final timestamp = item['openedAt'];
      if (phone is! String || timestamp is! String) continue;
      final openedAt = DateTime.tryParse(timestamp);
      if (openedAt == null || !RegExp(r'^\+[1-9]\d{6,14}$').hasMatch(phone)) {
        continue;
      }
      entries.add(RecentNumber(phone: phone, openedAt: openedAt.toLocal()));
    }
    entries.sort((a, b) => b.openedAt.compareTo(a.openedAt));
    final seen = <String>{};
    return entries
        .where((entry) => seen.add(entry.phone))
        .take(maxEntries)
        .toList();
  }

  Future<void> save(List<RecentNumber> entries) async {
    final preferences = await SharedPreferences.getInstance();
    final succeeded = entries.isEmpty
        ? await preferences.remove(storageKey)
        : await preferences.setString(
            storageKey,
            jsonEncode(
              entries.take(maxEntries).map((entry) => entry.toJson()).toList(),
            ),
          );
    if (!succeeded) throw StateError('Could not save recent numbers');
  }

  List<RecentNumber> record(
    List<RecentNumber> entries,
    String phone,
    DateTime now,
  ) => [
    RecentNumber(phone: phone, openedAt: now),
    ...entries.where((entry) => entry.phone != phone),
  ].take(maxEntries).toList();
}
