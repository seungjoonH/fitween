import 'dart:async';

import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/point.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class RankingCont extends GetxController {
  static RankingCont get to => Get.find<RankingCont>();

  static HomePageCont get homePageCont => HomePageCont.to;
  static RankingPageCont get rankingPageCont => RankingPageCont.to;

  List<RankingData> getRankings(Period period) {
    int compare(RankingData a, RankingData b) => a.date.compareTo(b.date);
    return _logged.rankings[period]!..sort(compare);
  }

  final _friendsWithMe = <String, FUser>{}.obs;
  final _recordAmountsOfFriendsWithMe = <Period, Map<DateTime, Map<String, FriendRecord>>>{}.obs;

  int get friendsCount => _friendsWithMe.length;

  FUser getUser(String uid) => _friendsWithMe[uid]!;

  FUser get _logged => AuthCont.logged!;
  bool get hasFriend => _logged.friends.isNotEmpty;

  final _period = Period.daily.obs;
  Period get period => _period.value;

  Future init() async {
    await loadFriendData();
    _startLeftTimer(today);
    _calculateFPoints();
  }

  bool isAvailableFriend(String uid, DateTime date) {
    if (_logged.key == uid) return true;
    return !_logged.followedDate(uid).ignoreTime.isAfter(getStartTime(date));
  }

  void _loadFriendDataByDate(Period p, DateTime date) {
    if (_recordAmountsOfFriendsWithMe[p] == null) return;
    _recordAmountsOfFriendsWithMe[p]![date] = {};

    for (String uid in _friendsWithMe.keys) {
      if (!isAvailableFriend(uid, date)) continue;

      FUser user = _friendsWithMe[uid]!;
      late Map<FType, num> amounts;

      switch (p) {
        case Period.daily:
          amounts = user.getOneDayRecord(date); break;
        case Period.weekly:
          amounts = user.getOneWeekRecord(date); break;
        case Period.monthly:
          amounts = user.getOneMonthRecord(date); break;
      }

      _recordAmountsOfFriendsWithMe[p]![date]![uid] = FriendRecord(uid,
        distance: amounts[FType.distance]!,
        height: amounts[FType.height]!,
        weight: amounts[FType.weight]!,
      );
    }
  }

  Future loadFriendData() async {
    FUserLoadCont cont = FUserLoadCont.onlyRecord();
    await _logged.friend!.loadFriends(cont: cont);
    _friendsWithMe.clear();
    _recordAmountsOfFriendsWithMe.clear();
    _friendsWithMe[_logged.uid] = _logged;
    _friendsWithMe.addAll(_logged.friends);

    for (Period p in Period.values) {
      _recordAmountsOfFriendsWithMe[p] = {};

      for (RankingData data in getRankings(p)) {
        _recordAmountsOfFriendsWithMe[p]![data.date] = {};
        _loadFriendDataByDate(p, data.date);
      }

      DateTime beforeDate = p.getBeforeDate(today, 1);
      DateTime currentDate = p.getCurrentDate(today);

      _loadFriendDataByDate(p, beforeDate);
      _loadFriendDataByDate(p, currentDate);
    }
    _saveRankingsData();
  }

  void _saveRankingsDataByDate(Period p, DateTime date) {
    RankingData? data = getRankings(p)
        .firstWhereOrNull((ranking) => ranking.date.isAtSameMomentAs(date));

    data ??= RankingData(
      date: date,
      finished: !date.isAtSameMomentAs(today),
    );
    int myRank = -1;

    for (FType type in FType.activeValues) {
      for (String uid in _recordAmountsOfFriendsWithMe[p]![date]!.keys) {
        num amount = getAmountOf(type, uid, date);
        int rank = getRankOf(type, uid, date);
        if (uid == _logged.key) myRank = rank;
        RankingPersonalData personalData = RankingPersonalData(amount, rank);
        data.setDataByType(type, uid, personalData);
      }

      FPointCalculator calculator = FPointCalculator(
        goal: _logged.goal.byType(type),
        does: getAmountOf(type, _logged.key, date),
        type: type,
      );

      data.setPoint(calculator.getPeriodlyRankedFPoint(period, myRank));
    }

    _logged.setRankedData(p, data);
  }

  void _saveRankingsData() {
    for (Period p in Period.values) {
      _saveRankingsDataByDate(p, p.getBeforeDate(today, 1));
      _saveRankingsDataByDate(p, p.getCurrentDate(today));
    }
    FUserRecordDAO().saveOne(_logged.record!);
  }

  void changePeriod(Period p) {
    _period(p);
    rankingPageCont.gotoLastPage();
    _calculateFPoints();
  }

  String getAmountTextOf(FType type, String uid, DateTime date, {bool scaling = true}) {
    num amount = getAmountOf(type, uid, date);
    return type.withUnit(amount, scaling: scaling);
  }
  
  double getPercentOf(FType type, String uid, DateTime date) {
    num maxAmount = getAmounts(type, date).first;
    num amount = getAmountOf(type, uid, date);
    return maxAmount == 0 ? .0 : amount / maxAmount;
  }

  num getAmountOf(FType type, String uid, DateTime date) {
    if (_recordAmountsOfFriendsWithMe.isEmpty) return .0;
    if (_recordAmountsOfFriendsWithMe[period]![date] == null) return .0;
    return _recordAmountsOfFriendsWithMe[period]![date]![uid]!.byType(type);
  }

  List<num> getAmounts(FType type, DateTime date) {
    List<num> amounts = [];
    for (String uid in _friendsWithMe.keys) {
      if (!isAvailableFriend(uid, date)) continue;
      amounts.add(getAmountOf(type, uid, date));
    }
    return amounts..sort((a, b) => b.compareTo(a));
  }

  int getRankOf(FType type, String uid, DateTime date) {
    return getRanks(type, date).indexWhere((u) => u == uid);
  }

  List<String> getRanks(FType type, DateTime date) {
    if (_recordAmountsOfFriendsWithMe.isEmpty) return [];
    if (_recordAmountsOfFriendsWithMe[period]![date] == null) return [];
    num getNum(String uid) => _recordAmountsOfFriendsWithMe[period]![date]![uid]!.byType(type);
    int compare(String a, String b) => getNum(b).compareTo(getNum(a));
    List<String> uids = [..._recordAmountsOfFriendsWithMe[period]![date]!.keys];
    return uids..sort(compare);
  }

  List<String> getRanksFocusedOnMe(FType type, int count) {
    List<String> ranks = [...getRanks(type, getStartTime(today))];

    if (ranks.length < count) return ranks;

    List<String> newRanks = [];
    int myIndex = ranks.indexWhere((uid) => uid == _logged.uid);

    newRanks.add(_logged.uid);

    bool isTopRank = false;
    bool isBottomRank = false;

    for (int i = 0; i < count ~/ 2; i++) {
      isBottomRank = myIndex + 1 + i >= ranks.length;
      if (isBottomRank) break;
      newRanks.add(ranks[myIndex + 1 + i]);
    }

    if (count == newRanks.length) return newRanks;

    for (int i = 0; i < count ~/ 2; i++) {
      isTopRank = myIndex - 1 - i < 0;
      if (isTopRank) break;
      newRanks.insert(0, ranks[myIndex - 1 - i]);
    }

    if (count == newRanks.length) return newRanks;

    int remain = count - newRanks.length;

    if (isTopRank) {
      int i = ranks.indexWhere((uid) => uid == newRanks.last);
      newRanks.addAll(ranks.sublist(i + 1, i + 1 + remain));
    }

    if (isBottomRank) {
      int i = ranks.indexWhere((uid) => uid == newRanks.first);
      newRanks.insertAll(0, ranks.sublist(i - 1 - remain, i - 2));
    }

    return newRanks;
  }

  Map<Period, DateTime> _getStartTimes(DateTime date) {
    return {
      Period.daily: date,
      Period.weekly: date.firstDayOfWeek,
      Period.monthly: date.firstDayOfMonth,
    };
  }

  DateTime getStartTime(DateTime date) => _getStartTimes(date)[period]!;

  Map<Period, DateTime> _getEndTimes(DateTime date) {
    return {
      Period.daily: date.lastTimeOfDay,
      Period.weekly: date.lastDayOfWeek.lastTimeOfDay,
      Period.monthly: date.lastDayOfMonth.lastTimeOfDay,
    };
  }
  final _leftTimes = <Period, Duration>{
    Period.daily: Duration.zero,
    Period.weekly: Duration.zero,
    Period.monthly: Duration.zero,
  }.obs;

  Timer? _leftTimer;
  Duration getLeftTime(DateTime date) {
    return date.isAtSameMomentAs(_getStartTimes(today)[period]!)
        ? _leftTimes[period]! : Duration.zero;
  }
  Duration _getEntireDuration(DateTime date) {
    return _getEndTimes(date)[period]!.difference(_getStartTimes(date)[period]!);
  }
  double getLeftPercent(DateTime date) {
    return 1 - getLeftTime(date).inMilliseconds / _getEntireDuration(date).inMilliseconds;
  }

  void _startLeftTimer(DateTime date) {
    _leftTimer = Timer.periodic(500.ms, (_) {
      for (Period p in Period.values) {
        _leftTimes[p] = _getEndTimes(date)[p]!.difference(now);
      }
    });
  }

  final _estimatedFPoint = 0.obs;
  int get estimatedFPoint => _estimatedFPoint.value;

  void _calculateFPoints() {
    String uid = _logged.key;
    int point = 0;

    for (FType type in FType.activeValues) {
      FPointCalculator calculator = FPointCalculator(
        goal: _logged.goal.byType(type),
        does: getAmountOf(type, uid, rankingPageCont.selectedDate),
        type: type,
      );

      point += calculator.getPeriodlyRankedFPoint(
        period, getRankOf(type, uid, rankingPageCont.selectedDate),
      );
    }

    _estimatedFPoint(point);
  }

  @override
  void dispose() {
    super.dispose();
    _leftTimer?.cancel();
  }
}

class FriendRecord {
  late String uid;
  late num calorie;
  late num distance;
  late num height;
  late num weight;

  FriendRecord(
    this.uid, {
    this.calorie = .0,
    this.distance = .0,
    this.height = .0,
    this.weight = .0,
  });

  num byType(FType type) {
    switch (type) {
      case FType.calorie: return calorie;
      case FType.distance: return distance;
      case FType.height: return height;
      case FType.weight: return weight;
    }
  }
}