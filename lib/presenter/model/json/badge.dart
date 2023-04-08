/* 뱃지 프리젠터 */

import 'dart:convert';

import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/party.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/json/badge.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/model/json/party.dart';

/// class
// 뱃지 [badges.json] 파일 관련
class BadgeJsonP extends GetxController {
  /// static variables
  static String asset = 'assets/json/data/badges.json';
  static List<FBadge> badges = [];

  /// static methods
  // json 파일 불러오기
  static Future importFile() async {
    String string = await rootBundle.loadString(asset);
    List<dynamic> list = jsonDecode(string);
    badges = list.map((json) => FBadge.fromJson(json)).toList();
  }

  static List<FBadge> get availableBadges {
    List<FBadge> badgeList = [...badges];
    badgeList.removeWhere((badge) => !badge.activate!);
    return badgeList;
  }

  static List<FBadge> get notAcquiredBadges {
    FUserCollection user = Get.find<UserCollectionP>().loggedUser;
    List<FBadge> badgeList = [...availableBadges];
    badgeList.removeWhere((badge) => user.hasCollection(badge.id!));
    return badgeList;
  }

  // 뱃지 아이디에 해당하는 뱃지 반환
  static FBadge? getBadge(String? id) => badges
      .firstWhereOrNull((badge) => badge.id == id);

  static FBadge? getThisMonthQuestBadge(ActivityType type) {
    if (!type.active) return null;
    return getBadge('1040${type.index}${
      (today.month - 1).toString().padLeft(2, '0')}'
    );
  }

  // 일일 활동 완료 뱃지 획득
  static void awardDailyActivityCompleteBadge() async {
    final userP = Get.find<UserCollectionP>();
    userP.awardBadge(BadgeJsonP.getBadge('1000001')!, true, true);
  }

  static Future synchronizeBadges() async {
    final inAppReview = InAppReview.instance;

    final userCollectionP = Get.find<UserCollectionP>();
    final userInfoP = Get.find<UserInfoP>();
    final userPartyP = Get.find<UserPartyP>();

    FUserCollection userCollection = userCollectionP.loggedUser;
    FUserInfo userInfo = userInfoP.loggedUser;
    FUserParty userParty = userPartyP.loggedUser;

    // 운영자 뱃지 지급
    if (AuthP.developerUids.contains(userInfo.uid)) {
      userCollectionP.awardBadge(BadgeJsonP.getBadge('1999999')!, true);
    }

    // 작심삼일, 완벽한주 뱃지 지급
    int consecutive3 = userCollection.countCompletedDaysInARow(3);
    int consecutive7 = userCollection.countCompletedDaysInARow(7);
    int count3 = userCollection.getCollectionsById('1000002')?.dates.length ?? 0;
    int count7 = userCollection.getCollectionsById('1000003')?.dates.length ?? 0;

    for (int i = 0; i < consecutive3 - count3; i++) {
      userCollectionP.awardBadge(BadgeJsonP.getBadge('1000002')!);
    }
    for (int i = 0; i < consecutive7 - count7; i++) {
      userCollectionP.awardBadge(BadgeJsonP.getBadge('1000003')!);
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    }

    for (String id in userParty.partyIds) {
      Party? party = await PartyJsonP.loadParty(id);
      if (party == null) break;
      if (!party.complete) continue;
      userCollectionP.awardBadge(party.badge, true);
    }
  }
}