import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class InventoryPageCont extends PageCont {
  static InventoryPageCont get to => Get.find<InventoryPageCont>();

  String get appBarTitle => LangCont.tr('appbar.inventory');

  InventoryCont get inventoryCont => InventoryCont.to;

  @override
  Future load() async {
    await inventoryCont.init();
  }

  @override
  String get loadKey => 'inventory';

}