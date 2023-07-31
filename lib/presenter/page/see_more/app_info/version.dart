import 'package:fitween/main.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:get/get.dart';

class VersionP extends GetxController {
  static late String latestVersion;
  static late String message;

  static void toVersion() async {
    await loadVersion();
    Get.toNamed('/seeMore/appInfo/version');
  }
  
  static Future loadVersion() async {
    latestVersion = 'not-found';
    var collection = await f.collection('versions').get();
    List<String> versions = [];

    for (var doc in collection.docs) {
      bool available = doc.data()['available'];
      if (available) versions.add(doc.id);
    }

    if (versions.isNotEmpty) latestVersion = versions.last;

    if (latestVersion == versionNumber) { message = Lang.tr('fw.version.latest'); }
    else if (versions.contains(versionNumber)) {
      message = Lang.tr('fw.version.update', args: [latestVersion]);
    }
    else { message = Lang.tr('fw.version.no-support', args: [versionNumber]); }
  }
}