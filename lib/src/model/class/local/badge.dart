import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model/badge.dart';

class FBadgeLocal extends LocalModel<FBadge> {
  static final FBadgeLocal _instance = FBadgeLocal._();
  FBadgeLocal._();

  factory FBadgeLocal() => _instance;

  @override
  String get assetPath => 'assets/json/data/badges.json';

  @override
  FBadge fromJson(Map<String, dynamic> json) {
    return FBadge.fromJson(json);
  }
}