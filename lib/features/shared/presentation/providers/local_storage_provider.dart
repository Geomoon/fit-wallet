import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';

final localStorageProvider = Provider((ref) {
  final storage = LocalStorageService()..init();
  return storage;
});

class LocalStorageService {
  late final LocalStorage _storage;

  Future<void> init() async {
    _storage = LocalStorage('fit_wallet_storage');
    await _storage.ready;
  }

  Future<void> setValue(String key, dynamic value) async =>
      await _storage.setItem(key, value);

  Future<dynamic> getValue(String key) async => await _storage.getItem(key);
}
