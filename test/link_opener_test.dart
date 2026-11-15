import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_chat/utils/link_opener.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.flutter.io/url_launcher');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  for (final target in LinkOpenerTarget.values) {
    test('launches the expected ${target.label} phone link', () async {
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return true;
          });

      await const LinkOpener().openLink(link: '+12025550148', target: target);

      expect(calls, hasLength(1));
      expect(calls.single.method, 'launch');
      final uri = Uri.parse(calls.single.arguments['url'] as String);
      if (target == LinkOpenerTarget.telegram) {
        expect(uri.toString(), 'https://t.me/+12025550148');
      } else {
        expect(uri.scheme, 'whatsapp');
        expect(uri.host, 'send');
        expect(uri.queryParameters, {'phone': '+12025550148'});
      }
    });

    test('propagates a rejected ${target.label} launch', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async => false);
      await expectLater(
        const LinkOpener().openLink(link: '+12025550148', target: target),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            'Could not open ${target.label}',
          ),
        ),
      );
    });

    for (final link in <String?>[null, '']) {
      test('rejects missing ${target.label} number ($link)', () async {
        final calls = <MethodCall>[];
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
              calls.add(call);
              return true;
            });
        await expectLater(
          const LinkOpener().openLink(link: link, target: target),
          throwsA('No valid number provided'),
        );
        expect(calls, isEmpty);
      });
    }
  }
}
