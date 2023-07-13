import 'package:fitween/global/date.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/report.dart';
import 'package:fitween/model/enum/report.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/detail.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/edit.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/report.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Report report = Get.arguments;

    return GetBuilder<ReportP>(
      builder: (reportP) {
        return Scaffold(
          appBar: FAppBar(
            title: '리포트 #${report.id}',
            actions: [
              if (report.stage.index < 2)
              IconButton(
                onPressed: () => reportP.addButtonPressed(report),
                icon: const Icon(Icons.edit),
                color: FTheme.grey,
              ),
              IconButton(
                onPressed: () => reportP.deleteButtonPressed(report),
                icon: const Icon(Icons.delete),
                color: FTheme.grey,
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 28.0.w, vertical: 28.0.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FCard(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FText(report.title ?? '', bold: true, style: textTheme(context).titleLarge),
                        FTag(report.stage.kr, backgroundColor: report.stage.color),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FText(
                              '작성자: ${report.nickname}',
                              color: FTheme.lightGrey,
                              style: textTheme(context).bodyMedium,
                            ),
                            FText(
                              '작성일시: ${dateToString('yy.MM.dd hh:mm', report.date)}',
                              color: FTheme.lightGrey,
                              style: textTheme(context).bodyMedium,
                            ),
                            FText(
                              '카테고리: ${report.type.kr}',
                              color: FTheme.lightGrey,
                              style: textTheme(context).bodyMedium,
                            ),
                          ],
                        ),
                        SizedBox(height: 40.0.h),
                        FText(
                          report.content ?? '',
                          color: FTheme.grey,
                          style: textTheme(context).bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  AdminAnswerCard(stage: report.stage, answer: report.answer),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class AdminAnswerCard extends StatelessWidget {
  const AdminAnswerCard({
    super.key,
    required this.stage,
    this.answer,
  });

  final ReportStage stage;
  final String? answer;

  @override
  Widget build(BuildContext context) {
    switch (stage) {
      case ReportStage.requested:
        return FCard(
          title: FText(
            '개발자 답변',
            bold: true,
            style: textTheme(context).titleLarge,
            color: FTheme.white,
          ),
          backgroundColor: stage.color,
          child: FText(
            '문의가 접수 대기 중입니다.',
            style: textTheme(context).bodyMedium,
            color: FTheme.white,
            maxLines: 10,
          ),
        );
      case ReportStage.accepted:
        return FCard(
          title: FText(
            '개발자 답변',
            bold: true,
            style: textTheme(context).titleLarge,
            color: FTheme.white,
          ),
          backgroundColor: stage.color,
          child: FText(
            '문의가 접수되었습니다.\n빠른 시일 내 답장해드리겠습니다.',
            style: textTheme(context).bodyMedium,
            color: FTheme.white,
            maxLines: 10,
          ),
        );
      case ReportStage.answered:
        return FCard(
          title: FText(
            '개발자 답변',
            bold: true,
            style: textTheme(context).titleLarge,
            color: FTheme.white,
          ),
          backgroundColor: stage.color,
          child: FText(
            answer!,
            style: textTheme(context).bodyMedium,
            color: FTheme.white,
            maxLines: 10,
          ),
        );
      default: return Container();
    }
  }
}

