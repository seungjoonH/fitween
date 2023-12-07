import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/health/health.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthCont {
  static FUserInfoBuilder? stranger;
  static FUser? _logged;

  static bool get isLogged => _logged != null;
  static FUser? get logged => _logged;
  static String? get uid => _logged?.key;

  static LoginPageCont get loginPageCont => LoginPageCont.to;
  static User? _credentialUser;

  static String? _imageUrl;
  static String? _name;
  static String? _email;
  static String get imageUrl => _imageUrl!;
  static String get name => _name!;
  static String get email => _email!;

  static LoginType? _loginType;
  static LoginType? get loginType => _loginType;

  static void setUser(FUser user) => _logged = user;
  static void updateUser(FUser user) => _logged!.merge(user);

  static Future _initAfterLogin() async {
    ThemeCont.to.init();
    LangCont.to.init();

    init();

    Timer.periodic(10.ms, (timer) async {
      if (!loginPageCont.loading) {
        timer.cancel();
        loginPageCont.startLoading('home');
        await BottomBarCont.to.navigate(0);
        await loginPageCont.endLoading();
        await FBadgeCont.to.earnBadge('1000000');
        return;
      }
    });
  }

  static bool _loggingIn = false;

  static void init() => _loggingIn = false;

  static void fAutoLogin() async {
    if (_loggingIn) return;
    _loggingIn = true;

    Map<String, dynamic>? data = await StorageCont.load();
    if (data == null) return;

    String? uid = data['uid'];
    _loginType = LoginType.toEnum(data['loginType']);
    _imageUrl = data['photoURL'];
    _name = data['displayName'];
    _email = data['email'];

    if (uid == null) { init(); return; }
    FUser? stranger = await FUserDAO().loadOne(data['uid']);
    if (stranger == null) return;
    if (!stranger.autoLoginAllowed) return;

    loginPageCont.startLoading('auto-login');
    _logged = await FUserDAO().loadOneAll(data['uid']);
    await loginPageCont.endLoading();

    await _initAfterLogin();
  }

  static void fLogin(LoginType type) async {
    // if (_loggingIn) return;
    // _loggingIn = true;

    UserCredential? credential = await SignCont.signIn(type);

    // 로그인 실패
    if (credential == null) { init(); return; }

    _credentialUser = credential.user!;

    String uid = _credentialUser!.uid;
    _imageUrl = _credentialUser!.photoURL;
    _name = _credentialUser!.displayName;
    _email = _credentialUser!.email!;

    HealthDataCont.requestPermission();

    loginPageCont.startLoading('user');
    _logged = await FUserDAO().loadOneAll(uid);
    await loginPageCont.endLoading();

    bool isNewcomer = _logged == null;

    if (isNewcomer) {
      stranger = FUserInfoBuilder()
        ..uid = uid
        ..name = name
        ..email = email;

      FRoute.toOnboarding();
      init();
      return;
    }

    _loginType = type;

    await StorageCont.store({
      'uid': uid,
      'loginType': type.name,
      'photoURL': _credentialUser!.photoURL,
      'displayName': _credentialUser!.displayName,
      'email': _credentialUser!.email,
    });

    await _initAfterLogin();
  }

  static void fLogout() {
    stranger = null;
    _logged = null;
    _credentialUser = null;
    init();
    StorageCont.eliminate();
    LoadingCont.clearQueue();
  }
  static void fDeleteAccount() {/* not-implemented */}

  static const storage = FlutterSecureStorage();

  static Future load(FUserLoadCont cont) async {
    FUser? loaded = await FUserDAO().loadOne(uid!, cont: cont);
    if (loaded == null) throw Exception('User load failed');
    updateUser(loaded);
  }
}
