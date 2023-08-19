import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/user/sign_in.dart';
import 'package:fitween/src/controller/user/storage.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/abs/page.dart';

class AuthCont {
  static FUserInfoBuilder? stranger;
  static FUser? _logged;

  static bool get isLogged => _logged != null;
  static FUser? get logged => _logged;
  static String? get uid => _logged?.key;

  static void setUser(FUser user) => _logged = user;

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

    _logged = await FUserDAO().loadOneAll(loadedUid);
    bool isNewcomer = _logged == null;

    if (isNewcomer) {
      stranger = FUserInfoBuilder()
        ..uid = loadedUid
        ..name = name
        ..email = email;

      FRoute.toOnboarding(); return;
    }

    FRoute.toHome();
  }
}
