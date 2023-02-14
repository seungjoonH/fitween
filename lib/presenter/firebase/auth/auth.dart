import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:fitween/main.dart';
import 'package:fitween/model/class/database/user.dart';
import 'package:fitween/model/enum/login_type.dart';
import 'package:fitween/presenter/firebase/auth/apple.dart';
import 'package:fitween/presenter/firebase/auth/google.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
import 'package:fitween/presenter/model/badge.dart';
import 'package:fitween/presenter/model/user.dart';
import 'package:fitween/presenter/page/home.dart';
import 'package:fitween/presenter/page/login.dart';
import 'package:fitween/presenter/page/onboarding.dart';

class AuthPresenter {
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
  static Future pLogin(LoginType type) async {
    final userP = Get.find<UserPresenter>();

    UserCredential? userCredential;
    Map<String, dynamic>? json;

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

    // 파이어베이스 데이터
    json = (await f.collection('users').doc(userCredential.user!.uid).get()).data();

    // 파이어베이스에 문서가 없거나 json 데이터에 닉네임이 없을 경우 신규 회원
    bool isNewcomer = json == null || json['nickname'] == null;

    Map<String, dynamic> data = {};
    data['uid'] = userCredential.user!.uid;
    data['name'] = userCredential.user!.displayName ?? appleName;
    data['email'] = userCredential.user!.email;

    userP.data = {...data};

    // 신규 회원일 경우
    if (isNewcomer) {
      // 회원가입 페이지로 이동
      OnboardingP.toOnboarding();
    }

    // 기존 회원일 경우
    else {
      // 파이어베이스 데이터로 로그인
      PUser stranger = PUser.fromJson(json);
      await userP.login(stranger);
      await storeLoginData(userP.data);
      await HomePresenter.toHome();
    }

    await BadgePresenter.synchronizeBadges();
  }

  // 피트윈 로그아웃
  static void pLogout() {
    final userP = Get.find<UserPresenter>();
    Get.offAllNamed('/login');
    userP.logout();
    eliminateLoginData(userP.data);
  }

  // 피트윈 계정삭제
  static void pDeleteAccount() {
    final userP = Get.find<UserPresenter>();
    userP.delete();
    pLogout();
  }

  static void loadLoginData() async {
    final userP = Get.find<UserPresenter>();

    String? userInfo = await storage.read(key: 'login');
    bool beenLogged = userInfo != null;

    if (!await AuthPresenter.versionCheck()) {
      LoginPresenter.showVersionInvalidDialog();
      return;
    }

    // 자동 로그인
    if (!beenLogged) return;

    userP.data = jsonDecode(userInfo);
    userP.loggedUser.uid = userP.data['uid'];
    await userP.load();
    HomePresenter.toHome();
  }

  // 로그인 데이터 전송
  static Future storeLoginData(Map<String, dynamic> data) async {
    await storage.write(
      key: 'login',
      value: jsonEncode(data),
    );
  }

  // 로그인 데이터 삭제
  static Future eliminateLoginData(Map<String, dynamic> data) async {
    await storage.delete(key: 'login');
  }
}
