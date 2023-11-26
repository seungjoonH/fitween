import 'dart:io';

import 'package:fitween/global/global.dart';
import 'package:fitween/main.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

enum LoginType {
  google, apple;
  String get locale => LangCont.tr('word.$name');
  String get signIn => LangCont.tr('button.sign-in', args: [locale.capitalize!]);

  Color get color => [ThemeCont.google, ThemeCont.apple][index];

  static LoginType? toEnum(String? string) =>
      values.firstWhereOrNull((type) => type.name == string);
}

class LoginPage extends FPage {
  const LoginPage({super.key});

  @override
  FPageState createState() => _LoginPageState();
}

class _LoginPageState extends FPageState {

  @override
  LoginPageCont get cont => LoginPageCont.to;

  Widget _buildProgramLoadingIndicatorWidget(BuildContext context) {
    return Obx(() => FLinearPercentIndicator(
      percent: cont.p,
      backgroundColor: ThemeCont.to.background,
      progressColor: ThemeCont.colorA,
      centerText: cont.loadingText,
    ));
  }

  Widget _buildSignInButtonWidget(BuildContext context) {
    return AnimatedOpacity(
      duration: 500.ms,
      curve: Curves.easeInOut,
      opacity: cont.buttonsOpacity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SignInButton(type: LoginType.google),
          SizedBox(height: 20.0.h),
          if (Platform.isIOS)
          const SignInButton(type: LoginType.apple),
        ],
      ),
    );
  }

  Widget _buildPortraitBody(BuildContext context) {
    return const Center(child: FAppIcon());
  }

  Widget _buildLandscapeBody(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [ FAppIcon(), SizedBox() ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return PageCont.isPortrait
        ? _buildPortraitBody(context)
        : _buildLandscapeBody(context);
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return Obx(() => FScaffold(
      backgroundColor: ThemeCont.to.backgroundAlt,
      body: _buildBody(context),
      bottomWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(child: SizedBox()),
          cont.loading
              ? _buildProgramLoadingIndicatorWidget(context)
              : _buildSignInButtonWidget(context),
          SizedBox(height: 50.0.h),
          const FTextTag(version),
        ],
      ),
      bottomPadding: 30.0.h,
    ));
  }
}


class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
    required this.type,
  }) : super(key: key);

  final LoginType type;

  LoginPageCont get cont => LoginPageCont.to;

  String get _logoAsset => 'assets/image/logo/${type.name}.svg';

  Color get _backgroundColor => {
    LoginType.google: ThemeCont.achro95,
    LoginType.apple: ThemeCont.achro5,
  }[type]!;

  Color get _textColor => {
    LoginType.google: ThemeCont.achro5,
    LoginType.apple: ThemeCont.achro95,
  }[type]!;

  void _onPressed() => cont.onPressed(type);

  @override
  Widget build(BuildContext context) {
    return FButton(
      border: true,
      stretch: true,
      onPressed: _onPressed,
      backgroundColor: _backgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              _logoAsset,
              width: 23.0.r,
              height: 23.0.r,
            ),
            SizedBox(width: 10.0.w),
            FText(
              type.signIn,
              style: ThemeCont.to.titleSmall,
              color: _textColor,
            ),
          ],
        ),
      ),
    );
  }
}
