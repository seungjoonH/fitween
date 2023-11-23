import 'package:carousel_slider/carousel_controller.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/page/carousel.dart';
import 'package:fitween/src/controller/user/auth.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';
import 'package:get/get.dart';

class GoalSettingPageCont extends CarouselPageCont {
  static GoalSettingPageCont get to => Get.find<GoalSettingPageCont>();

  final _carouselCont = CarouselController();

  bool _isFirstSetting = false;

  @override
  int get pageCount => 8;

  @override
  String get nextButtonText {
    if (isLastPage) return LangCont.tr('button.sure');
    return super.nextButtonText;
  }

  @override
  CarouselController get carouselCont => _carouselCont;

  static const String dir = 'assets/image/page/goal_setting/';
  List<String> get assets => List.generate(pageCount, (i) => '${dir}carousel_$i.svg');

  final _userInfo = Rx<FUserInfoBuilder?>(null);
  final _userRecord = Rx<FUserRecordBuilder?>(null);

  FUserInfoBuilder? get userInfo => _userInfo.value;
  FUserRecordBuilder? get userRecord => _userRecord.value;

  late FUser _user;

  void _setNewcomer() {
    _userInfo.value!.regDate = now;

    FUserInfo info = userInfo!.build();
    FUserRecord record = userRecord!.build();
    FUserBuilder builder = FUserBuilder()
      ..uid = info.key
      ..info = info
      ..record = record;

    _user = FUser.builder(builder);
  }

  void _setLogged() => _user = AuthCont.logged!;

  void setUser(FUserInfoBuilder info, [FUserRecordBuilder? record]) {
    _isFirstSetting = record == null;
    _userInfo.value = info;
    _userRecord.value = record ?? FUserRecordBuilder()..uid = info.uid;
  }

  @override
  String get loadKey => 'goal-setting';

  @override
  Future load() async {
    if (AuthCont.isLogged) {
      _setLogged();
      _userInfo.value = _user.info!.toBuilder();
      _userRecord.value = FUserRecordBuilder()
        ..setBuilder(_user.record!)
        ..uid = _user.uid;
    }

    super.init();
  }

  int get generation => userInfo!.dateOfBirth!.generation;
  Sex get sex => userInfo!.sex!;
  int get _recommendMin {
    if (generation < 20) { return 60; }
    else if (generation < 60) { return 20; }
    return 30;
  }
  int get _recommendMax {
    if (generation < 20) { return 60; }
    else if (generation < 60) { return 40; }
    return 50;
  }

  String get recommend {
    if (_recommendMin == _recommendMax) { return '$_recommendMax'; }
    return '$_recommendMin~$_recommendMax';
  }

  static const _tr = 'goal-setting';
  List<String> get _texts => List.generate(
    pageCount, (i) => '$_tr.texts.$i',
  );
  List<String> get _comments => List.generate(
    pageCount, (i) => '$_tr.comments.$i',
  );

  Level get curDis => DistanceLevelLocal().getCurrentLevel(dis);
  Level get curHei => HeightLevelLocal().getCurrentLevel(hei);
  Level get curWei => WeightLevelLocal().getCurrentLevel(wei);

  String getText(int i) {
    // FType type = FType.values[(i + 1) ~/ 2];
    Map<String, String> namedArgs = {};

    if (i == 1) {
      namedArgs['generation'] = '$generation';
      namedArgs['sex'] = sex.locale;
      namedArgs['minute'] = recommend;
    }
    else if (i == 2) {
      namedArgs['minute'] = dis.minuteUnit;
      namedArgs['object'] = curDis.title;
      namedArgs['obj-value'] = (curDis.amount as DistanceAmount).stepUnit;
    }
    else if (i == 4) {
      namedArgs['floor'] = hei.floorUnit;
      namedArgs['object'] = curHei.title;
      namedArgs['obj-value'] = (curHei.amount as HeightAmount).floorUnit;
    }
    else if (i == 6) {
      namedArgs['count'] = wei.cntUnit;
      namedArgs['object'] = curWei.title;
      namedArgs['obj-value'] = (curWei.amount as WeightAmount).cntUnit;
    }
    else if (i == 7) {
      namedArgs['nickname'] = userInfo!.nickname ?? '';
      namedArgs['minute'] = dis.minuteUnit;
      namedArgs['floor'] = hei.floorUnit;
      namedArgs['count'] = wei.cntUnit;
    }

    return LangCont.tr(
      _texts[i],
      namedArgs: namedArgs,
    );
  }

  String getComment(int i) {
    Map<String, String> namedArgs = {};

    if (i == 2) {
      namedArgs['step'] = dis.stepUnit;
      namedArgs['kilometer'] = dis.kmUnit;
    }
    else if (i == 4) {
      namedArgs['time'] = hei.lTimeUnit;
    }
    else if (i == 6) {
      String unit = wei.tUnit;
      if (LangCont.isEnglish) {
        unit += ' (${wei.lb.localizing()} lb)';
      }
      namedArgs['kilogram'] = unit;
    }

    return LangCont.tr(
      _comments[i],
      namedArgs: namedArgs,
    );
  }

  final _distanceValue = Goal.defaultDis.min.toInt().obs;
  final _heightValue = Goal.defaultHei.floor.toInt().obs;
  final _weightValue = Goal.defaultWei.cnt.toInt().obs;

  static const _distanceMin = 10;
  static const _distanceMax = 200;
  static const _heightMin = 1;
  static const _heightMax = 100;
  static const _weightMin = 5;
  static const _weightMax = 300;

  int getValue(FType type) => [
    _distanceValue.value, 
    _heightValue.value, 
    _weightValue.value,
  ][type.index - 1];
  
  void setValue(int v, FType type) => [
    _distanceValue,
    _heightValue,
    _weightValue,
  ][type.index - 1](v);

  void onChanged(int v, FType type) {
    if (v > getMax(type) || v < getMin(type)) return;
    setValue(v, type);
  }
  
  int getMin(FType type) => [
    _distanceMin, _heightMin, _weightMin,
  ][type.index - 1];

  int getMax(FType type) => [
    _distanceMax, _heightMax, _weightMax,
  ][type.index - 1];

  DistanceAmount get dis => (DistanceAmount()..min = getValue(FType.distance));
  HeightAmount get hei => (HeightAmount()..floor = getValue(FType.height));
  WeightAmount get wei => (WeightAmount()..cnt = getValue(FType.weight));

  @override
  void thirdPageInit() {
    _distanceValue(_distanceMin);
    delay(500.ms, () => _distanceValue(60));
  }

  @override
  void thirdPageSubmit() {
    userRecord!.setGoal(FType.distance, dis.step);
  }

  @override
  void fifthPageInit() {
    _heightValue(_heightMin);
    delay(500.ms, () => _heightValue(10));
  }

  @override
  void fifthPageSubmit() {
    userRecord!.setGoal(FType.height, hei.floor);
  }

  @override
  void seventhPageInit() {
    _weightValue(_weightMin);
    delay(500.ms, () => _weightValue(50));
  }

  @override
  void seventhPageSubmit() {
    userRecord!.setGoal(FType.weight, wei.cnt);
  }

  @override
  void eighthPageSubmit() async {
    if (_isFirstSetting) {
      _setNewcomer(); login();
      await FUserDAO().saveOne(_user);
    }
    else {
      _user.record!.updateGoalData(userRecord!.build());
      await FUserInfoDAO().saveOne(_user.info!);
      await FUserRecordDAO().saveOne(_user.record!);
    }

    BottomBarCont.to.navigate(0);
    pageIndex = 0;
  }

  void login() {
    _user.construct();
    AuthCont.setUser(_user);
  }


}