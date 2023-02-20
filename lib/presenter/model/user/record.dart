/* 사용자 모델 프리젠터 */
import 'package:fitween/model/class/database/user/record.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
import 'package:fitween/presenter/health/health.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/record.dart';

/// class
// 사용자 객체 관련
class UserRecordP extends GetxController {
  /// static variables
  static get collection => f.collection('userRecords');

  /// static methods
  static Future<FUserRecord?> loadUser(String uid) async {
    var json = (await collection.doc(uid).get()).data();
    if (json == null) return null;
    return FUserRecord.fromJson(json);
  }

  static void saveUser(FUserRecord user) async {
    collection.doc(user.uid).set(user.toJson());
  }

  /// attributes
  /* 로그인 관련 */
  // 현재 로그인된 사용자
  FUserRecord loggedUser = FUserRecord();

  // 로그인 여부
  bool get isLogged => loggedUser.uid != null;

  /// methods
  /* 로그인 관련 */
  // 로그인
  // 매개변수로 받은 사용자 정보와 User Credential 정보를 병합하여 현재 로그인된 사용자자 최신화
  Future login(FUserRecord user) async {
    Map<String, dynamic> json = user.toJson();
    loggedUser = FUserRecord.fromJson(json);
    if (!await fetchData()) await load();
    save();
  }

  // 로그아웃
  // 현재 로그인된 사용자 정보 초기화
  void logout() => loggedUser = FUserRecord();

  /* 파이어베이스 관련 */
  // 파이어베이스에서 로드
  Future load() async {
    var json = (await collection.doc(loggedUser.uid).get()).data();
    if (json == null) return;
    loggedUser = FUserRecord.fromJson(json);
  }

  // 파이어베이스에 최신화
  void save() => collection
      .doc(loggedUser.uid)
      .set(loggedUser.toJson());

  // 파이어베이스에서 삭제
  void delete() => collection
      .doc(loggedUser.uid).delete();

  /* 기록 관련 */
  // 건강 및 구글핏 데이터 불러오기
  Future<bool> fetchData() async {
    bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    bool fetchCompleted = true;

    await HealthPresenter.requestAuth();
    fetchCompleted &= await HealthPresenter.fetchStepData();
    if (isIOS) fetchCompleted &= await HealthPresenter.fetchFlightsData();

    return fetchCompleted;
  }

  // 로그인된 사용자의 거리 및 높이 기록에 따른 칼로리 소모량을 계산하여 최신화
  void updateCalorie() async {
    DistanceRecord distance = DistanceRecord(
      amount: loggedUser.getAmounts(
        ActivityType.distance,
        today,
        oneSecondBefore(tomorrow),
      ),
      state: ExerciseUnit.step,
    );

    HeightRecord height = HeightRecord(
      amount: loggedUser.getAmounts(
        ActivityType.height,
        today,
        oneSecondBefore(tomorrow),
      ),
    );

    WeightRecord weight = WeightRecord(
      amount: loggedUser.getAmounts(
        ActivityType.weight,
        today,
        oneSecondBefore(tomorrow),
      ),
      state: ExerciseUnit.count,
    );

    CalorieRecord calorie = CalorieRecord(amount: 0);

    calorie.amount += CalorieRecord.from(
      ActivityType.distance,
      distance.minute,
    );
    calorie.amount += CalorieRecord.from(
      ActivityType.height,
      height.amount,
    );
    calorie.amount += CalorieRecord.from(
      ActivityType.weight,
      weight.amount,
    );

    loggedUser.setRecord(
      ActivityType.calorie,
      today, calorie,
    );

    save();
    update();
  }

  void clearRecords() {
    for (ActivityType type in ActivityType.values) {
      ExerciseUnit? unit;

      switch (type) {
        case ActivityType.distance:
          unit = ExerciseUnit.step;
          break;
        case ActivityType.weight:
          unit = ExerciseUnit.count;
          break;
        default: break;
      }
      Record record = Record.init(type, 0, unit);
      loggedUser.setRecord(type, today, record);
    }
  }

  // 해당 활동형식의 기록 추가 (구글핏/건강 연동, 칼로리 계산, 관련 뱃지 수여)
  void addRecord(
      ActivityType type,
      Record record,
      ) async {
    late int before, after;

    before = loggedUser.completedActivities.length;

    loggedUser.addRecord(type, today, record, true);
    updateCalorie();

    after = loggedUser.completedActivities.length;

    if (before != 3 && after == 3) {
      BadgePresenter.awardDailyActivityCompleteBadge();
    }
    save();
  }

  // 해당 활동형식의 기록 설정
  void setRecord(ActivityType type, Record record) async {
    late int before, after;

    before = loggedUser.completedActivities.length;

    loggedUser.setRecord(type, today, record);
    updateCalorie();

    after = loggedUser.completedActivities.length;

    if (before != 3 && after == 3) {
      BadgePresenter.awardDailyActivityCompleteBadge();
    }
    save();
  }
}
