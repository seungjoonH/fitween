import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class FPointPageCont extends PageCont {
  static FPointPageCont get to => Get.find<FPointPageCont>();

  static FPointCont get pointCont => FPointCont.to;

  String get appBarTitle => LangCont.tr('appbar.fpoint');

  final _fPoint = 0.obs;
  int get fPoint => _fPoint.value;

  void animateFPoint(int fp) async {
    _fPoint(0);
    await delay(20.ms, () => _fPoint(fp ~/ 1000));
    await delay(20.ms, () => _fPoint(fp ~/ 100));
    await delay(20.ms, () => _fPoint(fp ~/ 10));
    await delay(20.ms, () => _fPoint(fp));
  }

  @override
  Future load() async {
    await pointCont.load();
    animateFPoint(pointCont.fPoint);
  }

  @override
  String get loadKey => 'fpoint';

}