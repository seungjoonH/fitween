import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/health/health.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';

class AuthCont {
  static FUserInfoBuilder? stranger;
  static FUser? _logged;

  static bool get isLogged => _logged != null;
  static FUser? get logged => _logged;
  static String? get uid => _logged?.key;

  static LoginPageCont get loginPageCont => LoginPageCont.to;

  static Future reloadFromDB() async {
    _logged = await FUserDAO().loadOneAll(uid!);
  }

  static void setUser(FUser user) => _logged = user;
  static void setUserRecord(FUserRecord record) {
    _logged!.record = record;
    _logged!.record!.info = _logged!.info;
  }

  static fLogin(LoginType type) async {
    String? loadedUid = await StorageCont.load();
    String? name;
    late String email;

    if (loadedUid == null) {
      UserCredential? credential = await SignCont.signIn(type);

      // 로그인 실패
      if (credential == null) return;

      loadedUid = credential.user!.uid;
      name = credential.user!.displayName;
      email = credential.user!.email!;
    }

    HealthDataCont.requestPermission();

    loginPageCont.startLoading();

    _logged = await FUserDAO().loadOneAll(loadedUid);
    loginPageCont.p = .7;

    bool isNewcomer = _logged == null;

    if (isNewcomer) {
      stranger = FUserInfoBuilder()
        ..uid = loadedUid
        ..name = name
        ..email = email;

      FRoute.toOnboarding(); return;
    }

    await HealthDataCont.fetchDataAfterLogin();
    loginPageCont.p = .95;

    Timer.periodic(10.ms, (timer) {
      if (!loginPageCont.loading) {
        FRoute.toHome();
        timer.cancel(); return;
      }
    });
  }
}
