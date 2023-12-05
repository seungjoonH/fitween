import 'package:fitween/src/controller/page.dart';
import 'package:flutter/material.dart';

export './button/button.dart';
export './button/check.dart';
export './button/icon.dart';
export './button/pressable.dart';
export './button/selection.dart';
export './button/text.dart';

export './function/dialog.dart';
export './function/modal_bottom_sheet.dart';
export './function/snack_bar.dart';

export './widget/app_bar.dart';
export './widget/badge.dart';
export './widget/bubble.dart';
export './widget/card.dart';
export './widget/carousel.dart';
export './widget/challenge.dart';
export './widget/drawer.dart';
export './widget/effect.dart';
export './widget/gift.dart';
export './widget/grayscale.dart';
export './widget/header.dart';
export './widget/icon.dart';
export './widget/image.dart';
export './widget/indicator.dart';
export './widget/island.dart';
export './widget/item.dart';
export './widget/list_tile.dart';
export './widget/logo.dart';
export './widget/notice.dart';
export './widget/party.dart';
export './widget/point.dart';
export './widget/profile.dart';
export './widget/pulse.dart';
export './widget/rank.dart';
export './widget/scaffold.dart';
export './widget/slider.dart';
export './widget/tab.dart';
export './widget/tag.dart';
export './widget/text.dart';

abstract class FWidget extends StatefulWidget {
  const FWidget({super.key});

  @override
  FWidgetState createState();
}

abstract class FWidgetState<T extends FWidget> extends State<T> {
  @override
  void dispose() {
    super.dispose();
    PageCont.removeContext(context);
  }

  @override
  Widget build(BuildContext context) {
    PageCont.context = context;
    PageCont.mediaQuery = MediaQuery.of(context);
    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context);
}
