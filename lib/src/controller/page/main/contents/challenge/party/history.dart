import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class PartyHistoryPageCont extends PageCont {
  static PartyHistoryPageCont get to => Get.find<PartyHistoryPageCont>();

  String get appBarTitle => LangCont.tr('appbar.history');

  final _finishedParties = <Party>[].obs;
  List<Party> get _sortedParties {
    int compare(Party a, Party b) => b.startDate!.compareTo(a.startDate!);
    return _finishedParties..sort(compare);
  }

  List<Party> get parties => _sortedParties
      .where((party) => isActive(party.type)).toList();


  final _activeTypes = <FType, bool>{}.obs;
  Map<FType, bool> get activeTypes => _activeTypes;

  bool isActive(FType type) => activeTypes[type] ?? true;
  void updateTypeState(FType type) => activeTypes[type] = !isActive(type);

  void partyListPressed(Party party) => FRoute.toParty(party: party);

  @override
  Future load() async {
    _activeTypes.assignAll({for (var type in FType.values) type : true});
    await logged.party!.loadFinishedParties();
    _finishedParties.assignAll(logged.finishedParties.values);
  }

  @override
  String get loadKey => 'party-history';

}