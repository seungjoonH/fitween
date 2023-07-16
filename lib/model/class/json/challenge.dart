import 'package:fitween/model/class/json/badge.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/difficulty.dart';
import 'package:fitween/presenter/model/json/badge.dart';

class Challenge {
  /// static variables
  static String imageAsset = 'assets/images/challenge/';

  /// static methods
  static Map<String, dynamic> idToImageUrls(String id) => {
    'default': '${imageAsset}default/$id.png',
    'complete': '${imageAsset}complete/$id.png',
    'focus': '${imageAsset}focus/$id.png',
  };

  /// attributes
  // 일반 변수
  bool locked = false;
  String? id;
  String? title;
  ActivityType? type;
  String? word;
  int? period;

  // 복합 변수
  Map<String, dynamic> imageUrls = {};
  Map<String, dynamic> descriptions = {};
  Map<String, dynamic> levels = {};

  // 의존 변수
  Map<Difficulty, FBadge> badges = {}; // levels 에 의존

  /// accessors & mutators
  String? get titleOneLine => title?.replaceAll('\n', ' ');
  Map<String, dynamic>? getLevel(Difficulty diff) => levels[diff.name];

  /// constructors
  Challenge();

  Challenge.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    locked = json['locked'];
    id = json['id'];
    title = json['title'];
    imageUrls = idToImageUrls(id!);
    type = ActivityType.toEnum(json['type']);
    word = json['word'];
    levels = json['levels'];
    period = json['period'];
    descriptions = json['descriptions'];
    levels.forEach((string, level) {
      String id = level['collection'];
      badges[Difficulty.toEnum(string)!] = BadgeJsonP.getBadge(id)!;
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['title'] = title;
    json['type'] = type?.name;
    json['word'] = word;
    json['levels'] = levels;
    json['period'] = period;
    json['descriptions'] = descriptions;
    return json;
  }
}