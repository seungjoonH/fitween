import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/home/home.dart';
import 'package:fitween/presenter/widget/camera.dart';
import 'package:fitween/presenter/widget/loading.dart';
import 'package:fitween/view/page/home/widget.dart';
import 'package:flutter/material.dart';
import 'package:fitween/view/widget/widget/bottom_bar.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CameraP.orientation = MediaQuery.of(context).orientation;
    final refreshCont = RefreshController();

    return Scaffold(
      body: GetBuilder<LoadingP>(
        builder: (loadingP) {
          return SmartRefresher(
            controller: refreshCont,
              onRefresh: () async {
              try {
                await HomeP.init();
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
                  const RotateCarousel(),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      children: const [
                        CalendarCard(),
                        SizedBox(height: 20.0),
                        RankingCard(),
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
