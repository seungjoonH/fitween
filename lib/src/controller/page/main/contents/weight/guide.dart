import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class WeightGuidePageCont extends CarouselPageCont {
  static WeightGuidePageCont get to => Get.find<WeightGuidePageCont>();

  String get appBarTitle => exercise?.locale.capitalize! ?? '';

  final _carouselCont = CarouselController();

  @override
  CarouselController get carouselCont => _carouselCont;

  @override
  int get pageCount => 7;

  final _exercise = Rx<Exercise?>(null);
  Exercise? get exercise => _exercise.value;

  String get dir => 'assets/image/page/contents/weight/${exercise!.name}/guide/${LangCont.locale}';
  List<String> get assets => List.generate(pageCount, (i) => '$dir/carousel_$i.gif');

  List<String> get messages => List.generate(pageCount, (index) {
    return LangCont.tr('weight-guide.squat.$index');
  });

  List<int> getSpacePositions(String text) {
    List<int> list = [];
    for (int i = 0; i < text.length; i++) {
      if (text[i] == ' ') list.add(i);
    }
    return list;
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) => pageIndex = index;

  String get okButtonText => LangCont.tr('button.ok');

  void skipButtonPressed() => FRoute.toWeightCamera(exercise: exercise);
  void okButtonPressed() => FRoute.toWeightCamera(exercise: exercise);

  @override
  Future load() async {
    _exercise(Get.arguments as Exercise);
    await delay(10.ms, () {
      pageIndex = 0;
      carouselCont.jumpToPage(pageIndex);
    });
  }

  @override
  String get loadKey => 'weight';

}