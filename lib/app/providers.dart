import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/repository.dart';
import '../core/domain/finance.dart';

final repositoryProvider = Provider<FinanceRepository>(
  (ref) => throw UnimplementedError(),
);
final snapshotProvider = StreamProvider<FinanceSnapshot>(
  (ref) => ref.watch(repositoryProvider).watch(),
);
