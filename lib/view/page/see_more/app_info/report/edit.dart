import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/report.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/edit.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReportEditPage extends StatelessWidget {
  const ReportEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportEditP>(
      builder: (reportEditP) {
        return Scaffold(
          appBar: FAppBar(
            title: '리포트 #${reportEditP.report!.id}',
            actions: [
              IconButton(
                onPressed: reportEditP.saveButtonPressed,
                icon: const Icon(Icons.save_rounded),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 28.0.w,
              vertical: 28.0.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      bool isBug = reportEditP.report!.isBug;
                      FButton buildButton(bool bug) {
                        bool selected = isBug ? bug : !bug;
                        return FButton(
                          text: bug ? '오류 제보' : '개선 요청',
                          border: true,
                          stretch: true,
                          multiple: true,
                          backgroundColor: selected
                              ? FTheme.darkGrey
                              : FTheme.background,
                          textColor: selected
                              ? FTheme.background
                              : FTheme.darkGrey,
                          onPressed: () => reportEditP.isBugChanged(bug),
                        );
                      }
                      return Row(
                        children: [
                          buildButton(true),
                          SizedBox(width: 20.0.w),
                          buildButton(false),
                        ],
                      );
                    }
                  ),
                  reportEditP.report!.isBug ? SizedBox(
                    height: 90.0.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FText('카테고리', bold: true),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0.r,
                            vertical: 5.0.r,
                          ),
                          decoration: BoxDecoration(
                            color: FTheme.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButton<ReportType>(
                            value: reportEditP.report!.type,
                            items: ReportType.values.map((type) => DropdownMenuItem<ReportType>(
                              value: type,
                              child: FText(type.kr),
                            )).toList(),
                            onChanged: reportEditP.typeChanged,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30.0.r,
                            underline: const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ) : SizedBox(height: 90.0.h),
                  FInputField(
                    controller: reportEditP.titleCont,
                    invalid: reportEditP.titleInvalid,
                    hintText: reportEditP.titleHintText ?? '리포트 제목',
                    hintColor: reportEditP.titleHintText == null
                        ? FTheme.grey : FTheme.colorB,
                  ),
                  SizedBox(height: 20.0.h),
                  FInputField(
                    controller: reportEditP.contentCont,
                    invalid: reportEditP.contentInvalid,
                    hintText: reportEditP.contentHintText ?? (reportEditP.report!.isBug
                        ? reportEditP.report!.type.guide
                        : '개선을 원하는 사항이 있다면 알려주세요.'),
                    hintColor: reportEditP.contentHintText == null
                        ? FTheme.grey : FTheme.colorB,
                    maxLines: 8,
                  ),
                  SizedBox(height: 120.0.h),
                  FButton(
                    text: '제출', stretch: true,
                    onPressed: reportEditP.submitButtonPressed,
                  ),
                  SizedBox(height: 40.0.h),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
