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

  late RecordsData _goals;
  late RecordsData _inputRecords;
  late RecordsData _records;

  RecordsData get inputRecords => _inputRecords;
  RecordsData get records => _records;

  List<Timestamp> _androidLog = [];
  List<Timestamp> _weightLog = [];

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

  List<DateTime> get androidLog => _androidLog.map((d) => d.toDate()).toList();
  void syncAndroidLogFrom(List<DateTime> log) => _androidLog = log.map((d) => d.toTimestamp!).toList();

  List<DateTime> get weightLog => _weightLog.map((d) => d.toDate()).toList();
  void syncWeightLogFrom(List<DateTime> log) => _weightLog = log.map((d) => d.toTimestamp!).toList();

  void syncRecordsData(RecordsData data, [RecordsData? inputData]) {
    if (inputData != null) _inputRecords = inputData;
    _records = data;
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
        var cont = RecordCont(this)..syncFromUser();
        num record = cont.getOneDayValue(type, date);
        return CalendarEvent(goalValue, record);
      }).toList();
    }

    return eventMap;
  }

  @override
  bool allCompleted(DateTime date) => FType.activeValues
      .map((type) => completed(type, date))
      .every((c) => c);

  @override
  bool completed(FType type, DateTime date) {
    var cont = RecordCont(this)..syncFromUser();
    num value = cont.getOneDayValue(type, date);
    num goalValue = goal.byDate(date, type);
    return value >= goalValue;
  }

  @override
  bool started(FType type, DateTime date) {
    var cont = RecordCont(this)..syncFromUser();
    num value = cont.getOneDayValue(type, date);
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

  void _initRanking() {
    for (Period p in Period.values) {
      _rankings[p] = [ RankingData(date: p.getCurrentDate(today)) ];
    }
  }

  FUserRecord(super.key, {FUserInfo? info}) {
    this.info = info;
    _visible = true;
    _goals = RecordsData.initGoal(regDate.ignoreTime);
    _inputRecords = RecordsData();
    _records = RecordsData();
    _initRanking();
  }
  FUserRecord.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _visible = json['visible'] ?? true;
    _goals = RecordsData.fromJson(json['goals']);
    _inputRecords = RecordsData.fromJson(json['inputRecords']);
    _records = RecordsData.fromJson(json['records']);
    _goal = Goal._fromRecordsData(_goals);
    _rankings = Map.fromIterables(
      json['rankings']?.keys
          .map<Period>((e) => Period.toEnum(e)!).toList() ?? Period.values,
      json['rankings']?.values
          .map<List<RankingData>>((list) => (list as List<dynamic>)
          .map<RankingData>((e) => RankingData.fromJson((e as Map<String, dynamic>)))
          .toList()).toList() ?? Period.values.map((e) => []),
    );
    _androidLog = json['androidLog']?.cast<Timestamp>() ?? <Timestamp>[];
    _weightLog = json['weightLog']?.cast<Timestamp>() ?? <Timestamp>[];
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
    json['androidLog'] = _androidLog;
    json['weightLog'] = _weightLog;
    return json;
  }
}

class Goal {
  static final DistanceAmount defaultDis = DistanceAmount()..min = 60;
  static final HeightAmount defaultHei = HeightAmount()..floor = 10;
  static final WeightAmount defaultWei = WeightAmount()..cnt = 50;

  late List<RecordData> _calorieData;
  late List<RecordData> _distanceData;
  late List<RecordData> _heightData;
  late List<RecordData> _weightData;

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
    return _data[type]![date.ignoreTime] ?? byType(type);
  }

  Goal._fromRecordsData(RecordsData data) {
    _fromRecordsData(data);
  }

  void _fromRecordsData(RecordsData data) {
    _calorieData = [...data._calories];
    _distanceData = [...data._distances];
    _heightData = [...data._heights];
    _weightData = [...data._weights];

    int compare(RecordData a, RecordData b) {
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

  Map<DateTime, num> _convertToMap(List<RecordData> data) {
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

class RecordsData extends Model {
  final Map<FType, List<RecordData>> _data = {};

  List<RecordData> get _calories => _data[FType.calorie] ?? [];
  List<RecordData> get _distances => _data[FType.distance] ?? [];
  List<RecordData> get _heights => _data[FType.height] ?? [];
  List<RecordData> get _weights => _data[FType.weight] ?? [];

  set _calories(List<RecordData> data) => _data[FType.calorie] = data;
  set _distances(List<RecordData> data) => _data[FType.distance] = data;
  set _heights(List<RecordData> data) => _data[FType.height] = data;
  set _weights(List<RecordData> data) => _data[FType.weight] = data;

  // set _calorie(RecordData data) {
  //   if (_data[FType.calorie] == null) _data[FType.calorie] = [];
  //   _data[FType.calorie]!.add(data);
  // }
  // set _distance(RecordData data) {
  //   if (_data[FType.distance] == null) _data[FType.distance] = [];
  //   _data[FType.distance]!.add(data);
  // }
  // set _height(RecordData data) {
  //   if (_data[FType.height] == null) _data[FType.height] = [];
  //   _data[FType.height]!.add(data);
  // }
  // set _weight(RecordData data) {
  //   if (_data[FType.weight] == null) _data[FType.weight] = [];
  //   _data[FType.weight]!.add(data);
  // }

  void setInitGoalData(DateTime regDate) {
    setGoalData(FType.distance, RecordData(Goal.defaultDis.step, regDate));
    setGoalData(FType.height, RecordData(Goal.defaultHei.floor, regDate));
    setGoalData(FType.weight, RecordData(Goal.defaultWei.cnt, regDate));
  }

  void setGoalData(FType type, RecordData data) {
    List<RecordData> dataList = _data[type] ?? <RecordData>[];

    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i].date.isAtSameMomentAs(data.date)) {
        dataList.removeAt(i);
        dataList.insert(i, data);
        return;
      }
    }

    if (dataList.isNotEmpty && dataList.last._amount == data._amount) return;
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

  void setRecordData(FType type, RecordData data) {
    List<RecordData> dataList = _data[type]!;
    int i = dataList.indexWhere((d) => d.date.isAtSameMomentAs(data.date));
    if (i < 0) { _data[type] = dataList..add(data); return; }
    _data[type]![i] = data;
  }

  num getAmounts(FType type, DateRange range) {
    List<RecordData>? dataList = _data[type];
    if (dataList == null) return .0;
    Iterable<RecordData> filtered = dataList.where((c) {
      return range.inRange(c.date);
    });
    return sum(filtered.map((a) => a._amount));
  }

  void init() {
    for (FType type in FType.values) { _data[type] = <RecordData>[]; }
  }

  RecordsData() { init(); }
  RecordsData.initGoal(DateTime regDate) { init(); setInitGoalData(regDate); }
  RecordsData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    final cal = json['calorie'];
    final dis = json['distance'];
    final hei = json['height'];
    final wei = json['weight'];
    if (cal != null) _calories = cal.map<RecordData>((data) => RecordData.fromJson(data)).toList();
    if (dis != null) _distances = dis.map<RecordData>((data) => RecordData.fromJson(data)).toList();
    if (hei != null) _heights = hei.map<RecordData>((data) => RecordData.fromJson(data)).toList();
    if (wei != null) _weights = wei.map<RecordData>((data) => RecordData.fromJson(data)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    _calories.removeWhere((data) => data._amount == 0);
    _distances.removeWhere((data) => data._amount == 0);
    _heights.removeWhere((data) => data._amount == 0);
    _weights.removeWhere((data) => data._amount == 0);
    int compare(RecordData a, RecordData b) => a.date.compareTo(b.date);
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

class RecordData extends Model {
  late num _amount;
  late Timestamp _date;

  DateTime get date => _date.toDate();
  set date(DateTime date) => date.toTimestamp;

  RecordData(this._amount, DateTime d) { _date = d.toTimestamp!; }
  RecordData.fromJson(super.json) : super.fromJson();

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

  RecordsData _goals = RecordsData();
  RecordsData _inputRecords = RecordsData();
  RecordsData _records = RecordsData();

  void setGoal(FType type, num value) {
    RecordData data = RecordData(value, today);
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