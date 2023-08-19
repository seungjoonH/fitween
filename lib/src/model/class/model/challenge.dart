import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/model/class/local/badge.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';

class Challenge extends Model {
  static const String _assetDir = 'assets/image/challenge/';

  late String _id;
  bool _locked = false;
  late String _title;
  late FType _type;
  late String _word;
  late int _period;

  Map<String, dynamic> _descriptions = {};
  Map<String, dynamic> _levels = {};

  final Map<Difficulty, FBadge> _badges = {};

  Map<String, String> get imageUrls => {
    'default': '${_assetDir}default/$_id.png',
    'complete': '${_assetDir}complete/$_id.png',
    'focus': '${_assetDir}focus/$_id.png',
  };

  FType get type => _type;

  Challenge.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _locked = json['locked'];
    _title = json['title'][LangCont.locale];
    _type = FType.toEnum(json['type'])!;
    _word = json['word'][LangCont.locale];
    _levels = json['levels'];
    _period = json['period'];
    _descriptions = json['descriptions'][LangCont.locale];
    _levels.forEach((string, level) {
      String id = level['collection'];
      _badges[Difficulty.toEnum(string)] = FBadgeLocal().get(id)!;
    });
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = _id;
    json['locked'] = _locked;
    json['title'] = _title;
    json['type'] = _type.name;
    json['word'] = _word;
    json['levels'] = _levels;
    json['period'] = _period;
    json['descriptions'] = _descriptions;
    return json;
  }

  @override
  String get key => _id;
}