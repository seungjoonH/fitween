/* 사용자 모델 구조 */

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/model/enum/sex.dart';
import 'package:fitween/presenter/model/record.dart';

class FUserInfo {
  /// static variables
  static int defaultWeight = 60;
  static int defaultHeight = 170;

  /// attributes
  // 일반 변수
  String? uid;
  String? name;
  String? nickname;
  String? email;
  int? weight;
  int? height;
  Sex? sex;
  Timestamp? _regDate;
  Timestamp? _dateOfBirth;

  /// accessors & mutators

  DateTime? get regDate => _regDate?.toDate();
  DateTime? get dateOfBirth => _dateOfBirth?.toDate();
  int get age => today.year - dateOfBirth!.year;

  String? get dateOfBirthString => dateToString('yyyy-MM-dd', dateOfBirth);

  set regDate(DateTime? date) => _regDate = toTimestamp(date);
  set dateOfBirth(DateTime? date) => _dateOfBirth = toTimestamp(date);

  /// constructors
  FUserInfo() {
    weight = defaultWeight;
    height = defaultHeight;
  }

  FUserInfo.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    nickname = json['nickname'];
    email = json['email'];
    weight = json['weight']?.toInt();
    height = json['height']?.toInt();
    sex = Sex.toEnum(json['sex']);
    _regDate = json['regDate'];
    _dateOfBirth = json['dateOfBirth'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['name'] = name;
    json['nickname'] = nickname;
    json['email'] = email;
    json['weight'] = weight;
    json['height'] = height;
    json['sex'] = sex?.name;
    json['regDate'] = _regDate;
    json['dateOfBirth'] = _dateOfBirth;
    return json;
  }
}
