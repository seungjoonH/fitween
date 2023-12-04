import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FBadgeCont extends GetxController {
  static FBadgeCont get to => Get.find<FBadgeCont>();

  final _data = <String, List<DateTime>>{};
  final _mainBadgeId = ''.obs;

  FBadge get mainBadge => FBadge.fromId(_mainBadgeId.value);
  bool isMain(String id) =>_mainBadgeId.value == id;

  List<FBadge> get badges => [
    for (String id in _data.keys) FBadge.fromId(id),
  ];

  List<FBadge> get badgesWithOutMain => [...badges]
    ..removeWhere((badge) => isMain(badge.key));

  List<FBadge> getBadgesByType(FBadgeType type) => [...badges]
      .where((badge) => badge.type == type).toList();

  bool hasBadgeOnType(FBadgeType type) => getBadgesByType(type).isNotEmpty;

  List<DateTime> getDates(String id) {
    int compare(DateTime a, DateTime b) => b.compareTo(a);
    return [..._data[id]!]..sort(compare);
  }
  int getCounts(String id) => getDates(id).length;

  Future init() async => await _syncFrom();

  Future _syncFrom() async {
    await AuthCont.load(FUserLoadCont.onlyCollection());
    _data.assignAll({..._logged.collection!.dates});
    _mainBadgeId(_logged.collection!.badgeId);
  }

  Future _syncTo() async {
    _logged.collection!.syncBadgesFrom(_data, _mainBadgeId.value);
    await FUserCollectionDAO().saveOne(_logged.collection!);
  }

  bool hasBadge(String id) => _data.keys.contains(id);

  Future earnBadge(String id) async {
    FBadge badge = FBadge.fromId(id);
    if (!badge.canBeEarned) return;
    List<DateTime>? dates;
    if (hasBadge(id)) dates = _data[id]!..add(now);
    dates ??= [now];
    _data[id] = dates;
    badge.earn();
    await _syncTo();
  }

  Future setMainBadge(String id) async {
    if (isMain(id)) return;

    _mainBadgeId(id);

    await showFDialog(
      title: setMainBadgeTitle,
      content: Column(
        children: [
          FBadgeDetailedWidget(
            badge: mainBadge,
            displayTitle: true,
            displayMain: true,
            size: 80.0.r,
          ),
          SizedBox(height: 10.0.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: FText(
              setMainBadgeText,
              style: ThemeCont.to.bodyLarge,
              maxLines: 0,
            ),
          ),
        ],
      ),
      type: DialogType.mono,
    );

    await _syncTo();
  }

  FUser get _logged => AuthCont.logged!;

  String get setMainBadgeTitle => LangCont.tr('badge.dialog.set-main-title');
  String get setMainBadgeText => LangCont.tr('badge.dialog.set-main-text');
  String get acquiredDateText => LangCont.tr('word.acquired-date');
  String get setAsMainText => LangCont.tr('badge.set-as-main');

  void onPressed(FBadge badge) {
    bool has = hasBadge(badge.key);
    DialogType type = DialogType.mono;
    String? leftText;
    VoidCallback? leftPressed;

    if (has && !isMain(badge.key)) {
      type = DialogType.bi;
      leftText = setAsMainText;
      leftPressed = () => setMainBadge(badge.key);
    }

    showFDialog(
      title: badge.title,
      content: Column(
        children: [
          Row(
            children: [
              FBadgeWidget(
                badge: badge,
                size: 90.0.r,
              ),
              SizedBox(width: 10.0.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FText(
                      acquiredDateText,
                      style: ThemeCont.to.bodyMedium,
                      bold: true,
                    ),
                    SizedBox(height: 5.0.h),
                    SingleChildScrollView(
                      child: Column(
                        children: getDates(badge.key).map((date) => FText(
                          dateToString('yyyy-MM-dd hh:mm', date)!,
                          color: ThemeCont.to.comment,
                          style: ThemeCont.to.bodySmall,
                        )).separateW(width: 10.0.w),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0.h),
          FText(
            badge.description,
            style: ThemeCont.to.bodyMedium,
            maxLines: 0,
          ),
        ],
      ),
      type: type,
      leftText: leftText,
      leftPressed: leftPressed,
    );
  }

  void onLongPressed(FBadge badge) {
    setMainBadge(badge.key);
  }
}