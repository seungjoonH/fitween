import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageCont {
  static const _storage = FlutterSecureStorage();

  static const _key = 'logged-uid';

  static Future<Map<String, dynamic>?> load() async {
    String? data = await _storage.read(key: _key);
    if (data == null) return {};
    return jsonDecode(data);
  }

  static Future store(Map<String, dynamic> json) async {
    await _storage.write(key: _key, value: jsonEncode(json));
  }

  static Future eliminate() async {
    await _storage.delete(key: _key);
  }
}