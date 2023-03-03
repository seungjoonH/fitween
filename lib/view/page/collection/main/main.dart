import 'package:fitween/view/page/collection/main/widget.dart';
import 'package:flutter/material.dart';
import '../../../../global/theme.dart';
import '../../../widget/widget/app_bar.dart';

/// class
class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: FTheme.white,
      appBar: FAppBar(title: '컬렉션', color: FTheme.white),
      body: CollectionMainView(),
    );
  }
}