import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:flutter/material.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    Get.put(ThemeCont());
    Get.put(LangCont());

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
          locale: LangCont.to.getLocale ?? context.locale,
          theme: ThemeData(
            textTheme: ThemeCont.to.textTheme,
            scaffoldBackgroundColor: ThemeCont.to.background,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: ThemeCont.to.text,
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
