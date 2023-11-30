import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model/item.dart';

class ItemLocal extends LocalModel<Item> {
  static final ItemLocal _instance = ItemLocal._();
  ItemLocal._();

  factory ItemLocal() => _instance;

  @override
  String get assetPath => 'assets/json/data/items.json';

  @override
  Item fromJson(Map<String, dynamic> json) {
    return Item.fromJson(json);
  }
}