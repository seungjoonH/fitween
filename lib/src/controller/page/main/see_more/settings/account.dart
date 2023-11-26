import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/login.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:get/get.dart';

class AccountPageCont extends PageCont {
  static AccountPageCont get to => Get.find<AccountPageCont>();

  String get appBarTitle => LangCont.tr('appbar.account');

  User get user => AuthCont.credential!.user!;

  String? get imageUrl => user.photoURL;
  String get name => user.displayName!;
  String get email => user.email!;

  LoginType get type => AuthCont.loginType;

  String get autoLoginText => LangCont.tr('account.auto-login');

  final _autoLoginAllowed = true.obs;
  bool get autoLoginAllowed => _autoLoginAllowed.value;

  void onChanged() {
    _autoLoginAllowed(!autoLoginAllowed);
    _saveAutoLoginState();
  }

  void _saveAutoLoginState() async {
    _logged.info!.setAutoLoginState(autoLoginAllowed);
    await FUserInfoDAO().saveOne(_logged.info!);
  }

  String get logoutButtonText => LangCont.tr('button.logout');
  String get deleteAccountButtonText => LangCont.tr('button.delete-account');

  String get _dialogTr => 'account.dialog';

  String get logoutReallyTitle => LangCont.tr('$_dialogTr.logout.really-title');
  String get logoutReallyText => LangCont.tr('$_dialogTr.logout.really-text');
  String get deleteAccountReallyTitle => LangCont.tr('$_dialogTr.delete-account.really-title');
  String get deleteAccountReallyText => LangCont.tr('$_dialogTr.delete-account.really-text');

  String get loggedOutTitle => LangCont.tr('$_dialogTr.logout.complete-title');
  String get loggedOutText => LangCont.tr('$_dialogTr.logout.complete-text');
  String get accountDeletedTitle => LangCont.tr('$_dialogTr.delete-account.complete-title');
  String get accountDeletedText => LangCont.tr('$_dialogTr.delete-account.complete-text');

  void logoutButtonPressed() {
    showFDialog(
      title: logoutReallyTitle,
      content: FText(logoutReallyText, maxLines: 0),
      type: DialogType.bi,
      rightText: logoutButtonText,
      rightTextColor: ThemeCont.achro95,
      rightBackgroundColor: ThemeCont.error,
      rightPressed: _logout,
    );
  }

  void deleteAccountButtonPressed() {
    showFDialog(
      title: deleteAccountReallyTitle,
      content: FText(deleteAccountReallyText, maxLines: 0),
      type: DialogType.bi,
      rightText: deleteAccountButtonText,
      rightTextColor: ThemeCont.achro95,
      rightBackgroundColor: ThemeCont.error,
      rightPressed: _deleteAccount,
    );
  }

  void _logout() async {
    await showFDialog(
      title: loggedOutTitle,
      content: FText(loggedOutText, maxLines: 0),
      type: DialogType.mono,
    );

    AuthCont.fLogout();
    FRoute.toLogin();
  }
  void _deleteAccount() async {
    await showFDialog(
      title: accountDeletedTitle,
      content: FText(accountDeletedText, maxLines: 0),
      type: DialogType.mono,
    );

  }

  FUser get _logged => AuthCont.logged!;

  @override
  Future load() async {
    _autoLoginAllowed(_logged.autoLoginAllowed);
  }

  @override
  String get loadKey => 'account';

}