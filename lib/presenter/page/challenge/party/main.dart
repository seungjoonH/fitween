import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/presenter/model/party.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// class
class ChallengePartyMain extends GetxController {
  /// static variables
  static final refreshCont = RefreshController();
  static const int millisecond = 500;

  /// static methods
  // 챌린지 파티 메인 페이지로 이동
  static void toChallengePartyMain(Party party) async {
    final challengePartyMain = Get.find<ChallengePartyMain>();

    Get.toNamed('challenge/party/main');
    await challengePartyMain.init(party.id!);
  }

  /// attributes
  double value = 0;
  double maxValue = 0;
  Timer? timer;
  Party? loadedParty;
  bool copied = false;

  // 초기화
  Future init(String id) async {
    final userP = Get.find<UserPresenter>();
    final loadingP = Get.find<LoadingPresenter>();
    PUser user = userP.loggedUser;

    loadingP.loadStart();
    loadedParty = await PartyPresenter.loadParty(id);
    if (loadedParty == null) return;
    await PartyPresenter.loadMembers(loadedParty!);
    await userP.loadMyParties();

    value = .0; update();
    maxValue = user.getAmounts(
      loadedParty!.challenge!.type!,
      loadedParty!.startDate,
      oneSecondBefore(tomorrow),
    ).toDouble();
    loadedParty!.records[user.uid!] = maxValue.toInt();
    animateValue();

    loadingP.loadEnd();

    PartyPresenter.save(loadedParty!);
    update();
  }

  // 로그인된 사용자의 파티 기록값 위젯을 애니메이트
  void animateValue() {
    const int intervalMilli = 10;
    double interval = maxValue / (millisecond / intervalMilli);

    timer = Timer.periodic(const Duration(milliseconds: intervalMilli), (timer) {
      value = min(value + interval, maxValue);
      if (value >= maxValue) timer.cancel();
      update();
    });
    update();
  }

  // 파티 코드를 복사
  void copyPartyId(String code) async {
    Clipboard.setData(ClipboardData(text: code));
    copied = true; update();
    await Future.delayed(const Duration(milliseconds: 1000), () {
      copied = false; update();
    });
  }

  void complete() {
    final userP = Get.find<UserPresenter>();
    loadedParty!.complete = true; update();
    Get.back();
    PartyPresenter.save(loadedParty!);
    userP.awardBadge(loadedParty!.badge);
  }
}