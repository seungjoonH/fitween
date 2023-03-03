import 'package:fitween/presenter/page/see_more/see_more.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../global/theme.dart';
import '../../../presenter/widget/loading.dart';
import '../../widget/widget/bottom_bar.dart';

class SeeMorePage extends StatelessWidget {
  const SeeMorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final refreshCont = RefreshController();

    return Scaffold(
      body: GetBuilder<LoadingP>(
          builder: (loadingP) {
            return SmartRefresher(
              controller: refreshCont,
              onRefresh: () async {
                try {
                  await SeeMoreP.init();
                  refreshCont.refreshCompleted();
                } catch (e) {
                  refreshCont.refreshFailed();
                }
              },
              onLoading: () async {
                await Future.delayed(const Duration(milliseconds: 100));
                refreshCont.loadComplete();
              },
              header: const MaterialClassicHeader(
                color: FTheme.black,
                backgroundColor: FTheme.surface,
                offset: 40.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        children: const [
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
      bottomNavigationBar: const FBottomNavigationBar(),
    );
  }
}
