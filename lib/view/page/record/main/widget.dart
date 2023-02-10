import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/page/record/detail.dart';
import 'package:fitween/presenter/page/record/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fitween/view/widget/widget/text.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordMain>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          width: 330.0,
          height: 110.0,
          child: Card(
            // color: const Color(0xfffbf8f1),
            child: InkWell(
              onTap: RecordDetail.toRecordDetail,
              borderRadius: BorderRadius.circular(10.0),
              child: Row(
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    padding: const EdgeInsets.all(5.0),
                    decoration: const BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                    child: SvgPicture.asset('assets/image/object/moai_stone.svg'),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PText('오늘 ${type.done} ${type.kr}',
                            style: textTheme.labelSmall,
                          ),
                          PText(controller.tiers[type]!['current'].title,
                            style: textTheme.bodyLarge,
                          ),
                          PText('다음 단계 : ${controller.tiers[type]!['next'].title} 까지',
                            style: textTheme.labelSmall,
                          ),
                          Expanded(
                            child: LinearPercentIndicator(
                              percent: controller.tiers[type]!['percent'],
                              lineHeight: 12.0,
                              padding: EdgeInsets.zero,
                              barRadius: const Radius.circular(6.0),
                              progressColor: PTheme.primary[40],
                              animation: true,
                              animationDuration: 1000,
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}


class MyRecordView extends StatelessWidget {
  const MyRecordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordMain>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('오늘의 기록', style: textTheme.labelLarge),
              Column(
                children: ActivityType.activeValues.map((type) => RecordCard(type: type)).toList(),
              ),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 15.0),
              //   width: 330.0,
              //   height: 110.0,
              //   child: Card(
              //     color: const Color(0xfffbf8f1),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 100.0,
              //           height: 100.0,
              //           padding: const EdgeInsets.all(5.0),
              //           decoration: const BoxDecoration(
              //             // color: Colors.white,
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(10.0),
              //               bottomLeft: Radius.circular(10.0),
              //             ),
              //           ),
              //           child: SvgPicture.asset('assets/image/object/namhansanseong.svg'),
              //         ),
              //         Expanded(
              //           child: Container(
              //             padding: const EdgeInsets.all(10.0),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 const Text('오늘 이동한 거리', style: TextStyle(fontSize: 12.0)),
              //                 const Text('남한산성', style: TextStyle(fontSize: 22.0)),
              //                 const Text('다음 단계 : 마라톤 풀코스 까지', style: TextStyle(fontSize: 12.0)),
              //                 Expanded(
              //                   child: LinearPercentIndicator(
              //                     percent: .9,
              //                     padding: EdgeInsets.zero,
              //                     lineHeight: 12.0,
              //                     barRadius: const Radius.circular(6.0),
              //                     progressColor: const Color(0xff54bab9),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 15.0),
              //   width: 330.0,
              //   height: 110.0,
              //   child: Card(
              //     color: const Color(0xfffbf8f1),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 100.0,
              //           height: 100.0,
              //           padding: const EdgeInsets.all(5.0),
              //           decoration: const BoxDecoration(
              //             // color: Colors.white,
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(10.0),
              //               bottomLeft: Radius.circular(10.0),
              //             ),
              //           ),
              //           child: SvgPicture.asset('assets/image/object/eiffel_tower.svg'),
              //         ),
              //         Expanded(
              //           child: Container(
              //             padding: const EdgeInsets.all(10.0),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 const Text('오늘 오른 계단 높이', style: TextStyle(fontSize: 12.0)),
              //                 const Text('에펠탑', style: TextStyle(fontSize: 22.0)),
              //                 const Text('다음 단계 : 엠파이어 스테이트 빌딩 까지', style: TextStyle(fontSize: 12.0)),
              //                 Expanded(
              //                   child: LinearPercentIndicator(
              //                     percent: .2,
              //                     padding: EdgeInsets.zero,
              //                     lineHeight: 12.0,
              //                     barRadius: const Radius.circular(6.0),
              //                     progressColor: const Color(0xff54bab9),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      }
    );
  }
}



