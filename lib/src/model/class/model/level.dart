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
  late Map<String, String> _titles;
  Map<String, String>? _descriptions;
  late num _amount;
  late bool _activate;
  late int _point;

  int get index => int.parse(_id.substring(2, 3));

  String get _locale => LangCont.to.language.code;
  String get title => _titles[_locale]!;
  String get description => _descriptions![_locale]!;
  bool get activate => _activate;
  Amount get amount => [
    DistanceAmount()..km = _amount,
    HeightAmount()..floor = _amount,
    WeightAmount()..t = _amount,
  ][type.index - 1];
  FType get type => FType.values[int.parse(_id[2])];

  String get imageUrl => '$_asset/${type.name}/$_id.png';

  bool isLessThan(Level level) { return amount.value < level.amount.value; }
  bool isMoreThan(Level level) { return amount.value > level.amount.value; }
  bool isEqualTo(Level level) { return !isLessThan(level) && !isMoreThan(level); }

  LevelLocal get _local => LevelLocal.byType(type)!;

  int get lv => _local.getCurrent(amount);
  Level get before => _local.getBeforeLevel(amount);
  Level get next => _local.getNextLevel(amount);

  num get goal => next.amount.main - amount.main;
  num getCurrentValue(Amount amount) {
    num value = amount.main - this.amount.main;
    return min(max(value, 0), goal);
  }

  bool satisfies(num value) => amount.main <= value;
  bool inRange(num value) => amount.main <= value && next.amount.main > value;

  bool isAchievedAmount(Amount amount) => amount.main >= this.amount.main;
  double getPercent(Amount amount) => getCurrentValue(amount) / goal;

  String get _badgeId => '10${type.index}${_id.substring(_id.length - 4, _id.length)}';
  FBadge get badge => FBadge.fromId(_badgeId);

  num get point => _point;
  List<num> get pointDivided {
    String p = '$_point';
    List<int> list = [];
    for (int i = 0; i < min(p.length, 5); i++) {
      list.add(int.parse(p[p.length - i - 1]));
    }
    return list;
  }

  List<Item> get _itemList => List.generate(4, (i) => Item.fromId('400000${i * 2}'));

  List<Item> get items {
    List<Item> list = [];
    for (int i = 0; i < pointDivided.length; i++) {
      if (pointDivided[i] > 0) list.add(_itemList[i]);
    }
    return list;
  }

  Level.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _titles = Map.fromIterables(
      json['title'].keys,
      json['title'].values.map<String>((e) => e.toString()),
    );
    _amount = json['amount'];
    _descriptions = Map.fromIterables(
      json['description'].keys,
      json['description'].values.map<String>((e) => e.toString()),
    );
    _activate = json['activate'];
    _point = json['point'];
  }

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();

  @override
  String get key => _id;
}