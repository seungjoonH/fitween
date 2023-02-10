import 'package:flutter/material.dart';
import 'package:fitween/view/page/onboarding/widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CarouselView(),
    );
  }
}
