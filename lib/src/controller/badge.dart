import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FBadgeCont extends GetxController {
  static FBadgeCont get to => Get.find<FBadgeCont>();

  final _data = <String, List<DateTime>>{}.obs;
  final _mainBadgeId = ''.obs;

  FBadge? get mainBadge => FBadgeLocal().get(_mainBadgeId.value);
  bool isMain(String id) =>_mainBadgeId.value == id;


  int _compareBadge(FBadge a, FBadge b) {
    return getDates(b.key).first.compareTo(getDates(a.key).first);
  }

  List<FBadge> get badges => [
    for (String id in _data.keys) FBadge.fromId(id),
  ]..sort(_compareBadge);
  List<FBadge> get badgesWithOutMain => [...badges]
    ..removeWhere((badge) => isMain(badge.key))..sort(_compareBadge);

  List<FBadge> getBadgesByType(FBadgeType type) => [...badges]
      .where((badge) => badge.type == type).toList()..sort(_compareBadge);

  bool hasBadgeOnType(FBadgeType type) => getBadgesByType(type).isNotEmpty;

  List<DateTime> getDates(String id) {
    if (!hasBadge(id)) return [];
    int compare(DateTime a, DateTime b) => b.compareTo(a);
    return [..._data[id]!]..sort(compare);
  }
  int getCounts(String id) => getDates(id).length;

  Future init() async => await _syncFrom();

  Future _syncFrom() async {
    _data.clear();
    await AuthCont.load(FUserLoadCont.onlyCollection());
    _data.assignAll({..._logged.collection!.dates});
    _mainBadgeId(_logged.collection!.badge!.key);
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
    if (!hasBadge(id)) return;
    if (isMain(id)) return;

    _mainBadgeId(id);

    await showFDialog(
      title: setMainBadgeTitle,
      content: Column(
        children: [
          FBadgeDetailedWidget(
            badge: mainBadge!,
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

  void _myBadgePressed(FBadge badge) {
    DialogType type = DialogType.mono;
    String? leftText;
    VoidCallback? leftPressed;

    if (!isMain(badge.key)) {
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
                pressable: false,
                longPressable: false,
                displayMain: true,
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
                          dateToString('yyyy-MM-dd HH:mm', date)!,
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

  void _unknownBadgePressed(FBadge badge) {
    showFDialog(
      title: badge.title,
      content: Column(
        children: [
          FBadgeWidget(
            badge: badge,
            size: 100.0.r,
            pressable: false,
            longPressable: false,
          ),
          SizedBox(height: 10.0.h),
          FText(
            badge.title,
            style: ThemeCont.to.bodyLarge,
          ),
          SizedBox(height: 10.0.h),
          FText(
            badge.unknownDescription,
            style: ThemeCont.to.bodyMedium,
            color: ThemeCont.to.comment,
          ),
        ],
      ),
      type: DialogType.mono,
    );
  }

  void onPressed(FBadge? badge) {
    if (badge == null) return;
    if (hasBadge(badge.key)) { _myBadgePressed(badge); }
    else { _unknownBadgePressed(badge); }
  }

  void onLongPressed(FBadge? badge) {
    if (badge == null) return;
    setMainBadge(badge.key);
  }
}