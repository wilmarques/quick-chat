import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart' as mui;
import 'package:phone_form_field/phone_form_field.dart';

import '../utils/clipboard_handler.dart';
import '../utils/link_opener.dart';
import '../utils/phone_utils.dart';
import '../utils/recent_numbers_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.linkOpener = const LinkOpener(),
    this.recentNumbersStore = const RecentNumbersStore(),
  });

  final LinkOpener linkOpener;
  final RecentNumbersStore recentNumbersStore;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _clipboardHandler = const ClipboardHandler();
  final _phoneUtils = const PhoneUtils();
  final _phoneFieldFocusNode = FocusNode();

  late PhoneController _phoneNumberController;
  Timer? _requestFocusTimer;
  List<RecentNumber> _recentNumbers = [];
  bool _historyLoaded = false;
  bool _busy = false;

  void _pasteFromClipboard() async {
    try {
      final clipboardValue = await _clipboardHandler.paste();
      if (!mounted) return;
      setState(() {
        _phoneNumberController.value = PhoneNumber.parse(
          clipboardValue,
          callerCountry: _phoneUtils.currentIsoCode(),
        );
      });
    } catch (exception) {
      throw 'Could not read from clipboard';
    }
  }

  void _openInWhatsapp() {
    final phone = _phoneNumberController.value;
    if (!phone.isValid()) {
      _showMessage('Enter a valid phone number.');
      return;
    }
    _openPhoneOnTarget('+${phone.countryCode}${phone.nsn}');
  }

  Future<void> _openPhoneOnTarget(String phone) async {
    if (_busy || !_historyLoaded) return;
    setState(() => _busy = true);
    try {
      await widget.linkOpener.openLink(
        link: phone,
        target: LinkOpenerTarget.whatsapp,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showMessage('Could not open WhatsApp. Please try again.');
      return;
    }
    if (!mounted) return;
    final updated = widget.recentNumbersStore.record(
      _recentNumbers,
      phone,
      DateTime.now(),
    );
    setState(() => _recentNumbers = updated);
    try {
      await widget.recentNumbersStore.save(updated);
    } catch (_) {
      if (mounted) {
        _showMessage('WhatsApp opened, but history could not be saved.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _loadRecentNumbers() async {
    try {
      final entries = await widget.recentNumbersStore.load();
      if (mounted) setState(() => _recentNumbers = entries);
    } catch (_) {
      if (mounted) _showMessage('Saved history could not be loaded.');
    } finally {
      if (mounted) setState(() => _historyLoaded = true);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear recent numbers?'),
        content: const Text(
          'This removes the history saved on this device. Your WhatsApp chats are not affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear history'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.recentNumbersStore.save([]);
      if (mounted) setState(() => _recentNumbers = []);
    } catch (_) {
      if (mounted) {
        _showMessage('History could not be cleared. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _openedAtLabel(DateTime openedAt) {
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

  Widget _buildRecentNumbers() {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent numbers',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: _busy ? null : _clearHistory,
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
              for (var index = 0; index < _recentNumbers.length; index++) ...[
                if (index > 0)
                  const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  key: ValueKey('recent_${_recentNumbers[index].phone}'),
                  leading: FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: colors.primary,
                    size: 22,
                  ),
                  title: Text(
                    PhoneNumber.parse(_recentNumbers[index].phone)
                        .international,
                  ),
                  subtitle: Text(
                    _openedAtLabel(_recentNumbers[index].openedAt),
                  ),
                  trailing: Icon(Icons.chevron_right, color: colors.primary),
                  onTap: _busy
                      ? null
                      : () => _openPhoneOnTarget(_recentNumbers[index].phone),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tap a number to reopen in WhatsApp.\nHistory stays on this device.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    var phoneNumber = PhoneNumber(
      isoCode: _phoneUtils.currentIsoCode(),
      nsn: '',
    );
    _phoneNumberController = PhoneController(initialValue: phoneNumber);
    _loadRecentNumbers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Tap on the phone number field to show the keyboard, if not on web
    // Because on web it doesn't work and produces bugs
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _requestFocusTimer?.cancel();
        // Not working
        _requestFocusTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) _phoneFieldFocusNode.requestFocus();
        });
      });
    }
  }

  @override
  void dispose() {
    _requestFocusTimer?.cancel();
    _phoneFieldFocusNode.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Chat')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 60.0),
            mui.Material(
              type: mui.MaterialType.transparency,
              child: PhoneFormField(
                key: const Key('phone_number_field'),
                autofocus: false,
                focusNode: _phoneFieldFocusNode,
                controller: _phoneNumberController,
                decoration: const mui.InputDecoration(
                  labelText: 'Enter Phone Numer',
                  border: mui.OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Column(
              children: [
                ElevatedButton.icon(
                  key: const Key('open_in_whatsapp_button'),
                  onPressed: _historyLoaded && !_busy ? _openInWhatsapp : null,
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
                  label: const Text('Open in WhatsApp'),
                  style: ElevatedButton.styleFrom(elevation: 8.0),
                ),
                TextButton(
                  onPressed: _pasteFromClipboard,
                  child: const Text('Paste'),
                ),
              ],
            ),
            if (_recentNumbers.isNotEmpty) _buildRecentNumbers(),
          ],
        ),
      ),
    );
  }
}
