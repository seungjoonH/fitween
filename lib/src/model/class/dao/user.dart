import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';

class FUserDAO {
  static final FUserDAO _instance = FUserDAO._();
  FUserDAO._();

  factory FUserDAO() => _instance;

  final FUserBattleDAO _battleDAO = FUserBattleDAO();
  final FUserCollectionDAO _collectionDAO = FUserCollectionDAO();
  final FUserFriendDAO _friendDAO = FUserFriendDAO();
  final FUserInfoDAO _infoDAO = FUserInfoDAO();
  final FUserNotificationDAO _notificationDAO = FUserNotificationDAO();
  final FUserPartyDAO _partyDAO = FUserPartyDAO();
  final FUserPointDAO _pointDAO = FUserPointDAO();
  final FUserRecordDAO _recordDAO = FUserRecordDAO();

  Map<String, FUser> get users {
    Map<String, FUser> list = {};
    infos.forEach((uid, info) {
      FUserBuilder builder = FUserBuilder()
        ..uid = uid
        ..info = info
        ..battle = battles[uid]
        ..collection = collections[uid]
        ..friend = friends[uid]
        ..notification = notifications[uid]
        ..party = parties[uid]
        ..point = points[uid]
        ..record = records[uid];

      list[uid] = FUser.builder(builder);
    });
    return list;
  }
  Map<String, FUserBattle> get battles => _battleDAO.list;
  Map<String, FUserCollection> get collections => _collectionDAO.list;
  Map<String, FUserFriend> get friends => _friendDAO.list;
  Map<String, FUserInfo> get infos => _infoDAO.list;
  Map<String, FUserNotification> get notifications => _notificationDAO.list;
  Map<String, FUserParty> get parties => _partyDAO.list;
  Map<String, FUserPoint> get points => _pointDAO.list;
  Map<String, FUserRecord> get records => _recordDAO.list;

  Future loadAll() async {
    await _battleDAO.loadAll();
    await _collectionDAO.loadAll();
    await _friendDAO.loadAll();
    await _infoDAO.loadAll();
    await _notificationDAO.loadAll();
    await _partyDAO.loadAll();
    await _pointDAO.loadAll();
    await _recordDAO.loadAll();
  }

  Future<FUser?> loadOneAll(String uid) async {
    return await loadOne(uid, cont: FUserLoadCont.all());
  }

  Future<FUser?> loadOne(
    String uid, {FUserLoadCont? cont}
  ) async {
    cont ??= FUserLoadCont.lightest();

    FUserBattle? battle;
    FUserCollection? collection;
    FUserFriend? friend;
    FUserInfo? info;
    FUserNotification? notification;
    FUserParty? party;
    FUserPoint? point;
    FUserRecord? record;

    if (cont.battle) battle = await _battleDAO.loadOne(uid);
    if (cont.collection) collection = await _collectionDAO.loadOne(uid);
    if (cont.friend) friend = await _friendDAO.loadOne(uid);
    if (cont.info) info = await _infoDAO.loadOne(uid);
    if (cont.notification) notification = await _notificationDAO.loadOne(uid);
    if (cont.party) party = await _partyDAO.loadOne(uid);
    if (cont.point) point = await _pointDAO.loadOne(uid);
    if (cont.record) record = await _recordDAO.loadOne(uid);

    if (cont.battle && battle == null) return null;
    if (cont.collection && collection == null) return null;
    if (cont.friend && friend == null) return null;
    if (cont.info && info == null) return null;
    if (cont.notification && notification == null) return null;
    if (cont.party && party == null) return null;
    if (cont.point && point == null) return null;
    if (cont.record && record == null) return null;

    FUserBuilder builder = FUserBuilder()
      ..uid = uid
      ..battle = battle
      ..collection = collection
      ..friend = friend
      ..info = info
      ..notification = notification
      ..party = party
      ..point = point
      ..record = record;

    return FUser.builder(builder);
  }

  Future saveOne(FUser user) async {
    String uid = user.key;
    await _battleDAO.saveOne(user.battle ?? FUserBattle(uid));
    await _collectionDAO.saveOne(user.collection ?? FUserCollection(uid));
    await _friendDAO.saveOne(user.friend ?? FUserFriend(uid));
    await _infoDAO.saveOne(user.info ?? FUserInfo(uid));
    await _notificationDAO.saveOne(user.notification ?? FUserNotification(uid));
    await _partyDAO.saveOne(user.party ?? FUserParty(uid));
    await _pointDAO.saveOne(user.point ?? FUserPoint(uid));
    await _recordDAO.saveOne(user.record ?? FUserRecord(uid));
  }
}