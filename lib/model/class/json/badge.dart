/* 뱃지 모델 구조 */
class PBadge {
  /// static variables
  static const asset = 'assets/image/badge/';

  /// attributes
  String? id;
  String? title;
  String? imageUrl;
  String? description;
  bool? activate;

  /// mutator & accessor
  String get toAcquire => description!.replaceAll('했습니다', '해보세요!');

  /// constructors
  PBadge();

  PBadge.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    id = '${json['id']}';
    title = json['title'];
    imageUrl = '$asset$id.png';
    description = json['description'];
    activate = json['activate'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['title'] = title;
    json['description'] = description;
    json['activate'] = activate;
    return json;
  }
}