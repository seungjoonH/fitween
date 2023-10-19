import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';

class PointHistoryData extends Model {
  late int _amount;
  late String _content;
  late Timestamp _date;

  DateTime get date => _date.toDate();
  set date(DateTime d) => d.toTimestamp;

  String get _tr => 'point';
  String get content => LangCont.tr('$_tr.$_content');

  bool get earned => _amount > 0;
  bool get spent => _amount < 0;

  PointHistoryData({required int amount, required String content}) {
    _amount = amount; _content = content; date = now;
  }

  PointHistoryData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _amount = json['amount'];
    _content = json['content'];
    _date = json['date'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['amount'] = _amount;
    json['content'] = _content;
    json['date'] = _date;
    return json;
  }

  @override
  String get key => throw UnimplementedError();

}

class FUserPoint extends FUser {
  @override
  FUserPoint? get point => this;

  late int _points;
  List<PointHistoryData> _history = [];

  @override
  int get points => _points;

  @override
  List<PointHistoryData> get pointHistory => _history;

  List<PointHistoryData> get earnedHistory => _history.where((h) => h.earned).toList();
  List<PointHistoryData> get spentHistory => _history.where((h) => h.spent).toList();

  void earn(int fp, String content) {
    _points += fp;
    _history.add(PointHistoryData(amount: fp, content: content));
  }

  void spend(int fp, String content) {
    _points -= fp;
    _history.add(PointHistoryData(amount: -fp, content: content));
  }

  FUserPoint(super.key) : super();
  FUserPoint.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _points = json['points'] ?? 0;
    _history = json['history']
        ?.map((data) => PointHistoryData.fromJson(data)) ?? [];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['points'] = _points;
    json['history'] = _history.map((data) => data.toJson());
    return json;
  }
}