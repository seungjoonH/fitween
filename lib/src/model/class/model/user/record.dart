import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/number.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/date_range.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';

class FUserRecord extends FUser {
  @override
  FUserRecord? get record => this;

  late _RecordsData _goals;
  late _RecordsData _inputRecords;
  late _RecordsData _records;

  Map<Period, List<RankingData>> _rankings = {};

  @override
  Map<Period, List<RankingData>> get rankings => _rankings;

  late bool _visible;

  @override
  bool get visible => _visible;

  @override
  void toggleVisibility() => _visible = !_visible;

  late Goal _goal;

  @override
  Goal get goal => _goal;

  void updateGoalData(FUserRecord other) {
    _goals = other._goals;
    _goal = Goal._fromRecordsData(_goals);
  }

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
      FType.activeValues.map((type) => MapEntry(type, .0)),
    );

    for (FType type in FType.activeValues) {
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
  void setRecord(FType type, Amount amount, DateTime date) {
    num value = .0;

    switch (type) {
      case FType.distance: value = (amount as DistanceAmount).step; break;
      case FType.height: value = (amount as HeightAmount).floor; break;
      case FType.weight: value = (amount as WeightAmount).cnt; break;
      default: break;
    }
    setRecordByValue(type, value, date);
  }
  @override
  void setRecordByValue(FType type, num value, DateTime date) {
    _RecordData data = _RecordData(value, date);
    _records.setRecordData(type, data);
  }
  @override
  void setTodayRecord(FType type, Amount amount) {
    setRecord(type, amount, today);
  }
  @override
  void setTodayRecordByValue(FType type, num value) {
    setRecordByValue(type, value, today);
  }

  @override
  Map<DateTime, List<CalendarEvent>> get events {
    DateTime startDate = regDate;
    DateTime endDate = tomorrow.add(1.d).ignoreTime;

    Map<DateTime, List<CalendarEvent>> eventMap = {};

    for (DateTime date in daysInRange(startDate, endDate)) {
      date = date.ignoreTime;
      eventMap[date] = FType.activeValues.map((type) {
        num goalValue = goal.byDate(date, type);
        num record = getOneDayRecord(date)[type]!;
        return CalendarEvent(goalValue, record);
      }).toList();
    }

    return eventMap;
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

  DateTime? getLatestRankedDate(Period period) {
    DateTime? latest;
    for (RankingData data in _rankings[period]!) {
      latest = later(data.date, latest ?? regDate);
    }
    return latest;
  }

  @override
  void setRankedData(Period period, RankingData data) async {
    DateTime date = data.date;
    int index = rankings[period]!
        .indexWhere((ranking) => date.isAtSameMomentAs(ranking.date));
    if (index < 0) { rankings[period]!.add(data); return; }

    RankingData rankedData = rankings[period]![index];
    if (rankedData.finished) return;

    rankings[period]!.removeAt(index);
    rankings[period]!.insert(index, rankedData);
  }

  RankingData? getRankingData(Period period, DateTime date) {
    for (RankingData data in rankings[period]!) {
      if (data.date.isAtSameMomentAs(date)) return data;
    }
    return null;
  }

  void receivePoint(Period period, DateTime date, FType type) {
    RankingData? data = getRankingData(period, date);
    if (data == null) return;
    data.receive(type);
  }

  FUserRecord(super.key) : super();
  FUserRecord.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _visible = json['visible'] ?? false;
    _goals = _RecordsData.fromJson(json['goals']);
    _inputRecords = _RecordsData.fromJson(json['inputRecords']);
    _records = _RecordsData.fromJson(json['records']);
    _goal = Goal._fromRecordsData(_goals);
    _rankings = Map.fromIterables(
      json['rankings']?.keys
          .map<Period>((e) => Period.toEnum(e)!).toList() ?? Period.values,
      json['rankings']?.values
          .map<List<RankingData>>((list) => (list as List<dynamic>)
          .map<RankingData>((e) => RankingData.fromJson((e as Map<String, dynamic>)))
          .toList()).toList() ?? Period.values.map((e) => []),
    );

  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['visible'] = _visible;
    json['goals'] = _goals.toJson();
    json['inputRecords'] = _inputRecords.toJson();
    json['records'] = _records.toJson();
    json['rankings'] = Map.fromIterables(
      _rankings.keys.map((e) => e.name),
      _rankings.values.map((list) => list.map((e) => e.toJson())),
    );
    return json;
  }
}

class Goal {
  late List<_RecordData> _calorieData;
  late List<_RecordData> _distanceData;
  late List<_RecordData> _heightData;
  late List<_RecordData> _weightData;

  late num _calorie;
  late num _distance;
  late num _height;
  late num _weight;

  num get calorie => _calorie;
  num get distance => _distance;
  num get height => _height;
  num get weight => _weight;

  final _data = <FType, Map<DateTime, num>>{};

  num byType(FType type) => [
    _calorie, _distance, _height, _weight
  ][type.index];

  num byDate(DateTime date, FType type) {
    return _data[type]![date.ignoreTime]!;
  }

  Goal._fromRecordsData(_RecordsData data) {
    _fromRecordsData(data);
  }

  void _fromRecordsData(_RecordsData data) {
    _calorieData = [...data._calories];
    _distanceData = [...data._distances];
    _heightData = [...data._heights];
    _weightData = [...data._weights];

    int compare(_RecordData a, _RecordData b) {
      return a.date.difference(b.date).inSeconds;
    }

    _calorieData.sort(compare);
    _distanceData.sort(compare);
    _heightData.sort(compare);
    _weightData.sort(compare);

    _calorie = _calorieData.isEmpty ? _calorie = 0 : _calorieData.last._amount;
    _distance = _distanceData.isEmpty ? _distance = 0 : _distanceData.last._amount;
    _height = _heightData.isEmpty ? _height = 0 : _heightData.last._amount;
    _weight = _weightData.isEmpty ? _weight = 0 : _weightData.last._amount;

    _data[FType.calorie] = _convertToMap(_calorieData);
    _data[FType.distance] = _convertToMap(_distanceData);
    _data[FType.height] = _convertToMap(_heightData);
    _data[FType.weight] = _convertToMap(_weightData);
  }

  Map<DateTime, num> _convertToMap(List<_RecordData> data) {
    Map<DateTime, num> map = Map.fromEntries(data.map((d) => MapEntry(d.date.ignoreTime, d._amount)));
    if (data.isEmpty) return {};

    DateTime startDate = data.first.date.ignoreTime;
    DateTime endDate = tomorrow.add(1.d).ignoreTime;
    DateRange range = DateRange(startDate, endDate);

    num value = data.first._amount;
    for (DateTime date in range.dates) {
      date = date.ignoreTime;
      value = map[date] ?? value;
      map[date] = value;
    }

    return map;
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

  void setGoalData(FType type, _RecordData data) {
    List<_RecordData> dataList = _data[type]!;

    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i].date.isAtSameMomentAs(data.date)) {
        dataList.removeAt(i);
        dataList.insert(i, data);
        return;
      }
    }

    if (dataList.last._amount == data._amount) return;
    _data[type] = dataList..add(data);
  }

  List<DateTime> get doneDates {
    Set<DateTime> dates = {};
    for (var r in _calories) { dates.add(r.date.ignoreTime); }
    for (var r in _distances) { dates.add(r.date.ignoreTime); }
    for (var r in _heights) { dates.add(r.date.ignoreTime); }
    for (var r in _weights) { dates.add(r.date.ignoreTime); }
    return dates.toList(growable: true);
  }

  void setRecordData(FType type, _RecordData data) {
    List<_RecordData> dataList = _data[type]!;
    int i = dataList.indexWhere((d) => d.date.isAtSameMomentAs(data.date));
    if (i < 0) { _data[type] = dataList..add(data); return; }
    _data[type]![i] = data;
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
    _calories.removeWhere((data) => data._amount == 0);
    _distances.removeWhere((data) => data._amount == 0);
    _heights.removeWhere((data) => data._amount == 0);
    _weights.removeWhere((data) => data._amount == 0);
    int compare(_RecordData a, _RecordData b) => a.date.compareTo(b.date);
    _calories.sort(compare); _distances.sort(compare);
    _heights.sort(compare); _weights.sort(compare);
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

class RankingData extends Model {
  late Timestamp _date;
  late int _point;
  late bool _finished;
  late Map<FType, bool> _received;

  Map<String, RankingPersonalData> _distance = {};
  Map<String, RankingPersonalData> _height = {};
  Map<String, RankingPersonalData> _weight = {};

  int get point => _point;

  bool get finished => _finished;
  bool getReceived(FType type) => _received[type]!;

  void finish() => _finished = true;
  void receive(FType type) => _received[type] = true;

  DateTime get date => _date.toDate();
  set date(DateTime d) => _date = d.toTimestamp!;

  void setPoint(int point) => _point = point;
  void addPoint(int point) => _point += point;

  void setDataByType(FType type, String uid, RankingPersonalData data) {
    assert(type != FType.calorie);
    switch (type) {
      case FType.distance: _distance[uid] = data; break;
      case FType.height: _height[uid] = data; break;
      case FType.weight: _weight[uid] = data; break;
      default: break;
    }
  }

  Map<String, RankingPersonalData> getDataByType(FType type) {
    assert(type != FType.calorie);
    return [_distance, _height, _weight][type.index - 1];
  }

  RankingPersonalData getOnesDataByType(FType type, String uid) {
    return getDataByType(type)[uid]!;
  }

  RankingData({
    required DateTime date,
    int fPoint = 0,
    bool finished = false,
  }) {
    this.date = date;
    _point = fPoint;
    _finished = finished;
    _received = { for (var key in FType.activeValues) key : false };
  }
  RankingData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _date = json['date'];
    _point = json['point'];
    _finished = json['finished'];
    _received = Map.fromIterables(
      json['received'].keys.map<FType>((e) => FType.toEnum(e!)!).toList(),
      json['received'].values.toList().cast<bool>(),
    );
    _distance = Map.fromIterables(
      json['distance'].keys,
      json['distance'].values.map<RankingPersonalData>((d) => RankingPersonalData.fromJson(d)).toList(),
    );
    _height = Map.fromIterables(
      json['height'].keys,
      json['height'].values.map<RankingPersonalData>((d) => RankingPersonalData.fromJson(d)).toList(),
    );
    _weight = Map.fromIterables(
      json['weight'].keys,
      json['weight'].values.map<RankingPersonalData>((d) => RankingPersonalData.fromJson(d)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['date'] = _date;
    json['point'] = _point;
    json['finished'] = _finished;
    json['received'] = Map.fromIterables(
      _received.keys.map((type) => type.name).toList(),
      _received.values,
    );
    json['distance'] = Map.fromIterables(
      _distance.keys,
      _distance.values.map((d) => d.toJson()),
    );
    json['height'] = Map.fromIterables(
      _height.keys,
      _height.values.map((d) => d.toJson()),
    );
    json['weight'] = Map.fromIterables(
      _weight.keys,
      _weight.values.map((d) => d.toJson()),
    );
    return json;
  }

  @override
  String get key => throw UnimplementedError();
}

class RankingPersonalData extends Model {
  late num _amount;
  late int _rank;

  num get amount => _amount;

  RankingPersonalData(num amount, int rank) {
    _amount = amount;
    _rank = rank;
  }
  RankingPersonalData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _amount = json['amount'];
    _rank = json['rank'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['amount'] = _amount;
    json['rank'] = _rank;
    return json;
  }

  @override
  String get key => throw UnimplementedError();
}


class FUserRecordBuilder {
  late String uid;

  _RecordsData _goals = _RecordsData();
  _RecordsData _inputRecords = _RecordsData();
  _RecordsData _records = _RecordsData();

  void setGoal(FType type, num value) {
    _RecordData data = _RecordData(value, today);
    _goals.setGoalData(type, data);
  }

  void setBuilder(FUserRecord other) {
    _goals = other._goals;
    _inputRecords = other._inputRecords;
    _records = other._records;
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