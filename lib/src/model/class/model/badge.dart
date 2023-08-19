import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/model/class/model.dart';

enum FBadgeType {
  normal, distance, height, weight;
  String get code => ['100', '101', '102', '103'][index];
}

class FBadge extends Model {
  static const _assetDir = 'assets/image/badge/';

  late String _id;
  late String _title;
  late String _description;
  late bool _activate;

  FBadge.fromJson(super.json) : super.fromJson();

  String get imagePath => '$_assetDir$_id.svg';

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = '${json['id']}';
    _title = '${json['title'][LangCont.locale]}';
    _description = json['description'][LangCont.locale];
    _activate = json['activate'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = _id;
    json['title'] = _title;
    json['description'] = _description;
    json['activate'] = _activate;
    return json;
  }

  @override
  String get key => _id;
}