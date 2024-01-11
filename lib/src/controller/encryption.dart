import 'package:encrypt/encrypt.dart';

class EncryptionCont {
  static const String _key = 'FitweenCBCSecure';
  static IV _getIv(String key) => IV.fromUtf8(key);
  static Encrypter get _en => Encrypter(AES(Key.fromUtf8(_key)));

  static String encode(String keyword, String text) {
    keyword = keyword.substring(0, 16);
    return _en.encrypt(text, iv: _getIv(keyword)).base64;
  }
  static String decode(String keyword, String code) {
    keyword = keyword.substring(0, 16);
    if (code.length != 24) return code;
    return _en.decrypt64(code, iv: _getIv(keyword));
  }
}