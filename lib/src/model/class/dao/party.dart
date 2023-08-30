
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model/party.dart';

class PartyDAO extends DAO<Party> {
  static final PartyDAO _instance = PartyDAO._();
  PartyDAO._();

  factory PartyDAO() => _instance;

  @override
  String get collectionPath => 'parties';

  @override
  Party fromJson(Map<String, dynamic> json) {
    return Party.fromJson(json);
  }

  @override
  String get keyName => 'id';
}