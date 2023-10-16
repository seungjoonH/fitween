import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:flutter/material.dart';

class FUserCollection extends FUser {
  @override
  FUserCollection? get collection => this;

  String? _badgeId;

  Map<String, _CollectionData> _collectionsData = {};

  String? get badgeId => _badgeId;

  @override
  FBadge? get badge => FBadgeLocal().get(badgeId);

  List<Collection> get ordered {
    List<Collection> cols = [...collections.values];
    cols.sort((a, b) => a.dates.last!.isBefore(b.dates.last!) ? 1 : -1);
    return cols;
  }

  @override
  Color get badgeColor => FType.values[uid.codeUnitAt(1) % 4].color;

  FUserCollection(super.key) : super();
  FUserCollection.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _collectionsData = {};
    uid = json['uid'];
    _badgeId = json['badgeId'];
    for (var data in json['collectionsData'] ?? json['collections']) {
      _collectionsData[data['badgeId']] = _CollectionData.fromJson(data);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['badgeId'] = _badgeId;
    json['collectionsData'] = _collectionsData.values.map((c) => c.toJson());
    return json;
  }
}

class _CollectionData extends Model {
  late String _badgeId;
  List<Timestamp> _dates = [];

  _CollectionData.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _badgeId = json['badgeId'];
    _dates = json['dates'].cast<Timestamp>();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['badgeId'] = _badgeId;
    json['dates'] = _dates;
    return json;
  }

  @override
  String get key => '';

}