import 'package:fitween/model/enum/activity_type.dart';

class Level {
  /// attributes
  String? id;
  String? title;
  double? amount;
  String? description;
  String? imageUrl;
  bool? activate;

  /// constructors
  Level();

  Level.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = '${json['title']}';
    amount = json['amount'].toDouble();
    description = json['description'];
    imageUrl = idToImageUrl(id!);
    activate = json['activate'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = int.parse(json['id']);
    json['title'] = title;
    json['amount'] = amount;
    json['description'] = description;
    json['activate'] = activate;
    return json;
  }

  /// static variables
  static String asset = 'assets/images/level/';

  /// static methods
  static String idToImageUrl(String id) {
    String name = ActivityType.values[int.parse(id[2])].name;
    return '$asset$name/$id.png';
  }
}