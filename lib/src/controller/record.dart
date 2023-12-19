import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/date_range.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';

class RecordCont {
  RecordCont(FUser user) { _user = user; }
  RecordCont.logged() { _user = AuthCont.logged!; }

  late FUser _user;

  late RecordsData _inputRecords;
  late RecordsData _records;

  Future syncRecordsDataFrom() async {
    _user.record = await FUserRecordDAO().loadOne(_user.key);
    syncFromUser();
  }

  Future syncRecordsDataTo() async {
    syncToUser();
    await FUserRecordDAO().saveOne(_user.record!);
  }

  void syncFromUser() {
    _inputRecords = _user.record!.inputRecords;
    _records = _user.record!.records;
  }

  void syncToUser() {
    _user.record!.syncRecordsData(_records, _inputRecords);
  }

  Map<FType, num> get todayValues => getValues(today, today);
  Map<FType, num> getOneDayValues(DateTime date) => getValues(date, date);
  Map<FType, num> getOneWeekValues(DateTime date) {
    DateTime from = date;
    DateTime to = from.add(1.w).subtract(1.d);
    return getValues(from, to);
  }

  Map<FType, num> getOneMonthValues(DateTime date, {int days = 30}) {
    DateTime from = date;
    late DateTime to;
    if (date.day == 1) { to = from.lastDayOfMonth; }
    else { to = from.add(days.d).subtract(1.d); }
    return getValues(from, to);
  }

  Map<FType, num> getFromValues(DateTime from) => getValues(from, today);
  Map<FType, num> getToValues(DateTime to) => getValues(_user.regDate, to);
  Map<FType, num> getValues(DateTime from, DateTime to) {
    DateTime fromDate = later(_user.regDate, from);
    DateTime toDate = earlier(to.lastTimeOfDay, now);

    Map<FType, num> data = Map.fromEntries(
      FType.activeValues.map((type) => MapEntry(type, .0)),
    );

    for (FType type in FType.activeValues) {
      num amount = data[type]!;
      amount += _inputRecords.getAmounts(type, DateRange(fromDate, toDate));
      amount += _records.getAmounts(type, DateRange(fromDate, toDate));
      data[type] = amount;
    }

    return data;
  }

  Map<FType, num> get allValues => getValues(_user.regDate, today);

  num getTodayValue(FType type) => todayValues[type]!;
  num getOneDayValue(FType type, DateTime date) => getOneDayValues(date)[type]!;
  num getOneWeekValue(FType type, DateTime date) => getOneWeekValues(date)[type]!;
  num getOneMonthValue(FType type, DateTime date, {int days = 30}) => getOneMonthValues(date, days: days)[type]!;
  num getFromValue(FType type, DateTime from) => getFromValues(from)[type]!;
  num getToValue(FType type, DateTime to) => getToValues(to)[type]!;
  num getValue(FType type, DateTime from, DateTime to) => getValues(from, to)[type]!;
  num getAllValue(FType type) => allValues[type]!;

  Map<FType, Amount> get todayAmounts => getOneDayAmounts(today);
  Map<FType, Amount> getOneDayAmounts(DateTime date) => getAmounts(date, date);
  Map<FType, Amount> getOneWeekAmounts(DateTime date) {
    DateTime from = date;
    DateTime to = from.add(1.w).subtract(1.d);
    return getAmounts(from, to);
  }
  Map<FType, Amount> getOneMonthAmounts(DateTime date, {int days = 30}) {
    DateTime from = date;
    late DateTime to;
    if (date.day == 1) { to = from.lastDayOfMonth; }
    else { to = from.add(days.d).subtract(1.d); }
    return getAmounts(from, to);
  }
  Map<FType, Amount> getFromAmounts(DateTime from) => getAmounts(from, today);
  Map<FType, Amount> getToAmounts(DateTime to) => getAmounts(_user.regDate, to);
  Map<FType, Amount> getAmounts(DateTime from, DateTime to) {
    return getValues(from, to.lastTimeOfDay).map<FType, Amount>((type, value) {
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

  Map<FType, Amount> get allAmounts => getAmounts(_user.regDate, today);

  Amount getTodayAmount(FType type) => todayAmounts[type]!;
  Amount getOneDayAmount(FType type, DateTime date) => getOneDayAmounts(date)[type]!;
  Amount getOneWeekAmount(FType type, DateTime date) => getOneWeekAmounts(date)[type]!;
  Amount getOneMonthAmount(FType type, DateTime date, {int days = 30}) => getOneMonthAmounts(date, days: days)[type]!;
  Amount getFromAmount(FType type, DateTime from) => getFromAmounts(from)[type]!;
  Amount getToAmount(FType type, DateTime to) => getToAmounts(to)[type]!;
  Amount getAmount(FType type, DateTime from, DateTime to) => getAmounts(from, to)[type]!;
  Amount getAllAmount(FType type) => allAmounts[type]!;


  void setAmount(FType type, Amount amount, DateTime date) {
    late num value;

    switch (type) {
      case FType.distance: value = (amount as DistanceAmount).step; break;
      case FType.height: value = (amount as HeightAmount).floor; break;
      case FType.weight: value = (amount as WeightAmount).cnt; break;
      default: break;
    }
    setValue(type, value, date);
  }

  void setValue(FType type, num value, DateTime date) {
    RecordData data = RecordData(value, date);
    _records.setRecordData(type, data);
  }

  void addAmount(FType type, Amount amount, DateTime date) {
    num value = getValues(date, date.lastTimeOfDay)[type]!;

    switch (type) {
      case FType.distance: value += (amount as DistanceAmount).step; break;
      case FType.height: value += (amount as HeightAmount).floor; break;
      case FType.weight: value += (amount as WeightAmount).cnt; break;
      default: break;
    }
    setValue(type, value, date);
  }

  void addValue(FType type, num toAdd, DateTime date) {
    num value = getValues(date, date.lastTimeOfDay)[type] ?? .0;
    setValue(type, value + toAdd, date);
  }

  void setTodayAmount(FType type, Amount amount) => setAmount(type, amount, today);
  void setTodayValue(FType type, num value) => setValue(type, value, today);
  void addTodayAmount(FType type, Amount amount) => addAmount(type, amount, today);
  void addTodayValue(FType type, num value) => addValue(type, value, today);

}