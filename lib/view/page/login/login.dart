import 'dart:async';
import 'dart:io' show Platform;
import 'package:fitween/presenter/page/home/home.dart';
import 'package:fitween/presenter/page/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/main.dart';
import 'package:fitween/model/enum/login_type.dart';
import 'package:fitween/view/page/login/widget.dart';
import 'package:fitween/view/widget/widget/logo.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double backgroundOpacity;
  late double buttonsOpacity;

  Timer? timer;
  int pointCount = 0;

  @override
  void initState() {
    backgroundOpacity = .0;
    buttonsOpacity = .0;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => backgroundOpacity = 1.0);
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => buttonsOpacity = 1.0);
    });

    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => pointCount = (pointCount + 1) % 4);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FTheme.white,
      body: GetBuilder<LoginP>(
        builder: (loginP) {
          String text = loginP.loadPercent < 1.0
              ? '로딩 중${'.' * pointCount}' : '  완료!';

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(top: 300.0.h, child: const FLogo()),
              if (loginP.loading) Positioned(
                bottom: 130.0.h,
                child: SizedBox(
                  width: HomeP.screenSize.width * .9,
                  child: LinearPercentIndicator(
                    percent: loginP.loadPercent,
                    lineHeight: 40.0,
                    backgroundColor: FTheme.background,
                    barRadius: const Radius.circular(10.0),
                    progressColor: FTheme.colorA,
                    animation: true,
                    animationDuration: 200,
                    animateFromLastPercent: true,
                    curve: Curves.linear,
                    center: Container(
                      width: 60.0,
                      alignment: Alignment.centerLeft,
                      child: FText(text,
                        style: textTheme.labelLarge,
                        color: FTheme.darkGrey,
                        bold: loginP.loadPercent == 1.0,
                      ),
                    ),
                  ),
                ),
              ) else Positioned(
                bottom: 130.0.h,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  opacity: buttonsOpacity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SignInButton(type: LoginType.google),
                      const SizedBox(height: 20.0),
                      if (Platform.isIOS)
                        const SignInButton(type: LoginType.apple),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 25.0.w,
                bottom: 15.0.h,
                child: FText(
                  version,
                  color: FTheme.darkGrey,
                  style: textTheme.titleMedium,
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}