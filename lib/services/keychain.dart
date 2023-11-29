import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyChain {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      groupId: "${const String.fromEnvironment("APP_ID_PREFIX")}.SharedKeychain",
    ),
  );

  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  Future write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  Future delete(String key) {
    return _storage.delete(key: key);
  }

  Future clear() {
    return _storage.deleteAll();
  }
}
