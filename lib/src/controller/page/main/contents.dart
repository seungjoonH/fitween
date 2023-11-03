import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:get/get.dart';

enum Content {
  adventure, challenge, weight, battle;
  String get _asset => 'assets/image/page/contents';
  String get path {
    String dayOrNight = ThemeCont.to.isLightMode ? 'day' : 'night';
    if (index == 0) return '$_asset/${name}_$dayOrNight.svg';
    return '$_asset/$name.svg';
  }
  String get _tr => 'contents.card-title';
  String get cardTitle => LangCont.tr('$_tr.$name');
  bool get isLocked => [false, false, false, true][index];
}

class ContentsPageCont extends MainPageCont {
  static ContentsPageCont get to => Get.find<ContentsPageCont>();

  String get appBarTitle => LangCont.tr('appbar.contents');

  @override
  String get loadKey => 'contents';

  @override
  Future load() async {}

  void _adventureCardPressed() => FRoute.toAdventure();
  void _challengeCardPressed() => FRoute.toChallenge();
  void _weightCardPressed() => FRoute.toWeight();
  void _battleCardPressed() => FRoute.toBattle();

  void contentCardPressed(Content content) {
    switch (content) {
      case Content.adventure: _adventureCardPressed(); break;
      case Content.challenge: _challengeCardPressed(); break;
      case Content.weight: _weightCardPressed(); break;
      case Content.battle: _battleCardPressed(); break;
    }
  }
}