import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/notification.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/model/json/party.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/presenter/page/see_more/see_more.dart';
import 'package:fitween/view/page/see_more/goal_edit/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class GoalEditP extends GetxController {
  int pageIndex = 0;
  bool invalid = false;
  List<bool> imageExistence = [
    true, false, true, true, true, false,
  ];
  bool imageVisualize = false;

  static const Duration shakeDuration = Duration(milliseconds: 500);

  static Curve transitionCurve = Curves.easeInOut;
  static const Duration transitionDuration = Duration(milliseconds: 350);

  /// static variables
  static final carouselCont = CarouselController();

  /// static methods
  static void toGoalEdit() {
    GoalEditP.init();
    Get.toNamed('/seeMore/goalEdit');
  }

  // 컨트롤러를 모두 초기화
  static void init() {
    final goalEditP = Get.find<GoalEditP>();
    goalEditP.loadAll();
  }

  Map<ActivityType, Record> amounts = {};

  void loadAll() {
    final userCollectionP = Get.find<UserCollectionP>();
    final userFriendP = Get.find<UserFriendP>();
    final userInfoP = Get.find<UserInfoP>();
    final userNotificationP = Get.find<UserNotificationP>();
    final userPartyP = Get.find<UserPartyP>();
    final userRecordP = Get.find<UserRecordP>();

    userCollection = userCollectionP.loggedUser;
    userFriend = userFriendP.loggedUser;
    userInfo = userInfoP.loggedUser;
    userNotification = userNotificationP.loggedUser;
    userParty = userPartyP.loggedUser;
    userRecord = userRecordP.loggedUser;

    pageIndex = 0;

    for (ActivityType type in ActivityType.activeValues) {
      amounts[type] = userRecord.getGoal(type, tomorrow)!;
    }

    update();
  }

  // 현재 페이지 인덱스 증가
  void pageIndexIncrease() {
    if (pageIndex < CarouselView.widgetCount - 1) pageIndex++;
    update();
  }

  // 현재 페이지 인덱스 감소
  void pageIndexDecrease() {
    if (pageIndex > 0) pageIndex--;
    update();
  }

  /// attributes
  // 추가될 유저
  late FUserCollection userCollection;
  late FUserFriend userFriend;
  late FUserInfo userInfo;
  late FUserNotification userNotification;
  late FUserParty userParty;
  late FUserRecord userRecord;
  bool keyboardVisible = false;

  void setKeyboardVisible(bool value) {
    keyboardVisible = value;
    update();
  }

  /// methods
  void initGoal(Record record) async {
    amounts[record.type!] = Record.init(record.type!, .0, {
      ActivityType.distance: ExerciseUnit.minute,
      ActivityType.weight: ExerciseUnit.count,
    }[record.type!]);
    update();
    await Future.delayed(const Duration(milliseconds: 500), () {
      amounts[record.type!] = record;
      update();
    });
  }

  void setGoal(Record record) {
    amounts[record.type!] = record;
  }

  void submitted() async {
    final userCollectionP = Get.find<UserCollectionP>();
    final userFriendP = Get.find<UserFriendP>();
    final userInfoP = Get.find<UserInfoP>();
    final userNotificationP = Get.find<UserNotificationP>();
    final userPartyP = Get.find<UserPartyP>();
    final userRecordP = Get.find<UserRecordP>();

    for (ActivityType type in ActivityType.activeValues) {
      userRecord.setGoal(type, today, amounts[type]!, {
        ActivityType.distance: ExerciseUnit.step,
        ActivityType.weight: ExerciseUnit.count,
      }[type]);
    }

    userCollectionP.loggedUser = userCollection;
    userFriendP.loggedUser = userFriend;
    userInfoP.loggedUser = userInfo;
    userNotificationP.loggedUser = userNotification;
    userPartyP.loggedUser = userParty;
    userRecordP.loggedUser = userRecord;

    userCollectionP.save();
    userFriendP.save();
    userInfoP.save();
    userNotificationP.save();
    userPartyP.save();
    userRecordP.save();

    SeeMoreP.toSeeMore();
  }

  void slideBack() async {
    imageVisualize = false;
    update();
    await Future.delayed(const Duration(milliseconds: 5), () {
      imageVisualize = imageExistence[pageIndex];
      update();
    });
  }

  void slideNext() async {
    imageVisualize = false;
    update();
    await Future.delayed(const Duration(milliseconds: 5), () {
      imageVisualize = imageExistence[pageIndex];
      update();
    });
  }

  // 다음 버튼 클릭 트리거
  void nextPressed() async {
    switch (pageIndex) {
      case 0:
        initGoal(amounts[ActivityType.distance]!);
        break;
      case 1: break;
      case 2:
        initGoal(amounts[ActivityType.height]!);
        break;
      case 3: break;
      case 4:
        initGoal(amounts[ActivityType.weight]!);
        break;
      case 5:
        submitted();
        return;
    }
    carouselCont.nextPage(
      curve: transitionCurve,
      duration: transitionDuration,
    );
    pageIndexIncrease();
    slideNext();
  }

  // 뒤로가기 버튼 클릭 트리거
  void backPressed() {
    if (pageIndex == 0) {
      SeeMoreP.toSeeMore();
      return;
    }

    carouselCont.previousPage(
      curve: transitionCurve,
      duration: transitionDuration,
    );

    slideBack();
    pageIndexDecrease();
  }
}