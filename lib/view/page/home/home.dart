import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/page/home.dart';
import 'package:fitween/view/page/home/widget.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/icon.dart';
import 'package:flutter/material.dart';
import 'package:fitween/view/widget/widget/bottom_bar.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../../global/theme.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: GlobalPresenter.closeBottomBar,
//       child: const Scaffold(
//         appBar: HomeAppBar(),
//         bottomSheet: PBottomSheetBar(body: HomeView()),
//       ),
//     );
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RotateCarousel(),
          Expanded(
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    RankingCard(),
                    SizedBox(height: 20.0),
                    RecordCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FBottomNavigationBar(),
    );
  }
}
