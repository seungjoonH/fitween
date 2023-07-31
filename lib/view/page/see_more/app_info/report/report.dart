import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/database/report.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/detail.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/edit.dart';
import 'package:fitween/presenter/page/see_more/app_info/report/report.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/list_tile.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: Lang.tr('fw.bug-rep.'),
        actions: const [
          IconButton(
            onPressed: ReportEditP.toReportEdit,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: GetBuilder<ReportP>(
        builder: (reportP) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 28.0.w,
              vertical: 28.0.h,
            ),
            child: reportP.reports.isEmpty ? FTextButton(
              height: 80.0.h,
              text: Lang.tr('fw.bug-rep.write'),
              stretch: true,
              border: true,
              onPressed: ReportEditP.toReportEdit,
            ) : ListView.builder(
              itemCount: reportP.reports.length,
              itemBuilder: (context, index) {
                Report report = reportP.reports[index];
                return FListTile(
                  title: '#${report.id} ${report.title}',
                  subtitle: '${report.type.category}: ${report.content}',
                  maxLines: 1,
                  tag: FTag(report.stage.locale.capitalize!, backgroundColor: report.stage.color),
                  trailing: const Icon(Icons.chevron_right, color: FTheme.lightGrey),
                  onPressed: () => ReportDetailP.toReportDetail(report),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
