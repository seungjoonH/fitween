import 'package:fitween/global/theme.dart';
import 'package:flutter/material.dart';
import 'package:fitween/view/page/onboarding/widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: FTheme.white,
      body: CarouselView(),
    );
  }
}
