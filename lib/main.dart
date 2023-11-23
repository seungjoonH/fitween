import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitween/fitween.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/firebase_options.dart';
import 'package:fitween/src/model/class/exercise.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:connectivity/connectivity.dart';

const version = 'ver 2.0.0a1';
String get versionNumber => version.replaceAll('ver ', '');
const supportEmail = 'fitween.corp@gmail.com';

late ConnectivityResult networkResult;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraCont.descriptions = await availableCameras();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    // name: 'fitween',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting();
  runApp(LangCont.equipLocalization(const Fitween()));
}

