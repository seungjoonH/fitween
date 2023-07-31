/* 뱃지 모델 구조 */
import 'package:fitween/presenter/lang/language.dart';

class FBadge {
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
  FBadge();

  FBadge.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// methods
  void fromJson(Map<String, dynamic> json) {
    id = '${json['id']}';
    title = '${json['title'][Lang.locale]}';
    imageUrl = '$asset$id.svg';
    description = json['description'][Lang.locale];
    activate = json['activate'];
  }
}