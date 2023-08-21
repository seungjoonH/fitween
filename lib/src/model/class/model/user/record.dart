import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/date_range.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';

class FUserRecord extends FUser {
  @override
  FUserRecord? get record => this;

  late _RecordsData _goals;
  late _RecordsData _inputRecords;
  late _RecordsData _records;

  @override
  Goal get goal => Goal._fromRecordsData(_goals);

  @override
  Map<FType, num> getOneDayRecord(DateTime date) => getRecord(date, date);

  @override
  Map<FType, num> getOneWeekRecord(DateTime date) {
    DateTime from = date;
    DateTime to = from.add(1.w).subtract(1.d);
    return getRecord(from, to);
  }

  @override
  Map<FType, num> getOneMonthRecord(DateTime date, {int days = 30}) {
    DateTime from = date;
    late DateTime to;
    if (date.day == 1) { to = from.lastDayOfMonth; }
    else { to = from.add(days.d).subtract(1.d); }
    return getRecord(from, to);
  }

  @override
  Map<FType, num> getFromRecord(DateTime from) => getRecord(from, today);

  @override
  Map<FType, num> getToRecord(DateTime to) => getRecord(regDate, to);

  @override
  Map<FType, num> getRecord(DateTime from, DateTime to) {
    DateTime fromDate = later(regDate, from);
    DateTime toDate = earlier(to.lastTimeOfDay, now);

    Map<FType, num> records = Map.fromEntries(
      FType.values.map((type) => MapEntry(type, .0)),
    );

    for (FType type in FType.values) {
      num amount = records[type]!;
      amount += _inputRecords.getAmounts(type, DateRange(fromDate, toDate));
      amount += _records.getAmounts(type, DateRange(fromDate, toDate));
      records[type] = amount;
    }

    return records;
  }

  @override
  Map<FType, num> get allRecord => getRecord(regDate, today);

  Map<FType, Amount> getAmount(DateTime from, DateTime to) {
    return getRecord(from, to).map<FType, Amount>((type, value) {
      late Amount amount;
      switch (type) {
        case FType.distance: amount = DistanceAmount()..step = value; break;
        case FType.height: amount = HeightAmount()..floor = value; break;
        case FType.weight: amount = WeightAmount()..cnt = value; break;
        default: break;
      }
      return MapEntry(type, amount);
    });
  }

  @override
  bool completed(FType type, DateTime date) {
    num value = getOneDayRecord(date)[type]!;
    num goalValue = goal.byType(type);
    return value >= goalValue;
  }

  @override
  bool started(FType type, DateTime date) {
    num value = getOneDayRecord(date)[type]!;
    return value > 0;
  }

  @override
  List<DateTime> get logDates {
    Set<DateTime> dates = {};
    dates.addAll(_inputRecords.doneDates);
    dates.addAll(_records.doneDates);
    return dates.toList(growable: true);
  }
  @override
  DateTime get latestLogDate => logDates.last;

  FUserRecord(super.key) : super();
  FUserRecord.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _goals = _RecordsData.fromJson(json['goals']);
    _inputRecords = _RecordsData.fromJson(json['inputRecords']);
    _records = _RecordsData.fromJson(json['records']);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['goals'] = _goals.toJson();
    json['inputRecords'] = _inputRecords.toJson();
    json['records'] = _records.toJson();
    return json;
  }
}

class Goal {
  late num _calorie;
  late num _distance;
  late num _height;
  late num _weight;

  num get calorie => _calorie;
  num get distance => _distance;
  num get height => _height;
  num get weight => _weight;

  num byType(FType type) => [
    _calorie, _distance, _height, _weight
  ][type.index];

  Goal._fromRecordsData(_RecordsData data) {
    _fromRecordsData(data);
  }

  void _fromRecordsData(_RecordsData data) {
    List<_RecordData> calories = [...data._calories];
    List<_RecordData> distance = [...data._distances];
    List<_RecordData> height = [...data._heights];
    List<_RecordData> weight = [...data._weights];

    int callback(_RecordData a, _RecordData b) {
      return a.date.difference(b.date).inSeconds;
    }

    calories.sort(callback);
    distance.sort(callback);
    height.sort(callback);
    weight.sort(callback);

    _calorie = calories.isEmpty ? _calorie = 0 : calories.last._amount;
    _distance = distance.isEmpty ? _distance = 0 : distance.last._amount;
    _height = height.isEmpty ? _height = 0 : height.last._amount;
    _weight = weight.isEmpty ? _weight = 0 : weight.last._amount;
  }
}

class _RecordsData extends Model {
  final Map<FType, List<_RecordData>> _data = {};

  List<_RecordData> get _calories => _data[FType.calorie] ?? [];
  List<_RecordData> get _distances => _data[FType.distance] ?? [];
  List<_RecordData> get _heights => _data[FType.height] ?? [];
  List<_RecordData> get _weights => _data[FType.weight] ?? [];

  set _calories(List<_RecordData> data) => _data[FType.calorie] = data;
  set _distances(List<_RecordData> data) => _data[FType.distance] = data;
  set _heights(List<_RecordData> data) => _data[FType.height] = data;
  set _weights(List<_RecordData> data) => _data[FType.weight] = data;

  void setData(FType type, List<_RecordData> data) {
    [
      _calories = data,
      _distances = data,
      _heights = data,
      _weights = data,
    ][type.index];
  }

  List<DateTime> get doneDates {
    Set<DateTime> dates = {};
    for (var r in _calories) { dates.add(r.date.ignoreTime); }
    for (var r in _distances) { dates.add(r.date.ignoreTime); }
    for (var r in _heights) { dates.add(r.date.ignoreTime); }
    for (var r in _weights) { dates.add(r.date.ignoreTime); }
    return dates.toList(growable: true);
  }

  num getAmounts(FType type, DateRange range) {
    List<_RecordData>? dataList = _data[type];
    if (dataList == null) return .0;
    Iterable<_RecordData> filtered = dataList.where((c) {
      return range.inRange(c.date);
    });
    return sum(filtered.map((a) => a._amount));
  }

  _RecordsData();
  _RecordsData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    final cal = json['calorie'];
    final dis = json['distance'];
    final hei = json['height'];
    final wei = json['weight'];
    if (cal != null) _calories = cal.map<_RecordData>((data) => _RecordData.fromJson(data)).toList();
    if (dis != null) _distances = dis.map<_RecordData>((data) => _RecordData.fromJson(data)).toList();
    if (hei != null) _heights = hei.map<_RecordData>((data) => _RecordData.fromJson(data)).toList();
    if (wei != null) _weights = wei.map<_RecordData>((data) => _RecordData.fromJson(data)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['calorie'] = _calories.isNotEmpty ? _calories.map((data) => data.toJson()).toList() : [];
    json['distance'] = _distances.isNotEmpty ? _distances.map((data) => data.toJson()).toList() : [];
    json['height'] = _heights.isNotEmpty ? _heights.map((data) => data.toJson()).toList(): [];
    json['weight'] = _weights.isNotEmpty ? _weights.map((data) => data.toJson()).toList() : [];
    return json;
  }

  @override
  String get key => '';
}

class _RecordData extends Model {
  late num _amount;
  late Timestamp _date;

  DateTime get date => _date.toDate();
  set date(DateTime date) => date.toTimestamp;

  _RecordData(this._amount, DateTime d) { _date = d.toTimestamp!; }
  _RecordData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _amount = json['amount'];
    _date = json['date'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['amount'] = _amount;
    json['date'] = _date;
    return json;
  }

  @override
  String get key => '';
}

class FUserRecordBuilder {
  late String uid;

  final _goals = _RecordsData();
  final _inputRecords = _RecordsData();
  final _records = _RecordsData();

  void setGoal(FType type, num value) {
    List<_RecordData> data = [_RecordData(value, today)];
    _goals.setData(type, data);
  }

  FUserRecord build() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['goals'] = _goals.toJson();
    json['inputRecords'] = _inputRecords.toJson();
    json['records'] = _records.toJson();

    return FUserRecord.fromJson(json);
  }
}