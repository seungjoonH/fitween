import 'package:fitween/view/page/collection/main/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';

/// class
class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: FAppBar(title: '컬렉션'),
      body: CollectionMainView(),
    );
  }
}