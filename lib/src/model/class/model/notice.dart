import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';

class Notice extends Model {
  late String _id;
  late String _message;
  late Timestamp _startTime;
  late Duration _duration;
  bool _toAll = false;
  List<String> _uids = [];

  String get id => _id;
  String get message => _message;
  Duration get duration => _duration;
  bool get toAll => _toAll;


  bool get _dateInRange => startTime.isBefore(now) && endTime.isAfter(now);
  bool get noticeable => _dateInRange && (_uids.contains(AuthCont.uid) || toAll);

  DateTime get startTime => _startTime.toDate();
  set startTime(DateTime time) => _startTime = time.toTimestamp!;
  DateTime get endTime => startTime.add(duration);

  Notice.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _message = json['message'];
    _startTime = json['startTime'];
    _duration = (json['duration'] as int).m;
    _toAll = json['toAll'] ?? false;
    _uids = json['uids'].cast<String>();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = _id;
    json['message'] = _message;
    json['startTime'] = _startTime;
    json['duration'] = _duration.inMinutes;
    json['toAll'] = _toAll;
    json['uids'] = _uids;
    return json;
  }

  @override
  String get key => _id;
}