import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:get/get.dart';


class RankingP extends GetxController{
  static void toRanking(ActivityType type) {
    Get.toNamed('/home/ranking', arguments: type);
  }
  static Future init() async {
    final rankingP = Get.find<RankingP>();
    final loadingP = Get.find<LoadingP>();

    if (loadingP.loading) return;
    loadingP.loadStart();
    await rankingP.loadAll();
    loadingP.loadEnd();
  }

  Future loadAll() async {
    await loadRanking();
  }

  final startDate = firstDayOfWeek(today);
  final endDate = nextDay(today);

  Map<ActivityType, List<FUserInfo>> infos = {};
  Map<ActivityType, List<FUserRecord>> records = {};

  Future loadRanking() async {
    final userInfoP = Get.find<UserInfoP>();
    final userRecordP = Get.find<UserRecordP>();
    final userFriendP = Get.find<UserFriendP>();

    for (ActivityType type in ActivityType.activeValues) {
      infos[type] = userFriendP.loggedUser.rivalInfos;
      records[type] = userFriendP.loggedUser.rivalRecords;

      infos[type]!.add(userInfoP.loggedUser);
      records[type]!.add(userRecordP.loggedUser);

      records[type]!.sort((a, b) => (
          b.getAmounts(type, startDate, endDate)
              - a.getAmounts(type, startDate, endDate)
      ).round());

      infos[type]!.sort((a, b) {
        int priceA = records[type]!.indexWhere((record) => record.uid == a.uid);
        int priceB = records[type]!.indexWhere((record) => record.uid == b.uid);
        return (records[type]![priceB].getAmounts(type, startDate, endDate)
            - records[type]![priceA].getAmounts(type, startDate, endDate)).round();
      });
    }

    update();
  }
}