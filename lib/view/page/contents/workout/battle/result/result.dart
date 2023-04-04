import 'package:fitween/presenter/page/contents/contents.dart';
import 'package:fitween/presenter/page/contents/workout/battle/result.dart';
import 'package:fitween/view/page/contents/workout/battle/result/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BattleResultPage extends StatelessWidget {
  const BattleResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BattleResultP>(
      builder: (battleResultP) {
        return Scaffold(
          appBar: FAppBar(
            title: '타임어택 결과',
            leading: Container(),
            actions: [
              IconButton(
                onPressed: () {
                  if (battleResultP.offAll) { ContentsP.toContents(); }
                  else { Get.back(); }
                },
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
          body: BattleResultView(result: !battleResultP.offAll),
        );
      }
    );
  }
}
