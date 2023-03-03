/* 사용자 모델 구조 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/enum/sex.dart';

class FUserInfo {
  /// static variables
  static int defaultWeight = 60;
  static int defaultHeight = 170;
  static int heightMax = 220;
  static int heightMin = 100;
  static int weightMax = 220;
  static int weightMin = 30;

  static bool heightInRange(int height) {
    return height >= heightMin && height <= heightMax;
  }
  static bool weightInRange(int weight) {
    return weight >= weightMin && weight <= weightMax;
  }

  /// attributes
  // 일반 변수
  String? uid;
  String? name;
  String? nickname;
  String? email;
  int? weight;
  int? height;
  bool? weightVisibility;
  bool? heightVisibility;
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
    weightVisibility = json['weightVisibility'];
    heightVisibility = json['heightVisibility'];
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
    json['weightVisibility'] = weightVisibility;
    json['heightVisibility'] = heightVisibility;
    json['sex'] = sex?.name;
    json['regDate'] = _regDate;
    json['dateOfBirth'] = _dateOfBirth;
    return json;
  }
}
