import 'dart:async';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class RankingCont extends GetxController {
  static RankingCont get to => Get.find<RankingCont>();

  final _friendsWithMe = <String, FUser>{}.obs;
  final _recordAmountsOfFriendsWithMe = <String, Map<Period, FriendRecord>>{}.obs;

  FUser getUser(String uid) => _friendsWithMe[uid]!;

  FUser get _logged => AuthCont.logged!;
  bool get hasFriend => _logged.friends.isNotEmpty;

  final _period = Period.daily.obs;
  Period get period => _period.value;

  Future init() async {
    await loadFriendData();
    _startLeftTimer();
  }

  Future loadFriendData() async {
    FUserLoadCont cont = FUserLoadCont.onlyRecord();
    await _logged.friend!.loadFriends(cont: cont);
    _friendsWithMe.clear();
    _recordAmountsOfFriendsWithMe.clear();
    _friendsWithMe[_logged.uid] = _logged;
    _friendsWithMe.addAll(_logged.friends);

    for (String uid in _friendsWithMe.keys) {
      FUser user = _friendsWithMe[uid]!;
      _recordAmountsOfFriendsWithMe[uid] = {};

      for (Period p in Period.values) {
        late Map<FType, num> amounts;

        switch (p) {
          case Period.daily:
            amounts = user.getOneDayRecord(today); break;
          case Period.weekly:
            amounts = user.getOneWeekRecord(today.firstDayOfWeek); break;
          case Period.monthly:
            amounts = user.getOneMonthRecord(today.firstDayOfMonth); break;
        }

        _recordAmountsOfFriendsWithMe[uid]![p] = FriendRecord(uid,
          distance: amounts[FType.distance]!,
          height: amounts[FType.height]!,
          weight: amounts[FType.weight]!,
        );
      }
    }
  }

  void changePeriod(Period p) => _period(p);

  double getPercentOf(FType type, String uid) {
    num maxAmount = getAmounts(type).first;
    num amount = getAmountOf(type, uid);
    return maxAmount == 0 ? .0 : amount / maxAmount;
  }

  num getAmountOf(FType type, String uid) {
    return _recordAmountsOfFriendsWithMe[uid]![period]!.byType(type);
  }

  List<num> getAmounts(FType type) {
    List<num> amounts = [];
    for (String uid in _friendsWithMe.keys) {
      amounts.add(getAmountOf(type, uid));
    }
    return amounts..sort((a, b) => b.compareTo(a));
  }

  List<String> getRanks(FType type) {
    num getNum(String uid) => _recordAmountsOfFriendsWithMe[uid]![period]!.byType(type);
    int compare(String a, String b) => getNum(b).compareTo(getNum(a));
    List<String> uids = [..._recordAmountsOfFriendsWithMe.keys];
    return uids..sort(compare);
  }

  List<String> getRanksFocusedOnMe(FType type, int count) {
    List<String> ranks = [...getRanks(type)];

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

  Map<Period, DateTime> get _endTimes => {
    Period.daily: today.lastTimeOfDay,
    Period.weekly: today.lastDayOfWeek.lastTimeOfDay,
    Period.monthly: today.lastDayOfMonth.lastTimeOfDay,
  };

  final _leftTimes = <Period, Duration>{
    Period.daily: Duration.zero,
    Period.weekly: Duration.zero,
    Period.monthly: Duration.zero,
  }.obs;

  Timer? _leftTimer;
  Duration get leftTime => _leftTimes[period]!;

  void _startLeftTimer() {
    _leftTimer = Timer.periodic(500.ms, (_) {
      for (Period p in Period.values) {
        _leftTimes[p] = _endTimes[p]!.difference(now);
      }
    });
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