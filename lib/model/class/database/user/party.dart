/* 사용자 모델 구조 */

import 'dart:math';

import 'package:fitween/model/class/database/party.dart';

class FUserParty {
  /// static methods
  // 무작위 코드 생성
  static String get randomCode {
    int length = 7;
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(
        Random().nextInt(chars.length),
      )),
    );
  }

  /// attributes
  // 일반 변수
  String? uid;
  List<String> partyIds = [];

  // 의존 변수
  Map<String, Party> parties = {}; // partyIds 변수에 의존

  /// constructors
  FUserParty();

  FUserParty.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    partyIds = (json['partyIds'] ?? []).cast<String>();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['partyIds'] = partyIds;
    return json;
  }
}
