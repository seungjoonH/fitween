import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/page/carousel.dart';
import 'package:fitween/src/controller/page/goal_setting.dart';
import 'package:fitween/src/controller/validator/validator.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:get/get.dart';

class RegisterPageCont extends CarouselPageCont {
  static RegisterPageCont get to => Get.find<RegisterPageCont>();

  List<String> get _comments => List.generate(pageCount, (i) => LangCont.tr('register.comments.$i'));
  String getComment(int i) => _comments[i];

  String get appBarTitle => LangCont.tr('appbar.register');

  final _carouselCont = CarouselController();

  @override
  CarouselController get carouselCont => _carouselCont;

  FUserInfoBuilder? newcomer;

  @override
  int get pageCount => 2;

  bool get invalid => _validators.values
      .map((v) => v.invalid).any((e) => e);

  @override
  void nextButtonPressed() {
    submit(); init();
    if (invalid) return;
    super.nextButtonPressed();
  }

  final _validators = {
    'nickname': NicknameValidatorCont(),
    'dateOfBirth': DateOfBirthValidatorCont(),
    'sex': SexValidatorCont(),
  };

  Map<String, ValidatorCont> get validators => _validators;
  ValidatorCont getValidator(RegisterFieldType type) => validators[type.name]!;

  String get _nickname {
    RegisterFieldType type = RegisterFieldType.nickname;
    var validator = getValidator(type) as InputFieldValidatorCont;
    return validator.text;
  }

  DateTime get _dateOfBirth {
    RegisterFieldType type = RegisterFieldType.dateOfBirth;
    var validator = getValidator(type) as InputFieldValidatorCont;
    return stringToDate(validator.text)!;
  }

  Sex get _sex {
    RegisterFieldType type = RegisterFieldType.sex;
    var validator = getValidator(type) as ButtonFieldValidatorCont;
    return validator.value as Sex;
  }

  @override
  void firstPageInit() {
    pageIndex = 0; newcomer = null;
    for (var cont in _validators.values) { cont.init(); }
  }

  @override
  void firstPageSubmit() async {
    for (var cont in _validators.values) {
      if (cont.invalid) continue;
      cont.submit();
    }
  }

  final _weight = 60.obs;
  final _height = 170.obs;

  void onWeightChanged(int v) => _weight(v);
  void onHeightChanged(int v) => _height(v);
  int get weight => _weight.value;
  int get height => _height.value;

  int get weightMin => 30;
  int get weightMax => 220;
  int get heightMin => 100;
  int get heightMax => 220;

  @override
  void secondPageInit() {
    _weight(weightMin); _height(heightMin);
    delay(500.ms, () { _weight(60); _height(170); });
  }

  @override
  void secondPageSubmit() {
    newcomer = newcomer!
      ..nickname = _nickname
      ..dateOfBirth = _dateOfBirth
      ..sex = _sex
      ..weight = weight
      ..height = height;

    GoalSettingPageCont.to.setUser(newcomer!);
    FRoute.toGoalSetting();
  }
}