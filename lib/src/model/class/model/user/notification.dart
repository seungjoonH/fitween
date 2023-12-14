import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class NotificationData extends Model {
  late String _id;
  late Timestamp _date;
  late String _content;
  late bool _checked;
  late String _objectCode;

  FUser? _user;
  Party? _party;

  DateTime get date => _date.toDate();
  set date(DateTime d) => _date = d.toTimestamp!;

  @override
  String toString() => '$_id: {'
      '\n  date: $date,'
      '\n  content: $_content,'
      '\n  checked: $_checked'
      '\n  objectCode: $_objectCode'
      '\n}';

  bool get checked => _checked;

  String get objectType => _objectCode.split('-').first;
  String get objectKey => _objectCode.split('-').last;

  String get objectNotificationText {
    switch (objectType) {
      case 'user': return user!.nickname;
      case 'party': return party!.title;
    }
    return '';
  }

  String get _tr => 'notification';
  String get content => LangCont.tr(
    '$_tr.$_content',
    namedArgs: {'object': objectNotificationText},
  );

  FUser? get user => _user;
  Party? get party => _party;

  bool isEqualTo(String content, String key) {
    return content == _content && key == objectKey;
  }

  Future load() async { await loadUser(); await loadParty(); }

  Future loadUser() async {
    if (objectType != 'user') return;
    _user = await FUserDAO().loadOne(objectKey);
  }

  Future loadParty() async {
    if (objectType != 'party') return;
    _party = await PartyDAO().loadOne(objectKey);
  }

  Future route() async {
    switch (_content) {
      case 'followed':
        if (user == null) return;
        FRoute.toFriendSearch(keyword: user!.nickname);
        return;
      case 'party-applied':
        if (party == null) await loadParty();
        FRoute.toParty(party: party);
        return;
      case 'party-accepted':
        if (party == null) await loadParty();
        FRoute.toParty(party: party);
        return;
      case 'party-rejected':
        if (party == null) await loadParty();
        FRoute.toParty(party: party);
        return;
      case 'poke': return;
    }
  }

  void check() => _checked = true;

  NotificationData.followed({
    required DateTime date,
    required FUser user,
  }) {
    _id = NotificationCont.to.nextKey;
    this.date = date;
    _content = 'followed';
    _objectCode = 'user-${user.key}';
    _checked = false;
  }

  NotificationData.poke({
    required DateTime date,
    required FUser user,
  }) {
    _id = NotificationCont.to.nextKey;
    this.date = date;
    _content = 'poke';
    _objectCode = 'user-${user.key}';
    _checked = false;
  }


  NotificationData.partyApplied({
    required DateTime date,
    required Party party,
  }) {
    _id = NotificationCont.to.nextKey;
    this.date = date;
    _content = 'party-applied';
    _objectCode = 'party-${party.key}';
    _checked = false;
  }

  NotificationData.partyAccepted({
    required DateTime date,
    required Party party,
  }) {
    _id = NotificationCont.to.nextKey;
    this.date = date;
    _content = 'party-accepted';
    _objectCode = 'party-${party.key}';
    _checked = false;
  }

  NotificationData.partyRejected({
    required DateTime date,
    required Party party,
  }) {
    _id = NotificationCont.to.nextKey;
    this.date = date;
    _content = 'party-rejected';
    _objectCode = 'party-${party.key}';
    _checked = false;
  }

  NotificationData.partyBanished({
    required DateTime date,
    required Party party,
  }) {
    _id = NotificationCont.to.nextKey;
    this.date = date;
    _content = 'party-banished';
    _objectCode = 'party-${party.key}';
    _checked = false;
  }

  NotificationData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _date = json['date'];
    _content = json['content'];
    _checked = json['checked'];
    _objectCode = json['object'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = _id;
    json['date'] = _date;
    json['content'] = _content;
    json['checked'] = _checked;
    json['object'] = _objectCode;
    return json;
  }

  @override
  String get key => _id;

}

class FUserNotification extends FUser {
  @override
  FUserNotification? get notification => this;

  List<NotificationData> _data = [];

  List<NotificationData> get data => _data;

  void syncNotificationsFrom(List<NotificationData> list) {
    _data.assignAll([...list]);
  }

  Future loadAll() async {
    for (NotificationData notification in data) { await notification.load(); }
  }

  bool _alreadyFollowed(FUser user) {
    return _data.firstWhereOrNull((d) => d.isEqualTo('followed', user.uid)) != null;
  }

  void follow(FUser user) {
    if (_alreadyFollowed(user)) return;
    _data.add(NotificationData.followed(date: now, user: user));
  }

  void poke(FUser user) {
    _data.add(NotificationData.poke(date: now, user: user));
  }

  void applyParty(Party party) {
    _data.add(NotificationData.partyApplied(date: now, party: party));
  }

  void acceptApplicant(Party party) {
    _data.add(NotificationData.partyAccepted(date: now, party: party));
  }

  void rejectApplicant(Party party) {
    _data.add(NotificationData.partyRejected(date: now, party: party));
  }

  void banishMember(Party party) {
    _data.add(NotificationData.partyBanished(date: now, party: party));
  }

  FUserNotification(super.key) : super();
  FUserNotification.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    _data = json['data']
        ?.map<NotificationData>((e) => NotificationData.fromJson(e)).toList()
        ?? <NotificationData>[];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['data'] = _data.map((e) => e.toJson());
    return json;
  }
}