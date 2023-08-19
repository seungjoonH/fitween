import 'package:fitween/global/date.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:get/get.dart';

enum Sex {
  male, female;
  String get locale => LangCont.tr('word.$name');

  static Sex? toEnum(String? string) =>
      values.firstWhereOrNull((sex) => sex.name == string);
}

class FUser extends Model {
  late final String uid;
  FUserBattle? _battle;
  FUserCollection? _collection;
  FUserFriend? _friend;
  FUserInfo? _info;
  FUserNotification? _notification;
  FUserParty? _party;
  FUserRecord? _record;

  FUserBattle? get battle => _battle;
  FUserCollection? get collection => _collection;
  FUserFriend? get friend => _friend;
  FUserInfo? get info => _info;
  FUserNotification? get notification => _notification;
  FUserParty? get party => _party;
  FUserRecord? get record => _record;

  // battle
  Map<String, Battle> get battles => _battle!.battles;

  // collection
  Collection? get profileCollection => collections[collection!.badgeId];
  Map<String, Collection> get collections => _collection!.collections;
  List<Collection> get orderedCollections => _collection!.ordered;

  // friend
  Map<String, FUser> get friends => _friend!.friends;
  Map<String, FUser> get rivals => _friend!.rivals;

  // info
  String? get name => _info!.name;
  String
  get nickname => _info!.nickname;
  DateTime get regDate => _info!.regDate;
  String get email => _info!.email;
  DateTime get dateOfBirth => _info!.dateOfBirth;
  Sex get sex => _info!.sex;
  num get weight => _info!.weight;
  num get height => _info!.height;
  bool get isAdmin => _info!.isAdmin;
  bool get isAppleInspector => _info!.isAppleInspector;

  int get age => dateOfBirth.age;
  int get generation => dateOfBirth.generation;
  bool get isMale => sex == Sex.male;
  bool get isFemale => sex == Sex.female;

  // party
  Map<String, Party> get parties => _party!.parties;

  // record
  Goal get goal => _record!.goal;
  Map<FType, num> getOneDayRecord(DateTime date) => _record!.getOneDayRecord(date);
  Map<FType, num> getOneWeekRecord(DateTime date) => _record!.getOneWeekRecord(date);
  Map<FType, num> getOneMonthRecord(DateTime date) => _record!.getOneMonthRecord(date);
  Map<FType, num> getFromRecord(DateTime from) => _record!.getFromRecord(from);
  Map<FType, num> getToRecord(DateTime to) => _record!.getToRecord(to);
  Map<FType, num> getRecord(DateTime from, DateTime to) => _record!.getRecord(from, to);
  Map<FType, num> get allRecord => _record!.allRecord;

  bool completed(FType type, DateTime date) => _record!.completed(type, date);
  bool started(FType type, DateTime date) => _record!.started(type, date);

  List<DateTime> get logDates => _record!.logDates;
  DateTime get latestLogDate => _record!.latestLogDate;

  FUser(String key) : uid = key;

  FUser.builder(FUserBuilder builder)
    : uid = builder.uid,
    _battle = builder.battle,
    _collection = builder.collection,
    _friend = builder.friend,
    _info = builder.info,
    _notification = builder.notification,
    _party = builder.party,
    _record = builder.record!.._info = builder.info;

  FUser.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _battle = FUserBattle.fromJson(json);
    _collection = FUserCollection.fromJson(json);
    _friend = FUserFriend.fromJson(json);
    _info = FUserInfo.fromJson(json);
    _notification = FUserNotification.fromJson(json);
    _party = FUserParty.fromJson(json);
    _record = FUserRecord.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json.addAll(_battle?.toJson() ?? {});
    json.addAll(_collection?.toJson() ?? {});
    json.addAll(_friend?.toJson() ?? {});
    json.addAll(_info?.toJson() ?? {});
    json.addAll(_notification?.toJson() ?? {});
    json.addAll(_party?.toJson() ?? {});
    json.addAll(_record?.toJson() ?? {});
    return json;
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