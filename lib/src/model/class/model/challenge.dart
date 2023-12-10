import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/model/class/local/badge.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';

class _ChallengeLevel extends Model {
  late Map<String, String> _word;
  late num _goal;
  late int _maxMemberCount;
  late String _badgeId;
  late int _point;

  String get word => _word[LangCont.locale]!;

  FBadge? get badge => FBadgeLocal().get(_badgeId);

  _ChallengeLevel.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _word = Map.fromIterables(
      json['word']?.keys.toList(),
      json['word']?.values.map<String>((e) => e.toString()),
    );
    _goal = json['goal'];
    _maxMemberCount = json['maxMember'];
    _badgeId = json['badgeId'];
    _point = json['point'];
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  String get key => throw UnimplementedError();
}

class Challenge extends Model {
  static const String _assetDir = 'assets/image/challenge/';

  late String _id;
  bool _locked = false;
  late Map<String, String> _titles;
  late FType _type;
  late Map<String, String> _words;
  late int _period;

  Map<String, dynamic> _descriptions = {};
  Map<Difficulty, _ChallengeLevel> _levels = {};

  Map<String, String> get _imageUrls => {
    'default': '${_assetDir}default/$_id.png',
    'complete': '${_assetDir}complete/$_id.png',
    'focus': '${_assetDir}focus/$_id.png',
  };

  String get _locale => LangCont.to.language.code;
  String get title => _titles[_locale]!;
  FType get type => _type;
  String get word => _words[_locale]!;
  int get period => _period;
  bool get locked => _locked;

  String get subDescription => _descriptions[_locale]['sub'].replaceAll('##', word);
  String getDetailDescription({Difficulty? difficulty, bool txs = false}) {
    _ChallengeLevel? level = _levels[difficulty];
    String replace = level == null ? word : level.word;
    if (txs) replace = '@{$replace}';
    return _descriptions[_locale]['detail']
        .replaceAll('##', replace)
        .replaceAll('  ', ' ').trim();
  }
  String getCompleteDescription({Difficulty? difficulty, bool txs = false}) {
    _ChallengeLevel? level = _levels[difficulty];
    String replace = level == null ? word : level.word;
    if (txs) replace = '@{$replace}';
    return _descriptions[_locale]['complete']
        .replaceAll('##', replace)
        .replaceAll('  ', ' ').trim();
  }

  int getMaxMemberCount(Difficulty d) => _levels[d]!._maxMemberCount;

  String get _emptyImageUrl => '${_assetDir}empty.png';
  String get defaultImageUrl => _imageUrls['default'] ?? _emptyImageUrl;
  String get completeImageUrl => _imageUrls['complete'] ?? _emptyImageUrl;
  String get focusImageUrl => _imageUrls['focus']!;

  num getGoal(Difficulty d) => _levels[d]!._goal;

  int getPoint(Difficulty d) => _levels[d]!._point;

  Challenge.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _locked = json['locked'];
    _titles = Map.fromIterables(
      json['title']?.keys.toList(),
      json['title']?.values.map<String>((e) => e.toString()),
    );
    _type = FType.toEnum(json['type'])!;
    _words = Map.fromIterables(
      json['word']?.keys.toList(),
      json['word']?.values.map<String>((e) => e.toString()),
    );
    _levels = Map.fromIterables(
      json['levels']?.keys.map<Difficulty>((string) => Difficulty.toEnum(string)),
      json['levels']?.values.map<_ChallengeLevel>((v) => _ChallengeLevel.fromJson(v)),
    );
    _period = json['period'];
    _descriptions = Map.fromIterables(
      json['descriptions']?.keys,
      json['descriptions']?.values,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
    // Map<String, dynamic> json = {};
    // json['id'] = _id;
    // json['locked'] = _locked;
    // json['title'] = _title;
    // json['type'] = _type.name;
    // json['levels'] = _levels;
    // json['period'] = _period;
    // json['descriptions'] = _descriptions;
    // return json;
  }

  @override
  String get key => _id;
}