import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/onboarding.dart';
import 'package:fitween/presenter/page/register.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/text.dart';

class CarouselView extends StatefulWidget {
  const CarouselView({Key? key}) : super(key: key);

  @override
  State<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  late double opacity;

  @override
  void initState() {
    opacity = .0;
    Future.delayed(Duration.zero, () {
      setState(() => opacity = 1.0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> messages = [
      '일상 운동 기록,\n어떻게 관리하시나요?',
      '입력만 하세요!\n피스타치오가 의미있게\n만들어드릴게요',
      '유산소, 계단 오르기,\n운동 횟수를 기록 가능해요!',
      '오늘의 목표 설정을 통해\n더 쉽게 관리 해보세요!',
    ];

    return GetBuilder<OnboardingPresenter>(
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: CarouselSlider(
                carouselController: OnboardingPresenter.carouselCont,
                items: List.generate(messages.length, (index) => AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  opacity: opacity,
                  curve: Curves.easeInOut,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PText(messages[index],
                        maxLines: 3,
                        style: textTheme.headlineSmall,
                        align: TextAlign.center,
                      ),
                      SvgPicture.asset(
                        OnboardingPresenter.getAsset(index),
                      ),
                    ],
                  ),
                )).toList(),
                options: CarouselOptions(
                  height: double.infinity,
                  initialPage: 0,
                  reverse: false,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  onPageChanged: (index, _) => controller.pageChanged(index),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 50.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CarouselIndicator(count: messages.length),
                  if (controller.visible)
                  PButton(
                    onPressed: RegisterPresenter.toRegister,
                    text: '시작하기',
                    stretch: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        );
      },
    );
  }
}
// Carousel 인디케이터 위젯
class CarouselIndicator extends StatelessWidget {
  const CarouselIndicator({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingPresenter>(
      builder: (controller) {
        return DotsIndicator(
          dotsCount: count,
          position: controller.pageIndex.toDouble(),
          decorator: DotsDecorator(
            color: PTheme.grey,
            activeColor: PTheme.black,
            size: const Size(10.0, 10.0),
            activeSize: const Size(150.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
      },
    );
  }
}