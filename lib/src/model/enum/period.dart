import 'package:fitween/src/controller/controller.dart';

enum Period {
  daily, weekly, monthly;
  String get locale => LangCont.tr('period.$name');
}