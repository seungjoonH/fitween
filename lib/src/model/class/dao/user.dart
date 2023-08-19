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
  Map<String, FUserRecord> get records => _recordDAO.list;

  Future loadAll({bool lightMode = true}) async {
    await _battleDAO.loadAll(lightMode: lightMode);
    await _collectionDAO.loadAll(lightMode: lightMode);
    await _friendDAO.loadAll(lightMode: lightMode);
    await _infoDAO.loadAll(lightMode: lightMode);
    await _notificationDAO.loadAll(lightMode: lightMode);
    await _partyDAO.loadAll(lightMode: lightMode);
    await _recordDAO.loadAll(lightMode: lightMode);
  }

  Future<FUser?> loadOneAll(String uid) async {
    return await loadOne(
      uid,
      loadBattle: true,
      loadCollection: true,
      loadFriend: true,
      loadInfo: true,
      loadNotification: true,
      loadParty: true,
      loadRecord: true,
    );
  }

  Future<FUser?> loadOne(
    String uid, {
      bool loadBattle = false,
      bool loadCollection = false,
      bool loadFriend = false,
      bool loadInfo = true,
      bool loadNotification = false,
      bool loadParty = false,
      bool loadRecord = false,
    }) async {
    FUserBattle? battle;
    FUserCollection? collection;
    FUserFriend? friend;
    FUserInfo? info;
    FUserNotification? notification;
    FUserParty? party;
    FUserRecord? record;

    if (loadBattle) battle = await _battleDAO.loadOne(uid);
    if (loadCollection) collection = await _collectionDAO.loadOne(uid);
    if (loadFriend) friend = await _friendDAO.loadOne(uid);
    if (loadInfo) info = await _infoDAO.loadOne(uid);
    if (loadNotification) notification = await _notificationDAO.loadOne(uid);
    if (loadParty) party = await _partyDAO.loadOne(uid);
    if (loadRecord) record = await _recordDAO.loadOne(uid);

    if (loadBattle && battle == null) return null;
    if (loadCollection && collection == null) return null;
    if (loadFriend && friend == null) return null;
    if (loadInfo && info == null) return null;
    if (loadNotification && notification == null) return null;
    if (loadParty && party == null) return null;
    if (loadRecord && record == null) return null;

    FUserBuilder builder = FUserBuilder()
      ..uid = uid
      ..battle = battle
      ..collection = collection
      ..friend = friend
      ..info = info
      ..notification = notification
      ..party = party
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
    await _recordDAO.saveOne(user.record ?? FUserRecord(uid));
  }
}