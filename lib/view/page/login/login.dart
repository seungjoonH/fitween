import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/main.dart';
import 'package:fitween/model/enum/login_type.dart';
import 'package:fitween/view/page/login/widget.dart';
import 'package:fitween/view/widget/widget/logo.dart';
import 'package:fitween/view/widget/widget/text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double backgroundOpacity;
  late double buttonsOpacity;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    const backgroundAsset = 'assets/image/page/login/background.svg';

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: screenSize.aspectRatio,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              opacity: backgroundOpacity,
              child: SvgPicture.asset(backgroundAsset, fit: BoxFit.fill),
            ),
          ),
          Positioned(top: 150.0.h, child: const PLogo()),
          Positioned(
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
              color: FTheme.grey,
              style: textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}