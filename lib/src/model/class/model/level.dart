import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/ftype.dart';

class Level extends Model {
  late String _id;
  late String _title;
  String? _description;
  late num _amount;
  late bool _activate;

  String get title => _title;
  String get description => _description ?? '';
  bool get activate => _activate;
  Amount get amount => [
    DistanceAmount()..km = _amount,
    HeightAmount()..floor = _amount,
    WeightAmount()..t = _amount,
  ][type.index - 1];
  FType get type => FType.values[int.parse(_id[2])];

  Level.fromJson(super.json) : super.fromJson();

  @override
  void fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _title = json['title'][LangCont.locale];
    _amount = json['amount'];
    _description = json['description'][LangCont.locale];
    _activate = json['activate'];
  }

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();

  @override
  String get key => _id;


}