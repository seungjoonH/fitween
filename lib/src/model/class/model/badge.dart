import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

enum FBadgeType {
  normal, distance, height, weight, etc;
  String get locale => LangCont.tr('badge.type.$name');
  String? get code => ['100', '101', '102', '103', null][index];

  static FBadgeType get(String id) => values
      .firstWhereOrNull((type) => type.code == id.substring(0, 3)) ?? etc;
}

class FBadge extends Model {
  static const _assetDir = 'assets/image/badge/';

  late String _id;
  late Map<String, String> _titles;
  late Map<String, String> _descriptions;
  late bool _activate;

  FBadgeEarningStrategy? _strategy;
  set strategy(FBadgeEarningStrategy s) => _strategy = s;

  String get _locale => LangCont.to.language.code;

  String get title => _titles[_locale]!;
  String get description => _descriptions[_locale]!;
  String get imageUrl => '$_assetDir$_id.png';
  bool get activate => _activate;

  FBadgeType get type => FBadgeType.get(_id);

  bool get canBeEarned => _strategy?.canBeEarned ?? false;

  void earn() async {
    if (_strategy == null) throw UnimplementedError();
    _strategy!.earn();
  }

  FBadge._fromJson(super.json) : super.fromJson();

  factory FBadge.fromId(String id) => FBadgeLocal().get(id)!;
  factory FBadge.fromJson(Map<String, dynamic> json) {
    FBadge badge = FBadge._fromJson(json);
    switch (badge.key) {
      case '1000000': return badge..strategy = HelloBadgeEarningStrategy();
      default: return badge;
    }
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = '${json['id']}';
    _titles = Map.fromIterables(
      json['title']?.keys.toList(),
      json['title']?.values.map<String>((e) => e.toString()),
    );
    _descriptions = Map.fromIterables(
      json['description']?.keys.toList(),
      json['description']?.values.map<String>((e) => e.toString()),
    );
    _activate = json['activate'];
  }

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();

  @override
  String get key => _id;
}

abstract class FBadgeEarningStrategy {
  String get badgeId;
  FBadge get badge => FBadgeLocal().get(badgeId)!;

  FUser get logged => AuthCont.logged!;
  bool get alreadyEarned => logged.collection!.badgeIds.contains(badgeId);
  bool get canBeEarned => true;
  bool get allowDuplicate => true;

  void earn() async {
    if (alreadyEarned && !allowDuplicate) return;
    if (!canBeEarned) return;
    _showBadgeEarnedDialog();
  }

  String get badgeEarnedTitle => LangCont.tr('badge.dialog.earned-title');
  String getBadgeEarnedText(String title, String dateFormat) => LangCont.tr(
    'badge.dialog.earned-text',
    namedArgs: {'title': title, 'date': dateFormat},
  );

  void _showBadgeEarnedDialog() {
    showFDialog(
      title: badgeEarnedTitle,
      content: Column(
        children: [
          GlowEffectWidget(
            size: 200.0.r,
            child: FBadgeWidget(badge: badge, size: 100.0.r),
          ),
          SizedBox(height: 10.0.h),
          FTexts(
            getBadgeEarnedText(
              badge.title,
              dateToString('yyyy-MM-dd hh:mm', now)!,
            ),
            style: ThemeCont.to.commentStyle,
            highlightStyles: [
              ThemeCont.to.bodyMedium!
                  .copyWith(color: ThemeCont.to.comment),
              ThemeCont.to.commentStyle!
                  .copyWith(fontWeight: FontWeight.bold),
            ],
            wordWrap: true,
            align: TextAlign.center,
          ),
        ],
      ),
      type: DialogType.mono,
    );
  }
}

class HelloBadgeEarningStrategy extends FBadgeEarningStrategy {
  @override
  String get badgeId => '1000000';

  @override
  bool get allowDuplicate => false;

  @override
  bool get canBeEarned => !alreadyEarned;
}