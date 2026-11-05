import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../utils/recent_numbers_store.dart';

class RecentNumbersSection extends StatelessWidget {
  const RecentNumbersSection({
    super.key,
    required this.entries,
    required this.enabled,
    required this.onOpen,
    required this.onClearAll,
  });

  final List<RecentNumber> entries;
  final bool enabled;
  final ValueChanged<String> onOpen;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text('Recent numbers', style: theme.textTheme.titleMedium),
            ),
            TextButton(
              onPressed: enabled ? onClearAll : null,
              child: const Text('Clear all'),
            ),
          ],
        ),
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colors.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var index = 0; index < entries.length; index++) ...[
                if (index > 0)
                  const Divider(height: 1, indent: 16, endIndent: 16),
                _RecentNumberTile(
                  entry: entries[index],
                  onTap: enabled ? () => onOpen(entries[index].phone) : null,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tap a number to reopen in WhatsApp.\nHistory stays on this device.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _RecentNumberTile extends StatelessWidget {
  const _RecentNumberTile({required this.entry, required this.onTap});

  final RecentNumber entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      key: ValueKey('recent_${entry.phone}'),
      leading: FaIcon(
        FontAwesomeIcons.whatsapp,
        color: colors.primary,
        size: 22,
      ),
      title: Text(PhoneNumber.parse(entry.phone).international),
      subtitle: Text(_openedAtLabel(context, entry.openedAt)),
      trailing: Icon(Icons.chevron_right, color: colors.primary),
      onTap: onTap,
    );
  }
}

String _openedAtLabel(BuildContext context, DateTime openedAt) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(openedAt.year, openedAt.month, openedAt.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final localizations = MaterialLocalizations.of(context);
  final day = date == today
      ? 'Today'
      : date == yesterday
      ? 'Yesterday'
      : localizations.formatShortDate(openedAt);
  final time = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(openedAt),
    alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
  );
  return '$day, $time';
}
