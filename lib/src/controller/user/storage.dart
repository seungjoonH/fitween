import 'package:fitween/src/controller/user/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageCont {
  static const _storage = FlutterSecureStorage();

  static Future<String?> load() async {
    return await _storage.read(key: 'uid');
  }

  static Future store() async {
    if (!AuthCont.isLogged) return;
    await _storage.write(
      key: 'uid',
      value: AuthCont.uid,
    );
  }

  static Future eliminate() async {
    await _storage.delete(key: 'uid');
  }
}