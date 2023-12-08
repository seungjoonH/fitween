import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/health/health.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Item extends Model {
  static const _asset = 'assets/image/item';

  late String _id;
  late Map<String, String> _titles;
  late Map<String, String> _descriptions;
  ItemUsingStrategy? _strategy;

  set strategy(ItemUsingStrategy s) => _strategy = s;

  String get _locale => LangCont.to.language.code;
  String get title => _titles[_locale]!;
  String get description => _descriptions[_locale]!;
  String get imageUrl => '$_asset/$_id.svg';

  Future use() async {
    if (_strategy == null) throw UnimplementedError();
    await _strategy!.use();
  }

  Item._fromJson(super.json) : super.fromJson();

  factory Item.fromId(String id) => ItemLocal().get(id)!;

  factory Item.fromJson(Map<String, dynamic> json) {
    Item item = Item._fromJson(json);
    switch (item.key) {
      case '4000000': return item..strategy = FP1CouponUsingStrategy();
      case '4000001': return item..strategy = FP5CouponUsingStrategy();
      case '4000002': return item..strategy = FP10CouponUsingStrategy();
      case '4000003': return item..strategy = FP50CouponUsingStrategy();
      case '4000004': return item..strategy = FP100CouponUsingStrategy();
      case '4000005': return item..strategy = FP500CouponUsingStrategy();
      case '4000006': return item..strategy = FP1000CouponUsingStrategy();
      case '4000007': return item..strategy = FP5000CouponUsingStrategy();
      case '4000008': return item..strategy = FP10000CouponUsingStrategy();
      case '4000009': return item..strategy = FP50000CouponUsingStrategy();
      case '4000100': return item..strategy = AllDataCouponUsingStrategy();
      default: return item;
    }
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _titles = Map.fromIterables(
      json['title']?.keys.toList(),
      json['title']?.values.map<String>((e) => e.toString()),
    );
    _descriptions = Map.fromIterables(
      json['description']?.keys.toList(),
      json['description']?.values.map<String>((e) => e.toString()),
    );
  }

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();

  @override
  String get key => _id;
}


abstract class ItemUsingStrategy {
  String get id;
  FUser get logged => AuthCont.logged!;
  Future use() async {
    showItemUsedDialog();
    await save();
  }
  Future save() async {
    await FUserDAO().saveOne(logged);
  }
  void showItemUsedDialog() {
    Item item = Item.fromId(id);
    String itemUsedTitle = LangCont.tr('item.dialog.used-title');
    String itemUsedText = LangCont.tr('item.dialog.used-text');
    showFDialog(
      title: itemUsedTitle,
      content: Column(
        children: [
          FText(
            item.title,
            style:ThemeCont.to.bodyLarge,
            bold: true,
          ),
          SizedBox(height: 10.0.h),
          FText(
            itemUsedText,
            style: ThemeCont.to.bodyLarge,
            maxLines: 0,
          ),
        ],
      ),
      type: DialogType.mono,
    );
  }
}

class FP1CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000000';

  @override
  Future use() async {
    await FPointCont.to.earn(1, '1-fp-coupon');
    await super.use();
  }
}

class FP5CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000001';

  @override
  Future use() async {
    await FPointCont.to.earn(5, '5-fp-coupon');
    await super.use();
  }
}

class FP10CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000002';

  @override
  Future use() async {
    await FPointCont.to.earn(10, '10-fp-coupon');
    await super.use();
  }
}

class FP50CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000003';

  @override
  Future use() async {
    await FPointCont.to.earn(50, '50-fp-coupon');
    await super.use();
  }
}

class FP100CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000004';

  @override
  Future use() async {
    await FPointCont.to.earn(100, '100-fp-coupon');
    await super.use();
  }
}

class FP500CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000005';

  @override
  Future use() async {
    await FPointCont.to.earn(500, '500-fp-coupon');
    await super.use();
  }
}

class FP1000CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000006';

  @override
  Future use() async {
    await FPointCont.to.earn(1000, '1000-fp-coupon');
    await super.use();
  }
}

class FP5000CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000007';

  @override
  Future use() async {
    await FPointCont.to.earn(5000, '5000-fp-coupon');
    await super.use();
  }
}

class FP10000CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000008';

  @override
  Future use() async {
    await FPointCont.to.earn(10000, '10000-fp-coupon');
    await super.use();
  }
}

class FP50000CouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000009';

  @override
  Future use() async {
    await FPointCont.to.earn(50000, '50000-fp-coupon');
    await super.use();
  }
}

class AllDataCouponUsingStrategy extends ItemUsingStrategy {
  @override
  String get id => '4000100';

  @override
  Future use() async {
    await HealthDataCont.setAllRecords();
    await super.use();
  }
}