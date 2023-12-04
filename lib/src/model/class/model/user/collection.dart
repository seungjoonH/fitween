import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FUserCollection extends FUser {
  @override
  FUserCollection? get collection => this;

  String? _badgeId;
  Map<String, int> _inventoryData = {};

  Map<String, _CollectionData> _collectionsData = {};
  Map<String, Item> _inventory = {};

  bool _hasGiftReceived = false;
  bool get hasGiftReceived => _hasGiftReceived;

  String? get badgeId => _badgeId;
  Map<String, Item> get inventory => _inventory;
  Map<String, int> get counts => _inventoryData;

  List<String> get badgeIds => _collectionsData.keys.toList();

  Map<String, List<DateTime>> get dates => {
    for (String id in _collectionsData.keys) id: _collectionsData[id]!.dates,
  };

  void syncItemsFrom(Map<String, Item> inventory, Map<String, int> counts) {
    _inventory.assignAll({...inventory});
    _inventoryData.assignAll({...counts});
  }

  void syncBadgesFrom(Map<String, List<DateTime>> data, String badgeId) {
     var colData = { for (String id in data.keys) id: _CollectionData(id, data[id]!) };
    _collectionsData.assignAll({...colData});
    _badgeId = badgeId;
  }

  void receiveGift() => _hasGiftReceived = true;

  List<Collection> get ordered {
    List<Collection> cols = [...collections.values];
    cols.sort((a, b) => a.dates.last!.isBefore(b.dates.last!) ? 1 : -1);
    return cols;
  }

  @override
  Color get badgeColor => FType.values[uid.codeUnitAt(1) % 4].color;

  void _buildInventory() {
    _inventory = {
      for (String id in _inventoryData.keys)
        id : ItemLocal().get(id)!
    };
  }

  FUserCollection(super.key) : super();
  FUserCollection.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _collectionsData = {};
    uid = json['uid'];
    _badgeId = json['badgeId'];
    _inventoryData = Map.fromIterables(
      json['inventoryData']?.keys.cast<String>() ?? <String>[],
      json['inventoryData']?.values.cast<int>() ?? <int>[],
    );
    for (var data in json['collectionsData'] ?? json['collections']) {
      _collectionsData[data['badgeId']] = _CollectionData.fromJson(data);
    }
    _hasGiftReceived = json['hasGiftReceived'] ?? false;
    _buildInventory();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = uid;
    json['badgeId'] = _badgeId;
    json['collectionsData'] = _collectionsData.values.map((c) => c.toJson());
    json['inventoryData'] = _inventoryData;
    json['hasGiftReceived'] = _hasGiftReceived;
    return json;
  }
}

class _CollectionData extends Model {
  late String _badgeId;
  List<Timestamp> _dates = [];

  List<DateTime> get dates => _dates.map((date) => date.toDate()).toList();

  _CollectionData(String id, List<DateTime> dates) {
    _badgeId = id;
    _dates = dates.map((date) => date.toTimestamp!).toList();
  }
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