import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/src/model/class/model/user.dart';


class FUserInfo extends FUser {
  @override
  FUserInfo? get info => this;

  String? _name;
  late String _nickname;
  late Timestamp _regDate;

  late String _email;
  late Timestamp _dateOfBirth;
  late Sex _sex;
  late num _height;
  late num _weight;
  late bool _heightVisibility;
  late bool _weightVisibility;

  @override
  String? get name => _name;
  @override
  String get nickname {
    if (isAdmin) return _nickname;
    return _nickname;
  }
  @override
  DateTime get regDate => _regDate.toDate();

  @override
  String get email => _email;
  @override
  DateTime get dateOfBirth => _dateOfBirth.toDate();
  @override
  Sex get sex => _sex;
  @override
  num get height => _height;
  @override
  num get weight => _weight;

  bool get isAdmin => _AdminInfo.isAdmin(email);
  @override
  bool get isAppleInspector => _AdminInfo.isAppleInspector(email);

  FUserInfo(super.key) : super();
  FUserInfo.fromJson(super.json) : super.fromJson();

  FUserInfo build(FUserInfoBuilder builder) {
    uid = builder.uid;
    _name = builder.name;
    _nickname = builder.nickname!;
    _regDate = builder._regDate!;
    _email = builder.email!;
    _dateOfBirth = builder._dateOfBirth!;
    _sex = builder.sex!;
    _height = builder.height!;
    _weight = builder.weight!;
    _heightVisibility = builder.heightVisibility!;
    _weightVisibility = builder.weightVisibility!;
    return this;
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _name = json['name'];
    _nickname = json['nickname'];
    _email = json['email'];
    _weight = json['weight'];
    _height = json['height'];
    _weightVisibility = json['weightVisibility'] ?? false;
    _heightVisibility = json['heightVisibility'] ?? false;
    _sex = Sex.toEnum(json['sex'])!;
    _regDate = json['regDate'];
    _dateOfBirth = json['dateOfBirth'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['name'] = _name;
    json['nickname'] = _nickname;
    json['email'] = _email;
    json['weight'] = _weight;
    json['height'] = _height;
    json['weightVisibility'] = _weightVisibility;
    json['heightVisibility'] = _heightVisibility;
    json['sex'] = _sex.name;
    json['regDate'] = _regDate;
    json['dateOfBirth'] = _dateOfBirth;
    return json;
  }

  FUserInfoBuilder toBuilder() => FUserInfoBuilder()
    ..uid = uid
    ..name = _name
    ..nickname = _nickname
    ..email = _email
    ..weight = _weight
    ..height = _height
    ..weightVisibility = _weightVisibility
    ..heightVisibility = _heightVisibility
    ..sex = _sex
    ..regDate = regDate
    ..dateOfBirth = dateOfBirth;
}

class _AdminInfo {
  static final List<String> _adminEmails = [
    'fitweensj@gmail.com',
    'fitween.tester@gmail.com',
    'fitween.yun@gmail.com',
    'besthcy9908@gmail.com',
    'hajune.lee@gmail.com',
    'hsj6831@naver.com',
    'hsj6831@handong.ac.kr',
    'phenix2244@naver.com',
    'phenix2244@gmail.com',
    'hsj6831@gmail.com',
    'w0nn0nly5262@gmail.com',
    '21800725@handong.ac.kr',
    '21800673@handong.ac.kr',
  ];

  static bool isAdmin(String email) {
    return _adminEmails.contains(email);
  }

  static bool isAppleInspector(String email) {
    return email.contains('privaterelay.appleid.com');
  }
}

class FUserInfoBuilder {
  late String uid;
  String? name;
  String? nickname;
  Timestamp? _regDate;
  String? email;
  Timestamp? _dateOfBirth;
  Sex? sex;
  num? height;
  num? weight;
  bool? heightVisibility;
  bool? weightVisibility;

  DateTime? get regDate => _regDate?.toDate();
  set regDate(DateTime? d) => _regDate = d?.toTimestamp;
  DateTime? get dateOfBirth => _dateOfBirth?.toDate();
  set dateOfBirth(DateTime? d) => _dateOfBirth = d?.toTimestamp;

  FUserInfo build() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['name'] = name;
    json['nickname'] = nickname!;
    json['email'] = email!;
    json['weight'] = weight!;
    json['height'] = height!;
    json['weightVisibility'] = weightVisibility ?? false;
    json['heightVisibility'] = heightVisibility ?? false;
    json['sex'] = sex!.name;
    json['regDate'] = _regDate ?? now.toTimestamp;
    json['dateOfBirth'] = _dateOfBirth!;

    return FUserInfo.fromJson(json);
  }
}