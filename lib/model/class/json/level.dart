import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:get/get.dart';

class Level {
  /// attributes
  String? id;
  String? title;
  double? amount;
  String? description;
  String? imageUrl;
  bool? activate;

  ActivityType get type => ActivityType.values[int.parse(id![2])];

  /// constructors
  Level();

  Level.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    String locale = Get.locale!.languageCode;
    if (locale != 'ko') locale = 'en';

    id = json['id']?.toString();
    title = json['title'][locale];
    amount = json['amount'].toDouble();
    // description = json['description'];
    description = json['description'][locale];
    imageUrl = idToImageUrl(id!);
    activate = json['activate'];
  }

  /// static variables
  static String asset = 'assets/image/level/';

  /// static methods
  static String idToImageUrl(String id) {
    String name = ActivityType.values[int.parse(id[2])].name;
    return '$asset$name/$id.png';
  }
}