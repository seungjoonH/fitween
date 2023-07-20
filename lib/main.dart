import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/presenter/page/login.dart';
import 'package:fitween/route.dart';
import 'package:fitween/view/page/login/login.dart';
import 'package:fitween/firebase_options.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/import.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:connectivity/connectivity.dart';


const version = 'ver 1.0.2';
String get versionNumber => version.replaceAll('ver ', '');

late ConnectivityResult networkResult;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraP.descriptions = await availableCameras();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    // name: 'fitween',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting();

  runApp(
    EasyLocalization(
      supportedLocales: ['en', 'ko'].map((l) => Locale(l)).toList(),
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const Fitween(),
    ),
  );
}

class Fitween extends StatefulWidget {
  const Fitween({Key? key}) : super(key: key);

  @override
  State<Fitween> createState() => _FitweenState();
}

class _FitweenState extends State<Fitween> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      networkResult = await Connectivity().checkConnectivity();

      Future.delayed(
        const Duration(milliseconds: 500), () async {
          if (networkResult == ConnectivityResult.none) {
            LoginP.showNetworkErrorDialog();
            return;
          }
          if (!await AuthP.versionCheck()) {
            LoginP.showVersionInvalidDialog();
            return;
          }
          AuthP.loadLoginData();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) setTimeError();

    GlobalP.initControllers();
    ImportPresenter.importData();

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          enableLog: false,
          title: 'Fitween',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: ThemeData(
            textTheme: FTheme.textTheme,
            scaffoldBackgroundColor: FTheme.background,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: FTheme.darkGrey,
                size: 25.0.r,
              ),
            ),
          ),
          // home: const DeveloperPage(),
          home: const LoginPage(),
          getPages: FRoute.getPages,
        );
      },
    );
  }
}
