import 'dart:math';

import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';

class Level extends Model {
  static const String _asset = 'assets/image/level';
  static const String cloudUrl = '$_asset/cloud.png';
  static const String voidUrl = '$_asset/void.png';

  late String _id;
  late String _title;
  String? _description;
  late num _amount;
  late bool _activate;

  String get title => _title;
  String get description => _description ?? '';
  bool get activate => _activate;
  Amount get amount => [
    DistanceAmount()..km = _amount,
    HeightAmount()..floor = _amount,
    WeightAmount()..t = _amount,
  ][type.index - 1];
  FType get type => FType.values[int.parse(_id[2])];

  String get imageUrl => '$_asset/${type.name}/$_id.png';

  bool lessThan(Level level) { return amount.value < level.amount.value; }
  bool moreThan(Level level) { return amount.value > level.amount.value; }

  LevelLocal get _local => LevelLocal.byType(type)!;

  int get lv => _local.getCurrent(amount);
  Level get before => _local.getBeforeLevel(amount);
  Level get next => _local.getNextLevel(amount);

  num get goal => next.amount.main - amount.main;
  num getCurrentValue(Amount amount) {
    num value = amount.main - this.amount.main;
    return min(max(value, 0), goal);
  }

  bool isAchievedAmount(Amount amount) => amount.main >= this.amount.main;
  double getPercent(Amount amount) => getCurrentValue(amount) / goal;

  // num _convertAmount(num value) {
  //   if (type != FType.weight) return value;
  //   return (WeightAmount()..t = value).kg;
  // }

  Level.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _title = json['title'][LangCont.locale];
    _amount = json['amount'];
    _description = json['description'][LangCont.locale];
    _activate = json['activate'];
  }

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();

  @override
  String get key => _id;


}