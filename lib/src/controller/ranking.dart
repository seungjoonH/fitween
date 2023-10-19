import 'dart:async';

import 'package:fitween/global/global.dart';
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

  RankingData? get selectedRanking {
    List<RankingData> data = getRankings(period);
    return data.firstWhereOrNull((d) => d.date
        .isAtSameMomentAs(rankingPageCont.selectedDate));
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
    await _saveRankingsData();
    rankingPageCont.setSelectedDateToLatest();
    calculateFPoints();
  }

  bool isAvailableFriend(String uid, DateTime date) {
    if (_logged.key == uid) return true;
    return !_logged.followedDate(uid).ignoreTime.isAfter(getStartTime(date));
  }

  void _loadFriendDataByDate(Period p, DateTime date) {
    if (_recordAmountsOfFriendsWithMe[p] == null) return;
    _recordAmountsOfFriendsWithMe[p]![date] = {};

    for (String uid in _friendsWithMe.keys) {
      bool finished = !date.isAtSameMomentAs(_getStartTimes(today)[p]!);
      if (finished && !isAvailableFriend(uid, date)) continue;

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

      _recordAmountsOfFriendsWithMe[p]![beforeDate] = {};
      _recordAmountsOfFriendsWithMe[p]![currentDate] = {};
      _loadFriendDataByDate(p, beforeDate);
      _loadFriendDataByDate(p, currentDate);
    }
    // await _saveRankingsData();
  }

  int _getEntireCount(FType type, Period p, DateTime date) {
    int count = 1;
    for (String uid in _recordAmountsOfFriendsWithMe[p]![date]!.keys) {
      num amount = getAmountOf(p, type, uid, date);
      if (amount > 0 && _logged.key != uid) count++;
    }
    return count;
  }

  void _saveRankingsDataByDate(Period p, DateTime date) {
    RankingData? data = getRankings(p)
        .firstWhereOrNull((ranking) => ranking.date.isAtSameMomentAs(date));

    data ??= RankingData(date: date);

    if (!data.date.isAtSameMomentAs(_getStartTimes(today)[p]!)) {
      data.finish();
    }

    int myRank = -1;

    for (FType type in FType.activeValues) {
      for (String uid in _recordAmountsOfFriendsWithMe[p]![date]!.keys) {
        num amount = getAmountOf(p, type, uid, date);
        int rank = getRankOf(p, type, uid, date);
        if (uid == _logged.key) myRank = rank;
        RankingPersonalData personalData = RankingPersonalData(amount, rank);
        data.setDataByType(type, uid, personalData);
      }

      FPointCalculator calculator = FPointCalculator(
        goal: _logged.goal.byType(type),
        does: getAmountOf(p, type, _logged.key, date),
        type: type,
        period: period,
      );

      int point = calculator.getRankedFPoint(
        myRank, _getEntireCount(type, p, date),
      );

      data.setPoint(point);
      // if (point == 0) data.receive(type);
    }

    _logged.setRankedData(p, data);
  }

  Future _saveRankingsData() async {
    for (Period p in Period.values) {
      List<RankingData> dataList = getRankings(p);
      _saveRankingsDataByDate(p, p.getBeforeDate(today, 1));
      _saveRankingsDataByDate(p, p.getCurrentDate(today));

      for (RankingData data in dataList) {
        _saveRankingsDataByDate(p, data.date);
      }
    }
    await FUserRecordDAO().saveOne(_logged.record!);
  }

  void changePeriod(Period p) {
    _period(p);
    rankingPageCont.gotoLastPage();
    calculateFPoints();
  }

  String getAmountTextOf(FType type, String uid, DateTime date, {bool scaling = true}) {
    num amount = getAmountOf(period, type, uid, date);
    return type.withUnit(amount, scaling: scaling);
  }
  
  double getPercentOf(FType type, String uid, DateTime date) {
    num maxAmount = getAmounts(type, date).first;
    num amount = getAmountOf(period, type, uid, date);
    return maxAmount == 0 ? .0 : amount / maxAmount;
  }

  num getAmountOf(Period p, FType type, String uid, DateTime date) {
    if (_recordAmountsOfFriendsWithMe.isEmpty) return .0;
    if (_recordAmountsOfFriendsWithMe[p]![date] == null) return .0;
    return _recordAmountsOfFriendsWithMe[p]![date]![uid]?.byType(type) ?? .0;
  }

  List<num> getAmounts(FType type, DateTime date) {
    List<num> amounts = [];
    for (String uid in _friendsWithMe.keys) {
      if (!isAvailableFriend(uid, date)) continue;
      amounts.add(getAmountOf(period, type, uid, date));
    }
    return amounts..sort((a, b) => b.compareTo(a));
  }

  int getRankOf(Period p, FType type, String uid, DateTime date) {
    return getRanks(p, type, date).indexWhere((u) => u == uid);
  }

  List<String> getRanks(Period p, FType type, DateTime date) {
    if (_recordAmountsOfFriendsWithMe.isEmpty) return [];
    if (_recordAmountsOfFriendsWithMe[p]![date] == null) return [];
    num getNum(String uid) => _recordAmountsOfFriendsWithMe[p]![date]![uid]!.byType(type);
    int compare(String a, String b) => getNum(b).compareTo(getNum(a));
    List<String> uids = [..._recordAmountsOfFriendsWithMe[p]![date]!.keys];
    uids.removeWhere((uid) => !_logged.friend!.isFollowingOrMe(uid));
    return uids..sort(compare);
  }

  List<String> getRanksFocusedOnMe(FType type, int count) {
    List<String> ranks = [...getRanks(period, type, getStartTime(today))];

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
        DateTime endTime = _getEndTimes(today)[p]!;
        _leftTimes[p] = endTime.difference(now);
      }
    });
  }

  final _received = false.obs;
  final _finished = false.obs;

  bool get received => _received.value;
  bool get finished => _finished.value;

  void updateReceived() => _received(selectedRanking
      ?.getReceived(homePageCont.activeType) ?? false);
  void updateFinished() => _finished(selectedRanking
      ?.finished ?? false);

  final _estimatedFPoint = 0.obs;
  int get estimatedFPoint => _estimatedFPoint.value;
  late FPointCalculator calculator;

  void calculateFPoints() {
    String uid = _logged.key;
    int point = 0;

    FType type = homePageCont.activeType;
    DateTime date = rankingPageCont.selectedDate;

    calculator = FPointCalculator(
      goal: _logged.goal.byType(type),
      does: getAmountOf(period, type, uid, date),
      type: type,
      period: period,
    );

    point = calculator.getRankedFPoint(
      getRankOf(period, type, uid, date),
      _getEntireCount(type, period, date),
    );

    _estimatedFPoint(point);
    updateReceived();
    updateFinished();
  }

  void receivePoint() async {
    FType type = homePageCont.activeType;
    DateTime date = rankingPageCont.selectedDate;
    selectedRanking!.receive(type);
    _logged.record!.receivePoint(period, date, type);
    updateReceived();
    updateFinished();

    await FUserRecordDAO().saveOne(_logged.record!);
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