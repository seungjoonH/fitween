import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class MyInfoPageCont extends PageCont {
  static MyInfoPageCont get to => Get.find<MyInfoPageCont>();

  String get appBarTitle => LangCont.tr('appbar.my-info');

  String get heightText => LangCont.tr('word.height');
  String get weightText => LangCont.tr('word.weight');
  String get goalText => LangCont.tr('word.goal');

  RegisterPageCont get registerCont => RegisterPageCont.to;

  final _weightSettable = false.obs;
  final _heightSettable = false.obs;

  bool get weightSettable => _weightSettable.value;
  bool get heightSettable => _heightSettable.value;

  void toggleWeightSettingState() async {
    _weightSettable(!weightSettable);
    await _syncTo();
  }
  void toggleHeightSettingState() async {
    _heightSettable(!heightSettable);
    await _syncTo();
  }

  final _height = Rx<int?>(null);
  final _weight = Rx<int?>(null);

  int? get height => _height.value?.toInt();
  int? get weight => _weight.value?.toInt();

  int get heightMin => registerCont.heightMin;
  int get heightMax => registerCont.heightMax;
  int get weightMin => registerCont.weightMin;
  int get weightMax => registerCont.weightMax;

  FUser get _logged => AuthCont.logged!;

  void onHeightChanged(int v) => _height(v);
  void onWeightChanged(int v) => _weight(v);

  String getGoalTextOf(FType type) {
    num goal = _logged.goal.byType(type);
    return type.withUnit(goal, txs: true);
  }

  Future _syncFrom() async {
    await AuthCont.load(FUserLoadCont.lightest());
    _height(_logged.height.toInt());
    _weight(_logged.weight.toInt());
  }

  Future _syncTo() async {
    _logged.info!.setHeight(height!);
    _logged.info!.setWeight(weight!);
    await FUserInfoDAO().saveOne(_logged.info!);
  }

  @override
  Future load() async {
    _weightSettable(false);
    _heightSettable(false);
    await _syncFrom();
  }

  @override
  String get loadKey => 'my-info';

  void heightSettingBarPressed() => toggleHeightSettingState();
  void weightSettingBarPressed() => toggleWeightSettingState();
  void goalSettingBarPressed() => FRoute.toGoalSetting();
}