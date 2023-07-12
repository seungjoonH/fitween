import 'package:fitween/main.dart';
import 'package:fitween/presenter/firebase/firebase.dart';
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

    if (latestVersion == versionNumber) { message = '최신버전을 사용 중입니다.'; }
    else if (versions.contains(versionNumber)) {
      message = '최신 업데이트가 있습니다.\nver $latestVersion를 사용할 수 있습니다.';
    }
    else { message = '지원되지 않는 버전입니다.'; }
  }
}