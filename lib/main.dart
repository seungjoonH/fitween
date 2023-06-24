import 'dart:io';

import 'package:camera/camera.dart';
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


const version = 'ver 0.0';
String get versionNumber => version.replaceAll('ver ', '');
const releaseNoteUrl =
    'https://trusted-robe-5cd.notion.site/ad4f1c130b7a45e5a86eac2cc71133d8';

late ConnectivityResult networkResult;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraP.descriptions = await availableCameras();

  await Firebase.initializeApp(
    // name: 'pistachio',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
  runApp(const Fitween());
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
            colorScheme: FTheme.lightColorScheme,
            textTheme: FTheme.textTheme,
            scaffoldBackgroundColor: FTheme.background,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: FTheme.darkGrey,
                size: 20.0.r,
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            // colorScheme: FTheme.darkColorScheme,
            // textTheme: FTheme.textTheme,
            // scaffoldBackgroundColor: FTheme.darkColorScheme.background,
            // appBarTheme: AppBarTheme(
            //   backgroundColor: FTheme.darkColorScheme.background,
            // ),
          ),
          // home: const DeveloperPage(),
          home: const LoginPage(),
          getPages: FRoute.getPages,
        );
      },
    );
  }
}
