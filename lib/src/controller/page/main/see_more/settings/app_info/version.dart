import 'package:fitween/global/global.dart';
import 'package:fitween/main.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

class VersionPageCont extends PageCont {
  static VersionPageCont get to => Get.find<VersionPageCont>();

  final _versions = <String, bool>{}.obs;

  String get message {
    late String tr = 'version.message';
    if (!(_versions[version] ?? false)) { tr += '.unavailable'; }
    else if (_versions.keys.last == version) { tr += '.latest'; }
    else { tr += '.old'; }
    return LangCont.tr(tr);
  }

  String get patchNoteButtonText => LangCont.tr('button.patch-note');

  void patchNoteButtonPressed() => FRoute.toPatchNote();

  Future _loadVersions() async {
    _versions.clear();
    var cols = await f.collection('versions').get();

    for (var data in cols.docs) {
      Map<String, dynamic> json = data.data();
      _versions[data.id] = json['available'];
    }
  }

  @override
  Future load() async {
    await _loadVersions();
  }

  @override
  String get loadKey => 'version';

}