import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReportPage extends FPage {
  const ReportPage({super.key});

  @override
  FPageState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends FPageState<ReportPage> {

  @override
  ReportPageCont get cont => ReportPageCont.to;

  Widget _buildTrailing(BuildContext context, Report report) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FTextTag(
          report.stage.locale.capitalize!,
          backgroundColor: report.stage.color,
        ),
        SizedBox(height: 10.0.h),
        Icon(
          Icons.chevron_right,
          color: ThemeCont.to.comment,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.reports.isEmpty) {
        return Column(
          children: [
            DarkPressableWidget(
              onPressed: cont.createReportButtonPressed,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: ThemeCont.to.comment),
                  borderRadius: BorderRadius.circular(10.0.r),
                ),
                height: 90.0.h,
                child: FText(
                  cont.noReportsText,
                  color: ThemeCont.to.comment,
                ),
              ),
            ),
          ],
        );
      }
      return ListView.separated(
        itemCount: cont.reports.length,
        itemBuilder: (context, index) {
          Report report = cont.reports[index];
          return FListTile(
            title: '#${report.id} ${report.title}',
            subtitle: '${report.bugType.category}: ${report.content}',
            trailing: [_buildTrailing(context, report)],
            onPressed: () => cont.reportTilePressed(report),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 10.0.h),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(
        text: cont.appBarTitle,
        actions: [
          IconButton(
            onPressed: cont.createReportButtonPressed,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }
}
