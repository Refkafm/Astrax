import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Prepares the iOS application-support directory before any ledger is opened.
/// A native failure must propagate: never silently allow a cloud-backed ledger.
Future<void> prepareStoragePolicy() async {
  if (defaultTargetPlatform != TargetPlatform.iOS) return;
  await const MethodChannel('catatan_uang/storage_policy')
      .invokeMethod<void>('prepareLocalStorage');
}
