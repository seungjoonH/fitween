import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/enum/report.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:get/get.dart';

class Report {
  late String? _id;
  late String? uid;
  late String nickname;
  late Timestamp _date;
  String? title;
  String? content;
  ReportType type = ReportType.qna;
  ReportStage stage = ReportStage.editing;
  bool isBug = true;
  String? answer;

  String get docId => _id!;

  int get id => int.parse(_id!);
  set id(int id) => _id = '$id'.padLeft(8, '0');

  DateTime get date => _date.toDate();
  set date(DateTime date) => _date = toTimestamp(date)!;

  Report(int id) {
    final user = Get.find<UserInfoP>().loggedUser;
    this.id = id;
    uid = user.uid;
    nickname = user.nickname!;
    date = now;
  }

  Report.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    uid = json['uid'];
    nickname = json['nickname'];
    title = json['title'];
    content = json['content'];
    _date = json['date'];
    type = ReportType.toEnum(json['type'])!;
    stage = ReportStage.toEnum(json['stage'])!;
    isBug = json['isBug'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = _id;
    json['uid'] = uid;
    json['nickname'] = nickname;
    json['title'] = title;
    json['content'] = content;
    json['date'] = _date;
    json['type'] = type.name;
    json['stage'] = stage.name;
    json['isBug'] = isBug;
    json['answer'] = answer;
    return json;
  }
}