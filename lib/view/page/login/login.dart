import 'dart:async';
import 'dart:io' show Platform;
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/page/login.dart';
import 'package:fitween/view/widget/widget/tag.dart';
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
    super.initState();

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
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    GlobalP.setIsTablet(size);

    return Scaffold(
      backgroundColor: FTheme.white,
      body: GetBuilder<LoginP>(
        builder: (loginP) {
          String text = loginP.loadPercent < 1.0
              ? '로딩 중${'.' * pointCount}' : '  완료!';

          return Stack(
            alignment: Alignment.center,
            children: [
              // const FLogo(),
              const FAppIcon(),
              if (loginP.loading) Positioned(
                bottom: 80.0.h,
                child: SizedBox(
                  width: size.width * .9,
                  child: LinearPercentIndicator(
                    percent: loginP.loadPercent,
                    lineHeight: 40.0.h,
                    backgroundColor: FTheme.background,
                    barRadius: const Radius.circular(10.0),
                    progressColor: FTheme.colorA,
                    animation: true,
                    animationDuration: 200,
                    animateFromLastPercent: true,
                    curve: Curves.linear,
                    center: FText(text,
                      style: textTheme(context).labelLarge,
                      color: FTheme.darkGrey,
                      bold: loginP.loadPercent == 1.0,
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
                      SizedBox(height: 20.0.h),
                      if (Platform.isIOS)
                        const SignInButton(type: LoginType.apple),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 25.0.w,
                bottom: 15.0.h,
                child: const FTag(version),
              ),
            ],
          );
        }
      ),
    );
  }
}