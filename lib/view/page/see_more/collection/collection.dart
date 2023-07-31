import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/view/page/see_more/collection/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// class
class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(title: Lang.tr('badge.').capitalize!),
      body: CollectionMainView(),
    );
  }
}