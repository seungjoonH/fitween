import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class WeightPageCont extends PageCont {
  static WeightPageCont get to => Get.find<WeightPageCont>();

  String get appBarTitle => LangCont.tr('appbar.weight');
  String get exerciseText => LangCont.tr('word.exercise').capitalize!;

  void exerciseButtonPressed(Exercise exercise) {
    FRoute.toWeightGuide(exercise: exercise);
  }

  @override
  Future load() async {}

  @override
  String get loadKey => 'weight';
}