import 'package:carousel_slider/carousel_controller.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class WeightGuidePageCont extends CarouselPageCont {
  static WeightGuidePageCont get to => Get.find<WeightGuidePageCont>();

  final _carouselCont = CarouselController();

  @override
  CarouselController get carouselCont => _carouselCont;

  @override
  int get pageCount => 6;

  final _exercise = Rx<Exercise?>(null);
  Exercise? get exercise => _exercise.value;

  String get dir => 'assets/image/page/contents/weight/${exercise!.name}/';
  List<String> get assets => List.generate(pageCount, (i) => '${dir}carousel_$i.gif');


  @override
  Future load() async {
    _exercise.value = Get.arguments as Exercise;
  }

  @override
  String get loadKey => 'weight';

}