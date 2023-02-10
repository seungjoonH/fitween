import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:fitween/firebase_options.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/firebase/auth/auth.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/import.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:fitween/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitween/view/page/login/login.dart';

const version = 'ver 0.0';
String get versionNumber => version.replaceAll('ver ', '');
const releaseNoteUrl = 'https://trusted-robe-5cd.notion.site/ad4f1c130b7a45e5a86eac2cc71133d8';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraPresenter.descriptions = await availableCameras();

  await Firebase.initializeApp(
    // name: 'pistachio',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Fitween());
}

class Fitween extends StatefulWidget {
  const Fitween({Key? key}) : super(key: key);

  @override
  State<Fitween> createState() => _PistachioState();
}

class _PistachioState extends State<Fitween> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(milliseconds: 500),
        AuthPresenter.loadLoginData,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    setTimeError();
    GlobalPresenter.initControllers();
    ImportPresenter.importData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          enableLog: false,
          title: 'Pistachio',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: ThemeData(
            colorScheme: PTheme.lightColorScheme,
            textTheme: PTheme.textTheme,
            scaffoldBackgroundColor: PTheme.lightColorScheme.background,
            appBarTheme: AppBarTheme(
              backgroundColor: PTheme.lightColorScheme.background,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: PTheme.darkColorScheme,
            textTheme: PTheme.textTheme,
            scaffoldBackgroundColor: PTheme.darkColorScheme.background,
            appBarTheme: AppBarTheme(
              backgroundColor: PTheme.darkColorScheme.background,
            ),
          ),
          // home: const DeveloperPage(),
          home: const LoginPage(),
          getPages: PRoute.getPages,
        );
      },
    );
  }
}