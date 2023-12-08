import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/file.dart';
import 'package:fitween/src/model/class/date_range.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
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

  String get unknownDescription {
    String desc = description;
    String from = LangCont.isEnglish ? 'ed ' : '했습니다';
    String to = LangCont.isEnglish ? ' ' : '해보세요';
    return desc.replaceAll(from, to);
  }

  Future<bool> get activate async {
    return await FileCont.isLocalAsset(imageUrl);
  }

  FBadgeType get type => FBadgeType.get(_id);

  bool get alreadyEarned => _strategy?.alreadyEarned ?? false;
  bool get alreadyEarnedToday => _strategy?.alreadyEarnedToday ?? false;
  bool get canBeEarned => _strategy?.canBeEarned ?? false;

  String get levelId => '30${type.index}${_id.substring(_id.length - 4, _id.length)}';


  Future earn() async {
    if (_strategy == null) throw UnimplementedError();
    await _strategy!.earn();
  }

  FType? get ftype {
    int index = int.parse(_id.substring(2, 3));
    if (index < 1 || index > 3) return null;
    return FType.values[index];
  }

  FBadge._fromJson(super.json) : super.fromJson();

  factory FBadge.fromId(String id) => FBadgeLocal().get(id)!;
  factory FBadge.fromJson(Map<String, dynamic> json) {
    FBadge badge = FBadge._fromJson(json);

    int index = int.parse(badge.key.substring(3, badge.key.length));

    switch (badge.ftype) {
      case FType.distance: return badge..strategy = DistanceBadgeEarningStrategy(index);
      case FType.height: return badge..strategy = HeightBadgeEarningStrategy(index);
      case FType.weight: return badge..strategy = WeightBadgeEarningStrategy(index);
      default: break;
    }

    switch (badge.key) {
      // normal
      case '1000000': return badge..strategy = HelloBadgeEarningStrategy();
      case '1000001': return badge..strategy = WellAttendedBadgeEarningStrategy();
      case '1000002': return badge..strategy = GoodDayBadgeEarningStrategy();
      case '1000003': return badge..strategy = BetterDaysBadgeEarningStrategy();
      case '1000004': return badge..strategy = PerfectWeekBadgeEarningStrategy();
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

enum FBadgeDuplication { once, onceInADay, unlimited }

abstract class FBadgeEarningStrategy {
  String get badgeId;
  FBadge get badge => FBadgeLocal().get(badgeId)!;

  FUser get logged => AuthCont.logged!;
  bool get alreadyEarned => logged.collection!.badgeAlreadyEarned(badgeId);
  bool get alreadyEarnedToday {
    return logged.collection!.badgeAlreadyEarnedToday(badgeId);
  }
  bool get canBeEarned => true;

  FBadgeDuplication get duplication => FBadgeDuplication.unlimited;

  bool get once => duplication == FBadgeDuplication.once;
  bool get onceInADay => duplication == FBadgeDuplication.onceInADay;
  bool get unlimited => duplication == FBadgeDuplication.unlimited;

  Future earn() async {
    if (alreadyEarned && once) return;
    if (alreadyEarnedToday && onceInADay) return;
    if (!canBeEarned) return;
    await _showBadgeEarnedDialog();
  }

  String get badgeEarnedTitle => LangCont.tr('badge.dialog.earned-title');
  String get badgeEarnedText => LangCont.tr('badge.dialog.earned-text');

  Future _showBadgeEarnedDialog() async {
    await showFDialog(
      title: badgeEarnedTitle,
      content: Column(
        children: [
          GlowEffectWidget(
            size: 200.0.r,
            child: FBadgeWidget(badge: badge, size: 100.0.r),
          ),
          SizedBox(height: 5.0.h),
          FText(badge.title, style: ThemeCont.to.titleSmall, bold: true),
          SizedBox(height: 5.0.h),
          FText(
            dateToString('yyyy-MM-dd HH:mm', now)!,
            style: ThemeCont.to.bodyMedium!,
            color: ThemeCont.to.comment,
          ),
          SizedBox(height: 10.0.h),
          FText(
            badgeEarnedText,
            style: ThemeCont.to.commentStyle,
            maxLines: 0,
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
  FBadgeDuplication get duplication => FBadgeDuplication.once;

  @override
  bool get canBeEarned => !alreadyEarned;
}

class WellAttendedBadgeEarningStrategy extends FBadgeEarningStrategy {
  @override
  String get badgeId => '1000001';

  @override
  FBadgeDuplication get duplication => FBadgeDuplication.onceInADay;

  @override
  bool get canBeEarned => !alreadyEarnedToday;
}


abstract class RecordRelatedFBadgeEarningStrategy extends FBadgeEarningStrategy {

  @override
  FBadgeDuplication get duplication => FBadgeDuplication.onceInADay;

  Map<DateTime, bool> get weeklyData {
    Map<DateTime, bool> data = {};
    DateRange range = DateRange(today.subtract(1.w), today);
    for (DateTime date in range.dates) {
      data[date] = logged.record!.allCompleted(date);
    }
    return data;
  }
}

class GoodDayBadgeEarningStrategy extends RecordRelatedFBadgeEarningStrategy {
  @override
  String get badgeId => '1000002';

  @override
  bool get canBeEarned => !alreadyEarnedToday && weeklyData[today]!;
}

class BetterDaysBadgeEarningStrategy extends RecordRelatedFBadgeEarningStrategy {
  @override
  String get badgeId => '1000003';

  @override
  bool get canBeEarned {
    if (alreadyEarnedToday) return false;
    DateRange range = DateRange(tomorrow.subtract(3.d), today);
    for (DateTime date in range.dates) {
      if (!weeklyData[date]!) return false;
    }
    return true;
  }
}

class PerfectWeekBadgeEarningStrategy extends RecordRelatedFBadgeEarningStrategy {
  @override
  String get badgeId => '1000004';

  @override
  bool get canBeEarned {
    if (alreadyEarnedToday) return false;
    DateRange range = DateRange(tomorrow.subtract(1.w), today);
    for (DateTime date in range.dates) {
      if (!weeklyData[date]!) return false;
    }
    return true;
  }
}


abstract class LevelBadgeEarningStrategy extends FBadgeEarningStrategy {
  late int index;

  LevelBadgeEarningStrategy(this.index);

  @override
  FBadgeDuplication get duplication => FBadgeDuplication.once;

  LevelLocal get levelLocal => LevelLocal.byType(badge.ftype!)!;
  Level get level => levelLocal.get(badge.levelId)!;

  FType get type;

  @override
  String get badgeId => '10${type.index}${index.zPad4}';

  @override
  bool get canBeEarned {
    if (alreadyEarned) return false;
    LevelLocal levelLocal = LevelLocal.byType(badge.ftype!)!;
    return !levelLocal.getCurrentLevel().isEqualTo(level);
  }
}

class DistanceBadgeEarningStrategy extends LevelBadgeEarningStrategy {
  DistanceBadgeEarningStrategy(super.index);

  @override
  FType get type => FType.distance;
}
class HeightBadgeEarningStrategy extends LevelBadgeEarningStrategy {
  HeightBadgeEarningStrategy(super.index);

  @override
  FType get type => FType.height;
}
class WeightBadgeEarningStrategy extends LevelBadgeEarningStrategy {
  WeightBadgeEarningStrategy(super.index);

  @override
  FType get type => FType.weight;
}