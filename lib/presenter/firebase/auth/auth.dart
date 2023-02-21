import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitween/model/class/database/user/collection.dart';
import 'package:fitween/model/class/database/user/friend.dart';
import 'package:fitween/model/class/database/user/info.dart';
import 'package:fitween/model/class/database/user/notification.dart';
import 'package:fitween/model/class/database/user/party.dart';
import 'package:fitween/model/class/database/user/record.dart';
import 'package:fitween/presenter/model/user/collection.dart';
import 'package:fitween/presenter/model/user/friend.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:fitween/presenter/model/user/party.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:fitween/main.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/enum/login_type.dart';
import 'package:fitween/presenter/firebase/auth/apple.dart';
import 'package:fitween/presenter/firebase/auth/google.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/page/home.dart';
import 'package:fitween/presenter/page/login.dart';
import 'package:fitween/presenter/page/onboarding.dart';

class AuthPresenter {
  static final userCollectionP = Get.find<UserCollectionP>();
  static final userFriendP = Get.find<UserFriendP>();
  static final userInfoP = Get.find<UserInfoP>();
  static final userNotificationP = Get.find<UserNotificationP>();
  static final userPartyP = Get.find<UserPartyP>();
  static final userRecordP = Get.find<UserRecordP>();

  static const List<String> developerUids = [
    'sLc4rerF1Xg41rclmmfqgc7jlAa2', // 현승준
    'F02JAQ4Cdbb2w7AaCf9VJz9fqs52', // 현승준
    '09zhHKukWhaK2MlwJMJoOVFq7D23', // 정윤석
    'e3Ei6k4c9TSZrNzzfUZCLXtbqRB3', // 정윤석
    'AEROyVDTr2P04e2GD0x2Js6ejN42', // 이하준
    'OelnDbcyH8dXR04DkWpbfaXtjVN2', // 최복원
    '8VQFtwpLhqNThjhYNuizKWo7vlK2', // 한상윤
  ];
  static const storage = FlutterSecureStorage();
  static String? appleName;

  /// static methods
  static Future<bool> versionCheck() async {
    var json = (await f.collection('versions').doc(versionNumber).get()).data();
    return json != null && json['available'];
  }

  // 로그인 형식에 따른 피트윈 로그인
  static Future fLogin(LoginType type) async {
    UserCredential? userCredential;
    Map<String, dynamic>? jsonCollection;
    Map<String, dynamic>? jsonFriend;
    Map<String, dynamic>? jsonInfo;
    Map<String, dynamic>? jsonNotification;
    Map<String, dynamic>? jsonParty;
    Map<String, dynamic>? jsonRecord;

    // 로그인 형식에 따른 로그인 방식
    switch (type) {
      case LoginType.google:
        userCredential = await GoogleAuth.signInWithGoogle();
        break;
      case LoginType.apple:
        userCredential = await AppleAuth.signInWithApple();
        break;
    }

    if (userCredential == null) return;
    String uid = userCredential.user!.uid;

    // 파이어베이스 데이터
    jsonCollection = (await UserCollectionP.collection
        .doc(uid).get()).data() ?? {};
    jsonFriend = (await UserFriendP.collection
        .doc(uid).get()).data() ?? {};
    jsonInfo = (await UserInfoP.collection
        .doc(uid).get()).data();
    jsonNotification = (await UserNotificationP.collection
        .doc(uid).get()).data() ?? {};
    jsonParty = (await UserPartyP.collection
        .doc(uid).get()).data() ?? {};
    jsonRecord = (await UserRecordP.collection
        .doc(uid).get()).data() ?? {};

    // 파이어베이스에 문서가 없거나 json 데이터에 닉네임이 없을 경우 신규 회원
    bool isNewcomer = jsonInfo == null
        || jsonInfo['nickname'] == null;

    Map<String, dynamic> data = {};
    data['uid'] = userCredential.user!.uid;
    data['name'] = userCredential.user!.displayName ?? appleName;
    data['email'] = userCredential.user!.email;

    userInfoP.data = {...data};

    Map<String, dynamic> uidJson = {'uid': data['uid']};
    jsonCollection ??= uidJson;
    jsonFriend ??= uidJson;
    jsonNotification ??= uidJson;
    jsonParty ??= uidJson;
    jsonRecord ??= uidJson;

    // 신규 회원일 경우
    if (isNewcomer) {
      // 회원가입 페이지로 이동
      OnboardingP.toOnboarding();
    }

    // 기존 회원일 경우
    else {
      // 파이어베이스 데이터로 로그인
      FUserCollection strangerCollection = FUserCollection.fromJson(jsonCollection);
      FUserFriend strangerFriend = FUserFriend.fromJson(jsonFriend);
      FUserInfo strangerInfo = FUserInfo.fromJson(jsonInfo);
      FUserNotification strangerNotification = FUserNotification.fromJson(jsonNotification);
      FUserParty strangerParty = FUserParty.fromJson(jsonParty);
      FUserRecord strangerRecord = FUserRecord.fromJson(jsonRecord);

      await userCollectionP.login(strangerCollection);
      await userFriendP.login(strangerFriend);
      await userInfoP.login(strangerInfo);
      await userNotificationP.login(strangerNotification);
      await userPartyP.login(strangerParty);
      await userRecordP.login(strangerRecord);

      await storeLoginData(userInfoP.data);
      await HomeP.toHome();
    }

    await BadgePresenter.synchronizeBadges();
  }

  // 피트윈 로그아웃
  static void fLogout() {
    Get.offAllNamed('/login');
    userCollectionP.logout();
    userFriendP.logout();
    userInfoP.logout();
    userNotificationP.logout();
    userPartyP.logout();
    userRecordP.logout();
    eliminateLoginData(/*userInfoP.data*/);
  }

  // 피트윈 계정삭제
  static void fDeleteAccount() {
    userCollectionP.delete();
    userFriendP.delete();
    userInfoP.delete();
    userNotificationP.delete();
    userPartyP.delete();
    userRecordP.delete();
    fLogout();
  }

  static void loadLoginData() async {
    String? userInfo = await storage.read(key: 'login');
    bool beenLogged = userInfo != null;

    if (!await AuthPresenter.versionCheck()) {
      LoginPresenter.showVersionInvalidDialog();
      return;
    }

    // 자동 로그인
    if (!beenLogged) return;

    userInfoP.data = jsonDecode(userInfo);
    String uid = userInfoP.data['uid'];

    userCollectionP.loggedUser.uid = uid;
    userFriendP.loggedUser.uid = uid;
    userInfoP.loggedUser.uid = uid;
    userNotificationP.loggedUser.uid = uid;
    userPartyP.loggedUser.uid = uid;
    userRecordP.loggedUser.uid = uid;

    await userCollectionP.load();
    await userFriendP.load();
    await userInfoP.load();
    await userNotificationP.load();
    await userPartyP.load();
    await userRecordP.load();

    HomeP.toHome();
  }

  // 로그인 데이터 전송
  static Future storeLoginData(Map<String, dynamic> data) async {
    await storage.write(
      key: 'login',
      value: jsonEncode(data),
    );
  }

  // 로그인 데이터 삭제
  static Future eliminateLoginData(/*Map<String, dynamic> data*/) async {
    await storage.delete(key: 'login');
  }
}
