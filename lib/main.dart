import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitween/fitween.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/firebase_options.dart';
import 'package:fitween/src/model/class/exercise.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

const version = 'ver 2.0.2';
String get versionNumber => version.replaceAll(RegExp('ver |a|b'), '');
const supportEmail = 'fitween.corp@gmail.com';

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

