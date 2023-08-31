import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/global/date.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CarouselPageCont extends GetxController {
  String get nextButtonText => LangCont.tr('button.next');

  final _pageIndex = 0.obs;

  int get pageCount;
  set pageIndex(int i) => _pageIndex(i);
  int get pageIndex => _pageIndex.value;

  bool get isFirstPage => pageIndex == 0;
  bool get isLastPage => pageIndex == pageCount - 1;

  CarouselController get carouselCont;

  CarouselOptions get carouselOptions => CarouselOptions(
    height: double.infinity,
    initialPage: 0,
    reverse: false,
    enableInfiniteScroll: false,
    scrollPhysics: const NeverScrollableScrollPhysics(),
    viewportFraction: 1.0,
  );

  void next() async {
    await carouselCont.nextPage(curve: Curves.easeInOut);
    _pageIndex(min(pageIndex + 1, pageCount - 1));
  }

  void back() async {
    await carouselCont.previousPage(curve: Curves.easeInOut);
    _pageIndex(max(pageIndex - 1, 0));
  }

  void nextButtonPressed() {
    submit(); init();
    if (!isLastPage) { next(); return; }
  }

  void backButtonPressed() {
    if (!isFirstPage) { back(); return; }
    Get.back();
  }

  void init() {
    if (isLastPage) return;
    [ firstPageInit,
      secondPageInit,
      thirdPageInit,
      fourthPageInit,
      fifthPageInit,
      sixthPageInit,
      seventhPageInit,
      eighthPageInit,
    ][pageIndex + 1]();
  }

  void submit() {
    [ firstPageSubmit,
      secondPageSubmit,
      thirdPageSubmit,
      fourthPageSubmit,
      fifthPageSubmit,
      sixthPageSubmit,
      seventhPageSubmit,
      eighthPageSubmit,
    ][pageIndex]();
  }

  void firstPageInit() {}
  void firstPageSubmit() {}

  void secondPageInit() {}
  void secondPageSubmit() {}

  void thirdPageInit() {}
  void thirdPageSubmit() {}

  void fourthPageInit() {}
  void fourthPageSubmit() {}

  void fifthPageInit() {}
  void fifthPageSubmit() {}

  void sixthPageInit() {}
  void sixthPageSubmit() {}

  void seventhPageInit() {}
  void seventhPageSubmit() {}

  void eighthPageInit() {}
  void eighthPageSubmit() {}

}