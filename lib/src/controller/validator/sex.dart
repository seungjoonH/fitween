import 'package:fitween/src/controller/validator/validator.dart';
import 'package:fitween/src/model/class/model.dart';

class SexValidatorCont extends ButtonFieldValidatorCont<Sex> {
  @override
  bool validate() => value == null;
}