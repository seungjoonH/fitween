import 'package:fitween/global/date.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:get/get.dart';

class RankingCont extends GetxController {
  static RankingCont get to => Get.find<RankingCont>();

  final _rivalsWithMe = <String, FUser>{};
  final _recordAmountsOfRivalsWithMe = <String, RivalRecord>{};

  FUser getUser(String uid) => _rivalsWithMe[uid]!;

  FUser get _logged => AuthCont.logged!;

  Future init() async => await loadRivalData();

  Future loadRivalData() async {
    await _logged.friend!.loadFriends();
    _rivalsWithMe.clear();
    _rivalsWithMe[_logged.uid] = _logged;
    _rivalsWithMe.addAll(_logged.rivals);

    for (String uid in _rivalsWithMe.keys) {
      Map<FType, num> amounts = _rivalsWithMe[uid]!
          .getOneWeekRecord(today.firstDayOfWeek);
      _recordAmountsOfRivalsWithMe[uid] = RivalRecord(uid,
        distance: amounts[FType.distance]!,
        height: amounts[FType.height]!,
        weight: amounts[FType.weight]!,
      );
    }
  }

  double getPercentOf(FType type, String uid) {
    num maxAmount = getAmounts(type).first;
    num amount = getAmountOf(type, uid);
    return maxAmount == 0 ? .0 : amount / maxAmount;
  }

  num getAmountOf(FType type, String uid) {
    return _recordAmountsOfRivalsWithMe[uid]!.byType(type);
  }

  List<num> getAmounts(FType type) {
    List<num> amounts = [];
    for (String uid in _rivalsWithMe.keys) {
      amounts.add(getAmountOf(type, uid));
    }
    return amounts..sort();
  }

  List<String> getRanks(FType type) {
    num getNum(String uid) => _recordAmountsOfRivalsWithMe[uid]!.byType(type);
    int compare(String a, String b) => getNum(a).compareTo(getNum(b));
    List<String> uids = [..._recordAmountsOfRivalsWithMe.keys];
    return uids..sort(compare);
  }

  List<String> getRanksFocusedOnMe(FType type, int count) {
    List<String> ranks = [...getRanks(type)];
    List<String> newRanks = [];

    if (ranks.length < count) return ranks;

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

  // int rankOfMe(FType type) => rankOf(type, _logged.uid);
  // int rankOf(FType type, String uid) {
  //   List<num> amounts = _rivalRecordAmounts
  //       .values.map((r) => r.byType(type)).toList(growable: true);
  //   print(amounts);
  //   amounts = amounts.reversed.toList();
  //   return amounts.indexWhere((amount) {
  //     return amount == _rivalRecordAmounts[_logged.uid]!.byType(type);
  //   });
  // }

}

class RivalRecord {
  late String uid;
  late num calorie;
  late num distance;
  late num height;
  late num weight;

  RivalRecord(
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