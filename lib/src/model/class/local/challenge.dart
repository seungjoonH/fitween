import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model/challenge.dart';

class ChallengeLocal extends LocalModel<Challenge> {
  static final ChallengeLocal _instance = ChallengeLocal._privateConstructor();
  ChallengeLocal._privateConstructor();

  factory ChallengeLocal() => _instance;

  @override
  String get assetPath => 'assets/json/data/challenges.json';

  @override
  Challenge fromJson(Map<String, dynamic> json) {
    return Challenge.fromJson(json);
  }
}