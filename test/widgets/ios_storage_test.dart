import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catatan_uang/core/platform/storage_policy.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('catatan_uang/storage_policy');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    messenger.setMockMethodCallHandler(channel, null);
  });
  test('iOS prepares storage policy before opening ledger', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final calls = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      return null;
    });
    await prepareStoragePolicy();
    expect(calls, ['prepareLocalStorage']);
  });
  test('iOS fails closed if native storage policy fails', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    messenger.setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'storage_policy_unavailable');
    });
    await expectLater(
      prepareStoragePolicy(),
      throwsA(isA<PlatformException>()),
    );
  });
  test('Android does not call the iOS storage channel', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    messenger.setMockMethodCallHandler(channel, (_) async {
      fail('Android must not invoke the Apple storage channel');
    });
    await prepareStoragePolicy();
  });
}
