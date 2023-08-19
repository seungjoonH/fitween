import 'dart:math';

bool hasBottomConsonant(String input) {
  return (input.runes.last - 0xAC00) % 28 != 0;
}

String eunNeun(String input) => hasBottomConsonant(input) ? '은' : '는';
String iGa(String input) => hasBottomConsonant(input) ? '이' : '가';
String eulReul(String input) => hasBottomConsonant(input) ? '을' : '를';
String roEuro(String input) => hasBottomConsonant(input) ? '으로' : '로';

String withEunNeun(String input) => '$input${eunNeun(input)}';
String withIGa(String input) => '$input${iGa(input)}';
String withEulReul(String input) => '$input${eulReul(input)}';
String withRoEuro(String input) => '$input${roEuro(input)}';

bool isKoreanConsonant(String input) {
  int inputToUniCode = input.codeUnits[0];
  return inputToUniCode >= 12593 && inputToUniCode <= 12622;
}

bool isKoreanVowel(String input) {
  int inputToUniCode = input.codeUnits[0];
  return inputToUniCode >= 12623 && inputToUniCode <= 12643;
}

bool isMoasseugi(String input) {
  int inputToUniCode = input.codeUnits[0];
  return inputToUniCode >= 44032 && inputToUniCode <= 55203;
}

bool isKorean(String input) {
  return isKoreanConsonant(input)
      || isKoreanVowel(input)
      || isMoasseugi(input);
}

bool hasSeparatedConsonantOrVowel(String input) {
  return input.split('').map((e) {
    return isKoreanConsonant(e) || isKoreanVowel(e);
  }).contains(true);
}


bool hasKorean(String input) {
  return input.split('').any((char) => isKorean(char));
}

extension StringExtension on String {
  num? get toNum {
    try { return double.parse(this); }
    catch(_) { return null; }
  }

  String get short {
    const int max = 4;
    if (length <= max) return this;
    return '${substring(0, 4)}...';
  }
  String get hideAll => '*' * length;
  String get hidePart {
    String string = this;
    int low = max(length ~/ 3, 1);
    int high = max(low * 2, 2);
    String sub = string.substring(low, high);
    string = string.replaceAll(sub, '*' * sub.length);
    return string;
  }

  String? get txs {
    Iterable<String> s = split(' ');
    return '${s.first}@{ ${s.last}}';
  }

  String get toDashed {
    final exp = RegExp('(?<=[a-z])[A-Z]');
    return replaceAllMapped(exp, (m) => '-${m.group(0)}').toLowerCase();
  }
}