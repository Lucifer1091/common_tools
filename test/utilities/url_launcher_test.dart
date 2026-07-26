import 'dart:io';

import 'package:common_tools/utilities/url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

void main() {
  late UrlLauncherPlatform originalPlatform;
  late _FakeUrlLauncherPlatform fakePlatform;

  setUp(() {
    originalPlatform = UrlLauncherPlatform.instance;
    fakePlatform = _FakeUrlLauncherPlatform();
    UrlLauncherPlatform.instance = fakePlatform;
  });

  tearDown(() {
    UrlLauncherPlatform.instance = originalPlatform;
    debugDefaultTargetPlatformOverride = null;
  });

  group('UrlLauncher', () {
    test('rejects invalid URLs and launches valid absolute URLs', () async {
      expect(await UrlLauncher.launch('example.com'), isFalse);
      expect(fakePlatform.launches, isEmpty);

      expect(await UrlLauncher.launch('https://example.com'), isTrue);

      expect(fakePlatform.launches, hasLength(1));
      expect(fakePlatform.launches.single.url, 'https://example.com');
      expect(
        fakePlatform.launches.single.options.mode,
        PreferredLaunchMode.platformDefault,
      );
    });

    test('retries with fallback mode after primary launch failure', () async {
      fakePlatform.launchResults.addAll(<bool>[false, true]);

      final bool launched = await UrlLauncher.launch(
        'https://example.com',
        mode: LaunchMode.inAppBrowserView,
        fallbackMode: LaunchMode.externalApplication,
      );

      expect(launched, isTrue);
      expect(fakePlatform.launches, hasLength(2));
      expect(
        fakePlatform.launches.first.options.mode,
        PreferredLaunchMode.inAppBrowserView,
      );
      expect(
        fakePlatform.launches.last.options.mode,
        PreferredLaunchMode.externalApplication,
      );
    });

    test('forwards canLaunch and supportsMode checks', () async {
      fakePlatform
        ..canLaunchResult = true
        ..supportedModes = <PreferredLaunchMode>{
          PreferredLaunchMode.inAppBrowserView,
        };

      expect(await UrlLauncher.canLaunch('https://example.com'), isTrue);
      expect(
        await UrlLauncher.supportsMode(LaunchMode.inAppBrowserView),
        isTrue,
      );
      expect(fakePlatform.canLaunches, <String>['https://example.com']);
      expect(fakePlatform.supportModeChecks, <PreferredLaunchMode>[
        PreferredLaunchMode.inAppBrowserView,
      ]);
    });

    test('normalizes web URLs and selects web window target', () async {
      final bool launched = await UrlLauncher.launchWebUrl(
        'example.com/docs',
        newTab: false,
      );

      expect(launched, isTrue);
      expect(fakePlatform.launches.single.url, 'https://example.com/docs');
      expect(fakePlatform.launches.single.options.webOnlyWindowName, '_self');
    });

    test('builds encoded mailto URLs with recipients and content', () async {
      final bool launched = await UrlLauncher.launchEmail(
        'help@example.com',
        subject: 'Hello World',
        body: 'Line one & two',
        cc: <String>['cc@example.com'],
        bcc: <String>['boss@example.com'],
      );

      expect(launched, isTrue);
      expect(
        fakePlatform.launches.single.url,
        'mailto:help@example.com?'
        'subject=Hello%20World&'
        'body=Line%20one%20%26%20two&'
        'cc=cc%40example.com&'
        'bcc=boss%40example.com',
      );
    });

    test('sanitizes phone and SMS launch values', () async {
      expect(await UrlLauncher.launchPhone('+1 (555) 010-9999'), isTrue);
      expect(
        await UrlLauncher.launchSms(
          '+1 (555) 010-9999',
          message: 'Hello there',
        ),
        isTrue,
      );

      expect(fakePlatform.launches.first.url, 'tel:+15550109999');
      expect(
        fakePlatform.launches.last.url,
        'sms:+15550109999?body=Hello%20there',
      );
    });

    test('launches existing desktop file paths', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      final Directory tempDirectory = Directory.systemTemp.createTempSync(
        'common_tools_url_launcher_test',
      );
      final File file = File('${tempDirectory.path}/sample.txt')
        ..writeAsStringSync('sample');

      addTearDown(() {
        if (tempDirectory.existsSync()) {
          tempDirectory.deleteSync(recursive: true);
        }
      });

      final bool launched = await UrlLauncher.launchFilePath(file.path);

      expect(launched, isTrue);
      expect(Uri.parse(fakePlatform.launches.single.url).scheme, 'file');
      expect(fakePlatform.launches.single.url, contains('sample.txt'));
    });

    testWidgets('shows SnackBar feedback on explicit launch failure', (
      WidgetTester tester,
    ) async {
      fakePlatform.launchResults.add(false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return TextButton(
                  onPressed: () async {
                    await UrlLauncher.launchWithFeedback(
                      context,
                      'https://example.com',
                      errorMessage: 'Could not open.',
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Could not open.'), findsOneWidget);
    });
  });
}

class _LaunchCall {
  const _LaunchCall({required this.url, required this.options});

  final String url;
  final LaunchOptions options;
}

class _FakeUrlLauncherPlatform extends UrlLauncherPlatform {
  final List<String> canLaunches = <String>[];
  final List<_LaunchCall> launches = <_LaunchCall>[];
  final List<bool> launchResults = <bool>[];
  final List<PreferredLaunchMode> supportModeChecks = <PreferredLaunchMode>[];

  bool canLaunchResult = false;
  Set<PreferredLaunchMode> supportedModes = <PreferredLaunchMode>{};

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async {
    canLaunches.add(url);
    return canLaunchResult;
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launches.add(_LaunchCall(url: url, options: options));
    if (launchResults.isEmpty) {
      return true;
    }
    return launchResults.removeAt(0);
  }

  @override
  Future<bool> supportsMode(PreferredLaunchMode mode) async {
    supportModeChecks.add(mode);
    return supportedModes.contains(mode);
  }
}
