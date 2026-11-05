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
import '../widgets/clear_history_dialog.dart';
import '../widgets/recent_numbers_section.dart';

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
    final confirmed = await confirmClearHistory(context);
    if (!confirmed || !mounted) return;
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
            if (_recentNumbers.isNotEmpty)
              RecentNumbersSection(
                entries: _recentNumbers,
                enabled: !_busy,
                onOpen: _openPhoneOnTarget,
                onClearAll: _clearHistory,
              ),
          ],
        ),
      ),
    );
  }
}
