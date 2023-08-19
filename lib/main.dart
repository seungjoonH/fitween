import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/get.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/firebase_options.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/class/local.dart';
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
  // CameraP.descriptions = await availableCameras();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    // name: 'fitween',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting();
  runApp(LangCont.equipLocalization(const Fitween()));
}

class Fitween extends StatefulWidget {
  const Fitween({Key? key}) : super(key: key);

  @override
  State<Fitween> createState() => _FitweenState();
}

class _FitweenState extends State<Fitween> {
  get _instance => WidgetsBinding.instance;

  void initialSetting(Duration _) async {
    await LocalModel.loadAll();
    //   networkResult = await Connectivity().checkConnectivity();
    //
    //   delay(500.ms, () async {
    //     if (networkResult == ConnectivityResult.none) {
    //       DialogCont.showNetworkErrorDialog();
    //       return;
    //     }
    //     if (!await AuthP.versionCheck()) {
    //       DialogCont.showVersionInvalidDialog();
    //       return;
    //     }
    //     AuthP.loadLoginData();
    //   });
  }

  @override
  void initState() {
    super.initState();
    _instance.addPostFrameCallback(initialSetting);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) setTimeError();
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        PageCont.context = context;
        PageCont.mediaQuery = MediaQuery.of(context);
        return GetMaterialApp(
          enableLog: false,
          title: 'Fitween',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            textTheme: FTheme.textTheme,
            scaffoldBackgroundColor: FTheme.background,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: FTheme.text,
                size: 25.0.r,
              ),
            ),
          ),
          initialBinding: BindingsBuilder(GetCont.initConts),
          getPages: FRoute.getPages,
        );
      },
    );
  }
}
