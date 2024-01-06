import 'package:fit_wallet/features/shared/infrastructure/datasources/sqlite_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dbProvider = Provider(
  (ref) => SQLiteDatasource(),
);
