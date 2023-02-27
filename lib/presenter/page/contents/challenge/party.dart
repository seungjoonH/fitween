import 'dart:async';
import 'dart:math';

import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/json/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/presenter/model/party.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// class
class PartyP extends GetxController {
  /// static variables
  static final refreshCont = RefreshController();
  static const int millisecond = 500;

  /// static methods
  // 챌린지 파티 메인 페이지로 이동
  static void toParty(Party party) async {
    Get.toNamed('contents/party/');
    await PartyP.init(party.id!);
  }

  /// attributes
  double value = 0;
  double maxValue = 0;
  Timer? timer;
  Party? loadedParty;
  bool copied = false;

  // 초기화
  static Future init(String id) async {
    final loadingP = Get.find<LoadingP>();
    final partyP = Get.find<PartyP>();

    loadingP.loadStart();
    await partyP.loadAll(id);
    loadingP.loadEnd();
  }

  Future loadAll(String id) async {
    final userInfoP = Get.find<UserInfoP>();
    final userPartyP = Get.find<UserPartyP>();
    final userRecordP = Get.find<UserRecordP>();

    FUserInfo userInfo = userInfoP.loggedUser;
    FUserRecord userRecord = userRecordP.loggedUser;

    loadedParty = await PartyJsonP.loadParty(id);
    if (loadedParty == null) return;
    await PartyJsonP.loadMembers(loadedParty!);
    await userPartyP.loadMyParties();

    value = .0;
    update();
    maxValue = userRecord.getAmounts(
      loadedParty!.challenge!.type!,
      loadedParty!.startDate,
      oneSecondBefore(tomorrow),
    ).toDouble();
    loadedParty!.records[userInfo.uid!] = maxValue.toInt();
    animateValue();

    PartyJsonP.save(loadedParty!);
    update();
  }

  // 로그인된 사용자의 파티 기록값 위젯을 애니메이트
  void animateValue() {
    const int intervalMilli = 10;
    double interval = maxValue / (millisecond / intervalMilli);

    timer =
        Timer.periodic(const Duration(milliseconds: intervalMilli), (timer) {
      value = min(value + interval, maxValue);
      if (value >= maxValue) timer.cancel();
      update();
    });
    update();
  }

  // 파티 코드를 복사
  void copyPartyId(String code) async {
    Clipboard.setData(ClipboardData(text: code));
    copied = true;
    update();
    await Future.delayed(const Duration(milliseconds: 1000), () {
      copied = false;
      update();
    });
  }

  void complete() {
    final userP = Get.find<UserCollectionP>();
    loadedParty!.complete = true;
    update();
    Get.back();
    PartyJsonP.save(loadedParty!);
    userP.awardBadge(loadedParty!.badge);
  }
}
