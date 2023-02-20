/* 사용자 모델 구조 */

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:get/get.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/model/class/database/collection.dart';
import 'package:fitween/model/class/database/party.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/model/enum/sex.dart';
import 'package:fitween/presenter/model/record.dart';

// class FUser {
//   var userCollection = Get.find<UserCollectionP>().loggedUser;
//   var userFriend = Get.find<UserFriendP>().loggedUser;
//   var userInfo = Get.find<UserInfoP>().loggedUser;
//   var userParty = Get.find<UserPartyP>().loggedUser;
//   var userRecord = Get.find<UserRecordP>().loggedUser;
//
//   String? uid;
//   String? get name => userInfo.name;
//   String? get nickname => userInfo.nickname;
//   String? get email => userInfo.email;
//   int? get weight => userInfo.weight;
//   int? get height => userInfo.height;
//   Sex? get sex => userInfo.sex;
//   DateTime? get regDate => userInfo.regDate;
//   DateTime? get dateOfBirth => userInfo.dateOfBirth;
//   String? get badgeId => userCollection.badgeId;
//   List<String> get partyIds => userParty.partyIds;
//
//   // 복합 변수
//   List<Collection> get collections => userCollection.collections;
//   Map<String, dynamic> get goals => userRecord.goals;
//   Map<String, dynamic> get inputRecords => userRecord.inputRecords;
//   Map<String, dynamic> get records => userRecord.records;
//   Map<String, dynamic> get friendsData => userFriend.friendsData;
//
//   // 의존 변수
//   Map<String, Party> get parties => userParty.parties;
//   List<FUserInfo> get friends => userFriend.friends;
//
//   int get age => userInfo.age;
//   String? get dateOfBirthString => userInfo.dateOfBirthString;
//
//   List<String> get friendUids => userFriend.friendUids;
//   List<FUserInfo> get rivals => userFriend.rivals;
//   List<String> get rivalUids => userFriend.rivalUids;
//
//   // 대표 컬렉션
//   Collection? get collection => userCollection.collection;
//
//   List<Collection> get orderedCollections => userCollection.orderedCollections;
//
//   Collection? getCollectionsById(String id) {
//     return userCollection.getCollectionsById(id);
//   }
//
//   bool hasCollection(String id) => userCollection
//       .getCollectionsById(id) != null;
//
//   List<ActivityType> get completedActivities => userRecord.completedActivities;
//
//   int countCompletedDaysInARow(int days) {
//     return userCollection.countCompletedDaysInARow(days);
//   }
//
//   /// constructors
//   FUser() {
//     userCollection = FUserCollection();
//     userFriend = FUserFriend();
//     userInfo = FUserInfo();
//     userParty = FUserParty();
//     userRecord = FUserRecord();
//   }
//
//   FUser.fromJson(Map<String, dynamic> json) {
//     fromJson(json);
//   }
//
//   /// methods
//   void fromJson(Map<String, dynamic> json) {
//     uid = json['uid'];
//     userCollection.fromJson(json);
//     userFriend.fromJson(json);
//     userInfo.fromJson(json);
//     userParty.fromJson(json);
//     userRecord.fromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> json = {};
//     json.addAll(userCollection.toJson());
//     json.addAll(userFriend.toJson());
//     json.addAll(userInfo.toJson());
//     json.addAll(userParty.toJson());
//     json.addAll(userRecord.toJson());
//     return json;
//   }
//
//   /// methods
//   List<DateTime> get accessHistory => userRecord.accessHistory;
//
//   // 기록 추가
//   void addRecord(
//     ActivityType type, DateTime date,
//     Record record, [bool input = false,
//   ]) => userRecord.addRecord(type, date, record, input);
//
//   // 기록 설정
//   void setRecord(
//     ActivityType type, DateTime date,
//     Record record, [ExerciseUnit? unit,
//   ]) => userRecord.setRecord(type, date, record, unit);
//
//   void duplicateInputRecords() => userRecord.duplicateInputRecords();
//
//   // 금일 기록 반환
//   double getTodayAmounts(ActivityType type) {
//     return userRecord.getAmounts(type);
//   }
//
//   // 금월 기록 반환
//   double getThisMonthAmounts(ActivityType type) {
//     return userRecord.getThisMonthAmounts(type);
//   }
//
//   // 기록 반환
//   double getAmounts(
//     ActivityType activityType, [
//     DateTime? startDate, DateTime? endDate,
//   ]) => userRecord.getAmounts(activityType, startDate, endDate);
//
//   // 입력된 금일 기록 반환
//   double getTodayInputAmounts(ActivityType activityType) {
//     return userRecord.getTodayInputAmounts(activityType);
//   }
//
//   Record? getGoal(ActivityType type) {
//     return userRecord.getGoal(type);
//   }
//
//   void setGoal(ActivityType type, Record record) {
//     userRecord.setGoal(type, record);
//   }
//
//   // 해당 활동형식의 완료 여부 반환
//   bool completed(ActivityType type) {
//     return userRecord.completed(type);
//   }
//
//   void toggleRival(String uid) {
//     userFriend.toggleRival(uid);
//   }
//
//   void addFriend(String uid) {
//     userFriend.addFriend(uid);
//   }
//
//   void deleteFriend(String uid) {
//     friendsData.remove(uid);
//   }
//
//   bool doesFriendExist(String nickname) {
//     for (FUser user in friends) {
//       if (user.nickname == nickname) return true;
//     }
//     return false;
//   }
//
//   /// static variables
//   static int defaultWeight = 60;
//   static int defaultHeight = 170;
//
//   /// static methods
//   static List<Collection> toCollections(List<Map<String, dynamic>> jsonList) {
//     List<Collection> collections = [];
//     for (var json in jsonList) { collections.add(Collection.fromJson(json)); }
//     return collections;
//   }
//
//   static List<Map<String, dynamic>> collectionsToJsonList(List<Collection> collections) {
//     List<Map<String, dynamic>> jsonList = [];
//     for (Collection collection in collections) { jsonList.add(collection.toJson()); }
//     return jsonList;
//   }
// }

// class FUser {
//   /// static methods
//   // 무작위 코드 생성
//   static String get randomCode {
//     int length = 7;
//     const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
//     return String.fromCharCodes(
//       Iterable.generate(length, (_) => chars.codeUnitAt(
//         Random().nextInt(chars.length),
//       )),
//     );
//   }
//
//   /// attributes
//   // 일반 변수
//   String? uid;
//   String? name;
//   String? nickname;
//   String? email;
//   int? weight;
//   int? height;
//   Sex? sex;
//   Timestamp? _regDate;
//   Timestamp? _dateOfBirth;
//   String? badgeId;
//   List<String> partyIds = [];
//
//   // 복합 변수
//   List<Collection> collections = [];
//   Map<String, dynamic> goals = {};
//   Map<String, dynamic> inputRecords = {};
//   Map<String, dynamic> records = {};
//   Map<String, dynamic> friendsData = {};
//
//   // 의존 변수
//   Map<String, Party> parties = {}; // partyIds 변수에 의존
//   List<FUser> friends = []; // friendUids 변수에 의존
//
//   /// accessors & mutators
//
//   DateTime? get regDate => _regDate?.toDate();
//   DateTime? get dateOfBirth => _dateOfBirth?.toDate();
//   int get age => today.year - dateOfBirth!.year;
//
//   String? get dateOfBirthString => dateToString('yyyy-MM-dd', dateOfBirth);
//
//   set regDate(DateTime? date) => _regDate = toTimestamp(date);
//   set dateOfBirth(DateTime? date) => _dateOfBirth = toTimestamp(date);
//
//   List<String> get friendUids => friendsData.keys.toList();
//   List<FUser> get rivals => friends.where((friend) {
//     return friendsData[friend.uid]?['rival'] ?? false;
//   }).toList();
//   List<String> get rivalUids => rivals.map((user) => user.uid!).toList();
//
//   // 대표 컬렉션
//   Collection? get collection => collections
//       .firstWhereOrNull((collection) => collection.badgeId == badgeId);
//
//   List<Collection> get orderedCollections {
//     List<Collection> cols = [...collections];
//     cols.sort((a, b) {
//       DateTime aDate = a.dates.last!;
//       DateTime bDate = b.dates.last!;
//       if (aDate.isAtSameMomentAs(bDate)) return 0;
//       return aDate.isBefore(bDate) ? 1 : -1;
//     });
//     return cols;
//   }
//
//   Collection? getCollectionsById(String id) {
//     return collections.firstWhereOrNull((col) => col.badgeId == id);
//   }
//
//   bool hasCollection(String id) => getCollectionsById(id) != null;
//
//   List<ActivityType> get completedActivities {
//     List<ActivityType> types = [];
//     for (ActivityType type in ActivityType.activeValues.sublist(0, 3)) {
//       if (completed(type)) types.add(type);
//     }
//     return types;
//   }
//
//   int countCompletedDaysInARow(int days) {
//     const String code = '1000001';
//     List<DateTime?>? dates = getCollectionsById(code)?.dates;
//     dates = dates?.map((date) => ignoreTime(date!)).toList();
//
//     DateTime? before = dates?.last;
//     dates = dates?.reversed.toList().sublist(1);
//     int continuous = 1, count = 0;
//
//     for (DateTime? date in dates ?? []) {
//       if (before!.difference(date!) != const Duration(days: 1)) break;
//       before = date; continuous++;
//       if (continuous < days) continue;
//       continuous = 0; count++;
//     }
//
//     return count;
//   }
//
//   /// constructors
//   FUser() {
//     weight = defaultWeight;
//     height = defaultHeight;
//     for (var type in ActivityType.activeValues) {
//       goals[type.name] = 0;
//       inputRecords[type.name] = [];
//       records[type.name] = [];
//     }
//   }
//
//   FUser.fromJson(Map<String, dynamic> json) {
//     fromJson(json);
//   }
//
//   /// methods
//   void fromJson(Map<String, dynamic> json) {
//     uid = json['uid'];
//     name = json['name'];
//     nickname = json['nickname'];
//     email = json['email'];
//     weight = json['weight']?.toInt();
//     height = json['height']?.toInt();
//     sex = Sex.toEnum(json['sex']);
//     _regDate = json['regDate'];
//     _dateOfBirth = json['dateOfBirth'];
//     badgeId = json['badgeId'];
//     partyIds = (json['partyIds'] ?? []).cast<String>();
//     collections = toCollections((json['collections'] ?? []).cast<Map<String, dynamic>>());
//     goals = json['goals'] ?? {};
//     inputRecords = json['inputRecords'] ?? {};
//     records = json['records'] ?? {};
//     friendsData = json['friendsData'] ?? {};
//   }
//
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> json = {};
//     json['uid'] = uid;
//     json['name'] = name;
//     json['nickname'] = nickname;
//     json['email'] = email;
//     json['weight'] = weight;
//     json['height'] = height;
//     json['sex'] = sex?.name;
//     json['regDate'] = _regDate;
//     json['dateOfBirth'] = _dateOfBirth;
//     json['badgeId'] = badgeId;
//     json['partyIds'] = partyIds;
//     json['collections'] = collectionsToJsonList(collections);
//     json['goals'] = goals;
//     json['inputRecords'] = inputRecords;
//     json['records'] = records;
//     json['friendsData'] = friendsData;
//     return json;
//   }
//
//   String encode() =>
//       '[{"uid":$uid,"name":$name,"nickname":$nickname,"email":$email,'
//       '"uid":$uid,"name":$name,"nickname":$nickname,"email":$email';
//
//   /// methods
//   List<DateTime> get accessHistory {
//     List<DateTime> dates = [];
//     for (var rec in records[ActivityType.calorie] ?? []) {
//       dates.add(rec['date'].toDate());
//     }
//     return dates;
//   }
//
//   // 기록 추가
//   void addRecord(
//     ActivityType type,
//     DateTime date,
//     Record record, [
//       bool input = false,
//     ]
//   ) {
//     double amount = type == ActivityType.distance
//         ? (record as DistanceRecord).step : record.amount;
//
//     late bool alreadyExist;
//
//     alreadyExist = (inputRecords[type.name] ?? [])
//         .map((rec) => rec['date']).contains(toTimestamp(date));
//
//     if (input) {
//       if (alreadyExist) {
//         for (var rec in inputRecords[type.name] ?? []) {
//           if (rec['date'] == toTimestamp(date)) {
//             rec['amount'] += amount;
//             break;
//           }
//         }
//       }
//       else {
//         inputRecords[type.name] ??= [];
//         inputRecords[type.name].add({
//           'date': toTimestamp(date),
//           'amount': amount,
//         });
//       }
//     }
//
//     alreadyExist = (records[type.name] ?? [])
//         .map((rec) => rec['date']).contains(toTimestamp(date));
//
//     if (alreadyExist) {
//       for (var rec in records[type.name] ?? []) {
//         if (rec['date'] == toTimestamp(date)) {
//           rec['amount'] += amount;
//           break;
//         }
//       }
//     }
//     else {
//       records[type.name] ??= [];
//       records[type.name].add({
//         'date': toTimestamp(date),
//         'amount': amount,
//       });
//     }
//   }
//
//   // 기록 설정
//   void setRecord(
//     ActivityType type,
//     DateTime date,
//     Record record,
//     [ExerciseUnit? unit]
//   ) {
//     for (var rec in records[type.name] ?? []) {
//       if (rec['date'] == toTimestamp(date)) {
//         if (unit != null) record.convert(unit);
//         rec['amount'] = record.amount;
//         return;
//       }
//     }
//
//     records[type.name] ??= [];
//     records[type.name].add({
//     'date': toTimestamp(date),
//     'amount': record.amount,
//     });
//   }
//
//   void duplicateInputRecords() {
//     for (ActivityType type in ActivityType.values) {
//       for (var rec in records[type.name] ?? []) {
//         for (var inputRec in inputRecords[type.name] ?? []) {
//           if (rec['date'] == inputRec['date']) {
//             rec['amount'] += inputRec['amount'];
//           }
//         }
//       }
//     }
//   }
//
//   // 금일 기록 반환
//   double getTodayAmounts(ActivityType type) {
//     return getAmounts(type, today, oneSecondBefore(tomorrow));
//   }
//
//   // 금월 기록 반환
//   double getThisMonthAmounts(ActivityType type) {
//     DateTime firstDate = DateTime((today).year, (today).month, 1);
//     DateTime lastDate = DateTime((today).year, (today).month + 1, 1)
//         .subtract(const Duration(days: 1));
//
//     return getAmounts(type, firstDate, lastDate);
//   }
//
//   // 기록 반환
//   double getAmounts(
//     ActivityType activityType, [
//     DateTime? startDate,
//     DateTime? endDate,
//   ]) {
//     double result = 0;
//
//     inputRecords.forEach((type, recordList) {
//       if (activityType.name == type) {
//         for (var record in recordList) {
//           if (startDate != null && record['date'].toDate().isBefore(startDate)) continue;
//           if (endDate != null && record['date'].toDate().isAfter(endDate)) continue;
//           result += record['amount'].toDouble();
//         }
//       }
//     });
//     records.forEach((type, recordList) {
//       if (activityType.name == type) {
//         for (var record in recordList) {
//           if (startDate != null && record['date'].toDate().isBefore(startDate)) continue;
//           if (endDate != null && record['date'].toDate().isAfter(endDate)) continue;
//           result += record['amount'].toDouble();
//         }
//       }
//     });
//     return result;
//   }
//
//   // 입력된 금일 기록 반환
//   double getTodayInputAmounts(ActivityType activityType) {
//     double result = 0;
//     DateTime startDate = today;
//     DateTime endDate = oneSecondBefore(tomorrow);
//
//     inputRecords.forEach((type, recordList) {
//       if (activityType.name == type) {
//         for (var record in recordList) {
//           if (record['date'].toDate().isBefore(startDate)) continue;
//           if (record['date'].toDate().isAfter(endDate)) continue;
//           result += record['amount'].toDouble();
//         }
//       }
//     });
//     return result;
//   }
//
//   Record? getGoal(ActivityType type) {
//     ExerciseUnit? unit = {
//       ActivityType.distance: ExerciseUnit.step,
//       ActivityType.weight: ExerciseUnit.count,
//     }[type];
//     return Record.init(
//       type, goals[type.name]?.toDouble() ?? .0,
//       unit,
//     );
//   }
//
//   void setGoal(ActivityType type, Record record) {
//     if (type == ActivityType.distance) record.convert(ExerciseUnit.step);
//     if (type == ActivityType.weight) record.convert(ExerciseUnit.count);
//     goals[type.name] = record.amount;
//   }
//
//   // 해당 활동형식의 완료 여부 반환
//   bool completed(ActivityType type) {
//     double goal = goals[type.name];
//     double value = getTodayAmounts(type);
//     return goal <= value;
//   }
//
//   void toggleRival(String uid) {
//     friendsData[uid]['rival'] = !friendsData[uid]['rival'];
//   }
//
//   void addFriend(String uid) {
//     friendsData[uid] = {'rival': false};
//   }
//
//   void deleteFriend(String uid) {
//     friendsData.remove(uid);
//   }
//
//   bool doesFriendExist(String nickname) {
//     for (FUser user in friends) {
//       if (user.nickname == nickname) return true;
//     }
//     return false;
//   }
//
//   /// static variables
//   static int defaultWeight = 60;
//   static int defaultHeight = 170;
//
//   /// static methods
//   static List<Collection> toCollections(List<Map<String, dynamic>> jsonList) {
//     List<Collection> collections = [];
//     for (var json in jsonList) { collections.add(Collection.fromJson(json)); }
//     return collections;
//   }
//
//   static List<Map<String, dynamic>> collectionsToJsonList(List<Collection> collections) {
//     List<Map<String, dynamic>> jsonList = [];
//     for (Collection collection in collections) { jsonList.add(collection.toJson()); }
//     return jsonList;
//   }
// }
