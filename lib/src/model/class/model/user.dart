import 'package:fitween/global/date.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Sex {
  male, female;
  String get locale => LangCont.tr('word.$name');

  static Sex? toEnum(String? string) =>
      values.firstWhereOrNull((sex) => sex.name == string);
}

class FUser extends Model {
  late final String uid;
  FUserBattle? battle;
  FUserCollection? collection;
  FUserFriend? friend;
  FUserInfo? info;
  FUserNotification? notification;
  FUserParty? party;
  FUserRecord? record;

  // battle
  Map<String, Battle> get battles => battle!.battles;

  // collection
  Collection? get profileCollection => collections[collection!.badgeId];
  Map<String, Collection> get collections => collection!.collections;
  List<Collection> get orderedCollections => collection!.ordered;

  FBadge? get badge => collection!.badge;
  Color get badgeColor => collection!.badgeColor;

  // friend
  Map<String, FUser> get friends => friend!.friends;
  Map<String, FUser> get rivals => friend!.rivals;

  // info
  String? get name => info!.name;
  String get nickname => info!.nickname;
  DateTime get regDate => info!.regDate;
  String get email => info!.email;
  DateTime get dateOfBirth => info!.dateOfBirth;
  Sex get sex => info!.sex;
  num get weight => info!.weight;
  num get height => info!.height;
  bool get isAmin => info!.isAdmin;
  bool get isAppleInspector => info!.isAppleInspector;

  int get age => dateOfBirth.age;
  int get generation => dateOfBirth.generation;
  bool get isMale => sex == Sex.male;
  bool get isFemale => sex == Sex.female;

  int get weekCount => today.difference(regDate).inDays ~/ 7;

  // party
  Map<String, Party> get parties => party!.parties;

  // record
  bool get visible => record!.visible;
  void toggleVisibility() => record!.toggleVisibility();

  Goal get goal => record!.goal;
  Map<FType, num> getOneDayRecord(DateTime date) => record!.getOneDayRecord(date);
  Map<FType, num> getOneWeekRecord(DateTime date) => record!.getOneWeekRecord(date);
  Map<FType, num> getOneMonthRecord(DateTime date) => record!.getOneMonthRecord(date);
  Map<FType, num> getFromRecord(DateTime from) => record!.getFromRecord(from);
  Map<FType, num> getToRecord(DateTime to) => record!.getToRecord(to);
  Map<FType, num> getRecord(DateTime from, DateTime to) => record!.getRecord(from, to);
  Map<FType, num> get allRecord => record!.allRecord;

  void setRecord(FType type, Amount amount, DateTime date) => record!.setRecord(type, amount, date);
  void setRecordByValue(FType type, num value, DateTime date) => record!.setRecordByValue(type, value, date);
  void setTodayRecord(FType type, Amount amount) => record!.setTodayRecord(type, amount);
  void setTodayRecordByValue(FType type, num value) => record!.setTodayRecordByValue(type, value);

  Map<DateTime, List<CalendarEvent>> get events => record!.events;

  bool completed(FType type, DateTime date) => record!.completed(type, date);
  bool started(FType type, DateTime date) => record!.started(type, date);

  List<DateTime> get logDates => record!.logDates;
  DateTime get latestLogDate => record!.latestLogDate;

  FUser(String key) : uid = key;

  FUser.builder(FUserBuilder builder) {
    uid = builder.uid;
    battle = builder.battle;
    collection = builder.collection;
    friend = builder.friend;
    info = builder.info;
    notification = builder.notification;
    party = builder.party;
    if (builder.record == null) return;
    record = builder.record!..info = builder.info;
  }

  FUser.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    battle = FUserBattle.fromJson(json);
    collection = FUserCollection.fromJson(json);
    friend = FUserFriend.fromJson(json);
    info = FUserInfo.fromJson(json);
    notification = FUserNotification.fromJson(json);
    party = FUserParty.fromJson(json);
    record = FUserRecord.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json.addAll(battle?.toJson() ?? {});
    json.addAll(collection?.toJson() ?? {});
    json.addAll(friend?.toJson() ?? {});
    json.addAll(info?.toJson() ?? {});
    json.addAll(notification?.toJson() ?? {});
    json.addAll(party?.toJson() ?? {});
    json.addAll(record?.toJson() ?? {});
    return json;
  }

  static FUser combine(FUser? a, FUser? b) {
    assert(a != null || b != null);
    if (a == null) return b!;
    if (b == null) return a;
    return a..merge(b);
  }

  void merge(FUser user) {
    battle = user.battle ?? battle;
    collection = user.collection ?? collection;
    friend = user.friend ?? friend;
    info = user.info ?? info;
    notification = user.notification ?? notification;
    party = user.party ?? party;
    record = user.record ?? record;
  }

  @override
  String get key => uid;

}

class FUserBuilder {
  late String uid;
  FUserBattle? battle;
  FUserCollection? collection;
  FUserFriend? friend;
  FUserInfo? info;
  FUserNotification? notification;
  FUserParty? party;
  FUserRecord? record;
}

class FUserLoadCont {
  late bool battle;
  late bool collection;
  late bool friend;
  late bool info;
  late bool notification;
  late bool party;
  late bool record;

  FUserLoadCont({
    this.battle = false,
    this.collection = false,
    this.friend = false,
    this.info = true,
    this.notification = false,
    this.party = false,
    this.record = false,
  });

  static FUserLoadCont lightest() => FUserLoadCont();
  static FUserLoadCont onlyBattle() {
    FUserLoadCont cont = lightest();
    cont.battle = true;
    return cont;
  }

  static FUserLoadCont onlyCollection() {
    FUserLoadCont cont = lightest();
    cont.collection = true;
    return cont;
  }

  static FUserLoadCont onlyFriend() {
    FUserLoadCont cont = lightest();
    cont.friend = true;
    return cont;
  }

  static FUserLoadCont onlyNotification() {
    FUserLoadCont cont = lightest();
    cont.notification = true;
    return cont;
  }

  static FUserLoadCont onlyParty() {
    FUserLoadCont cont = lightest();
    cont.party = true;
    return cont;
  }

  static FUserLoadCont onlyRecord() {
    FUserLoadCont cont = lightest();
    cont.record = true;
    return cont;
  }

  FUserLoadCont.all()
      : battle = true,
        collection = true,
        friend = true,
        info = true,
        notification = true,
        party = true,
        record = true;
}