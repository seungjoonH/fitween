import 'package:fitween/global/date.dart';
import 'package:fitween/global/string.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/json/badge.dart';
import 'package:fitween/model/enum/dialog.dart';
import 'package:fitween/presenter/model/json/badge.dart';
import 'package:fitween/presenter/model/json/challenge.dart';
import 'package:fitween/presenter/model/json/level.dart';
import 'package:fitween/presenter/model/json/quest.dart';
import 'package:fitween/presenter/model/party.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:fitween/presenter/model/json/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/notification.dart';
import 'package:fitween/presenter/page/home/calendar.dart';
import 'package:fitween/presenter/page/contents/challenge/challenge_detail.dart';
import 'package:fitween/presenter/page/contents/challenge/party.dart';
import 'package:fitween/presenter/page/contents/contents.dart';
import 'package:fitween/presenter/page/contents/time_attack/camera.dart';
import 'package:fitween/presenter/page/contents/time_attack/friend.dart';
import 'package:fitween/presenter/page/contents/time_attack/ready.dart';
import 'package:fitween/presenter/page/exercise/setting/detail.dart';
import 'package:fitween/presenter/page/friend.dart';
import 'package:fitween/presenter/page/home/home.dart';
import 'package:fitween/presenter/page/onboarding.dart';
import 'package:fitween/presenter/page/home/ranking.dart';
import 'package:fitween/presenter/page/register.dart';
import 'package:fitween/presenter/page/see_more/collection/collection.dart';
import 'package:fitween/presenter/page/see_more/info_edit/info_edit.dart';
import 'package:fitween/presenter/page/see_more/see_more.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/presenter/widget/painter.dart';
import 'package:fitween/view/widget/effect/effect.dart';
import 'package:fitween/view/widget/function/dialog.dart';
import 'package:fitween/view/widget/widget/badge.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GlobalP extends GetxController {
  static const String effectAsset =
      'assets/image/widget/dialog/badge_effect.png';
  static const String effect2Asset =
      'assets/image/widget/dialog/badge_effect2.png';

  int navIndex = 0;

  static void init() {
    final globalP = Get.find<GlobalP>();
    globalP.navIndex = 0;
    globalP.update();
  }

  void navigate(int index) async {
    switch (index) {
      case 0:
        if (navIndex == index) { await HomeP.init(); }
        else { HomeP.toHome(); }
        break;
      case 1:
        if (navIndex == index) { await FriendP.init(); }
        else { FriendP.toFriend(); }
        break;
      case 2:
        if (navIndex == index) { await ContentsP.init(); }
        else { ContentsP.toContents(); }
        break;
      // case 3: AuthPresenter.fLogout(); break;
      case 3:
        if (navIndex == index) { SeeMoreP.init(); }
        else { SeeMoreP.toSeeMore(); }
        break;
    }

    navIndex = index;
    update();
  }

  static void goBack() => Get.back(result: true);

  static void showBadgeDialog(FBadge? badge) {
    FUserCollection user = Get.find<UserCollectionP>().loggedUser;

    if (badge == null) return;

    bool have = user.collections.map((col) => col.badgeId!).contains(badge.id);

    if (have) {
      Collection collection = user.getCollectionsById(badge.id!)!;
      showCollectionDialog(collection);
      return;
    }

    showPDialog(
      title: badge.title,
      content: Column(
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                EternalRotation(
                  rps: .3,
                  child: Image.asset(
                    effect2Asset,
                    width: 180.0.r,
                    height: 180.0.r,
                  ),
                ),
                BadgeWidget(
                  badge: badge,
                  size: 80.0.r,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.topLeft,
            child: FText(badge.toAcquire, maxLines: 5),
          ),
        ],
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }

  static void showCollectionDialog(Collection? collection) {
    if (collection == null) return;

    FUserCollection user = Get.find<UserCollectionP>().loggedUser;
    bool isMainBadge = user.badgeId! == collection.badgeId;

    showPDialog(
      title: collection.badge!.title,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 95.0.h,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CollectionWidget(
                      collection: collection,
                      onPressed: () {
                        Get.back();
                        CollectionP.toCollection();
                      },
                    ),
                    Container(
                      width: 30.0.r,
                      height: 30.0.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: FTheme.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: FTheme.black, width: 1.5),
                      ),
                      child: FText('${collection.dates.length}', border: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20.0),
              Container(
                constraints: const BoxConstraints(maxHeight: 70.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: collection.dateList.map((date) => FText(
                        dateToString('yyyy-MM-dd 획득!', date.toDate())!,
                        color: date == collection.dateList.last
                            ? FTheme.colorB : FTheme.black,
                        bold: date == collection.dateList.last,
                      ),
                    ).toList().reversed.toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.topLeft,
            constraints: const BoxConstraints(minHeight: 100.0),
            child: FText(collection.badge!.description!, maxLines: 5),
          ),
        ],
      ),
      type: isMainBadge ? DialogType.mono : DialogType.bi,
      leftText: isMainBadge ? null : '대표 컬렉션으로 설정',
      leftPressed: isMainBadge ? null : (() async {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 200));
        final collectionP = Get.find<CollectionP>();
        collectionP.setMainBadge(collection);
      }),
      rightPressed: isMainBadge ? null : Get.back,
      onPressed: isMainBadge ? Get.back : null,
    );
  }

  static void showAwardedBadgeDialog(FBadge badge,
      [bool firstAward = false]) async {
    showPDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 300.0.w,
                height: 300.0.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (firstAward)
                      EternalRotation(
                        rps: .3,
                        child: Image.asset(
                          effectAsset,
                          width: 180.0.r,
                          height: 180.0.r,
                        ),
                      ),
                    BadgeWidget(
                      badge: badge,
                      size: 80.0.r,
                      onPressed: () {
                        Get.back();
                        CollectionP.toCollection();
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: .0,
                child: FText(
                  '${firstAward ? '신규' : ''} 뱃지 획득!',
                  style: textTheme.headlineSmall,
                ),
              ),
              Positioned(
                top: 40.0,
                right: 20.0,
                child: FText(
                  dateToString('yyyy-MM-dd', now)!,
                  color: FTheme.colorB,
                  align: TextAlign.end,
                ),
              ),
              Positioned(
                bottom: 20.0,
                child: Column(
                  children: [
                    FText(
                      badge.title!,
                      style: textTheme.titleLarge,
                      bold: true,
                    ),
                    const SizedBox(height: 5.0),
                    FText(
                      badge.description!,
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      type: DialogType.bi,
      leftText: '대표 컬렉션으로 설정',
      leftPressed: () async {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 200));
        final userP = Get.find<UserCollectionP>();
        userP.setMainBadge(badge.id!);
      },
      rightPressed: Get.back,
    );
  }

  // 대표 컬렉션 설정 팝업
  static void showCollectionSettingDialog(String badgeId) {
    FBadge? selectedBadge = BadgeJsonP.getBadge(badgeId);

    showPDialog(
      title: '대표 컬렉션 변경',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          selectedBadge == null
              ? FText('대표 컬렉션이 해제되었습니다.')
              : Column(
            children: [
              BadgeWidget(badge: selectedBadge, size: 100.0.r),
              SizedBox(height: 20.0.h),
              FText('대표 컬렉션이'),
              FTexts([
                selectedBadge.title!,
                '${roEuro(selectedBadge.title!)} 설정되었습니다.'
              ], colors: const [FTheme.colorB, FTheme.black],
                space: false,
              )
            ],
          ),
        ],
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }

  static void initControllers() {
    Get.put(GlobalP());

    Get.put(LoadingP());

    Get.put(UserCollectionP());
    Get.put(UserFriendP());
    Get.put(UserInfoP());
    Get.put(UserNotificationP());
    Get.put(UserPartyP());
    Get.put(UserRecordP());

    Get.put(ChallengeJsonP());
    Get.put(BadgeJsonP());
    Get.put(LevelJsonP());
    Get.put(QuestJsonP());
    Get.put(PartyJsonP());

    Get.put(OnboardingP());
    Get.put(RegisterP());
    Get.put(NotificationP());

    Get.put(ExerciseDetailSetting());

    //Camera Presenter
    Get.put(CameraP());
    Get.put(PainterP());

    Get.put(HomeP());
    Get.put(RankingP());
    Get.put(CalendarP());

    Get.put(FriendP());

    Get.put(ContentsP());
    Get.put(ChallengeDetailP());
    Get.put(PartyP());
    Get.put(TimeAttackReadyP());
    Get.put(TimeAttackFriendP());
    Get.put(TimeAttackCameraP());

    Get.put(SeeMoreP());
    Get.put(CollectionP());
    Get.put(InfoEditP());
  }
}