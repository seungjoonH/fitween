import 'package:fitween/view/page/contents/challenge/party/widget.dart';
import 'package:flutter/material.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartyPage extends StatelessWidget {
  const PartyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: const FAppBar(title: '내 챌린지'),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28.0.w,
            vertical: 28.0.h,
          ),
          child: const PartyView(),
        ),
      ),
    );
  }
}
