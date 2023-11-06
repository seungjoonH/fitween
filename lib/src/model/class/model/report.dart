import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum ReportType {
  bugReport, request;
  String get locale => LangCont.tr('report.type.${name.toSkewerCase}');
  String? get hintText {
    if (this == bugReport) return null;
    return LangCont.tr('hint.report-content');
  }

  static ReportType? toEnum(String? string) =>
      values.firstWhereOrNull((stage) => stage.name == string);
}

enum ReportStage {
  editing, draft, requested, accepted, answered;
  String get locale => LangCont.tr('report.stage.$name');
  String? get answer {
    if (![requested, accepted].contains(this)) return null;
    return LangCont.tr('report-detail.stage.$name');
  }
  Color get color => [
    ThemeCont.achro70, ThemeCont.achro50,
    ThemeCont.achro10, ThemeCont.colorC,
    ThemeCont.colorA
  ][index];

  static ReportStage? toEnum(String? string) =>
      values.firstWhereOrNull((stage) => stage.name == string);
}

enum BugReportType {
  uiux, auth, contents, etc, qna;
  String get category => LangCont.tr('report.bug.category.$name');
  String get guide => LangCont.tr('report.bug.guide.$name');

  static BugReportType? toEnum(String? string) =>
      values.firstWhereOrNull((type) => type.name == string);
}

class Report extends Model {
  late String _id;
  late String _uid;
  late String _nickname;
  late Timestamp _date;
  String? _title;
  String? _content;
  ReportType _type = ReportType.bugReport;
  BugReportType _bugType = BugReportType.qna;
  ReportStage _stage = ReportStage.editing;
  String? _answer;

  String get docId => _id;

  int get id => int.parse(_id);
  set id(int id) => _id = '$id'.padLeft(8, '0');

  DateTime get date => _date.toDate();
  set date(DateTime date) => _date = date.toTimestamp!;

  String get uid => _uid;
  String get nickname => _nickname;
  String get title => _title ?? '';
  String get content => _content ?? '';
  ReportType get type => _type;
  BugReportType get bugType => _bugType;
  ReportStage get stage => _stage;
  String? get answer => _answer;

  String get category {
    if (type == ReportType.request) return type.locale;
    return '${type.locale}-${bugType.category}';
  }

  void setTitle(String title) => _title = title;
  void setContent(String content) => _content = content;
  void setType(ReportType type) => _type = type;
  void setBugType(BugReportType type) => _bugType = type;
  void setStage(ReportStage stage) => _stage = stage;

  Report(int id) {
    FUser user = AuthCont.logged!;
    this.id = id;
    _uid = user.uid;
    _nickname = user.nickname;
    date = now;
  }

  Report.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _uid = json['uid'];
    _nickname = json['nickname'];
    _title = json['title'];
    _content = json['content'];
    _date = json['date'];
    _type = ReportType.toEnum(json['type'])!;
    _bugType = BugReportType.toEnum(json['bugType'])!;
    _stage = ReportStage.toEnum(json['stage'])!;
    _answer = json['answer'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = _id;
    json['uid'] = _uid;
    json['nickname'] = _nickname;
    json['title'] = _title;
    json['content'] = _content;
    json['date'] = _date;
    json['type'] = _type.name;
    json['bugType'] = _bugType.name;
    json['stage'] = _stage.name;
    json['answer'] = _answer;
    return json;
  }

  @override
  String get key => _id;
}