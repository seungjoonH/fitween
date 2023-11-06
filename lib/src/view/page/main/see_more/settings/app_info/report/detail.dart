import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReportDetailPage extends FPage {
  const ReportDetailPage({super.key});

  @override
  FPageState<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends FPageState<ReportDetailPage> {

  @override
  ReportDetailPageCont get cont => ReportDetailPageCont.to;

  Widget _buildAdminAnswerCard(BuildContext context) {
    Widget buildCard(String content) {
      return FCard(
        title: FText(
          cont.developerAnswerText,
          bold: true,
          style: ThemeCont.to.titleLarge,
          color: ThemeCont.to.backgroundAlt,
        ),
        backgroundColor: cont.report!.stage.color,
        child: FText(
          content,
          style: ThemeCont.to.bodyMedium,
          color: ThemeCont.to.backgroundAlt,
          maxLines: 10,
        ),
      );
    }

    switch (cont.report!.stage) {
      case ReportStage.requested:
        return buildCard(cont.report!.stage.answer!);
      case ReportStage.accepted:
        return buildCard(cont.report!.stage.answer!);
      case ReportStage.answered:
        return buildCard(cont.report!.answer!);
      default: return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return Obx(() {
      if (cont.report == null) return const FScaffold();
      return FScaffold(
        appBar: FAppBar(
          text: cont.appBarTitle,
          actions: [
            if (cont.report!.stage.index < 2)
            FIconButton(
              onPressed: cont.editButtonPressed,
              icon: const Icon(Icons.edit),
            ),
            if (cont.report!.stage.index < 2)
            FIconButton(
              onPressed: cont.deleteButtonPressed,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FCard(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FText(
                      cont.report!.title ?? '',
                      bold: true,
                      style: ThemeCont.to.titleLarge,
                    ),
                    FTextTag(
                      cont.report!.stage.locale.capitalize!,
                      backgroundColor: cont.report!.stage.color,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FText(
                          '${cont.writerText}: ${cont.report!.nickname}',
                          color: ThemeCont.to.comment,
                          style: ThemeCont.to.bodyMedium,
                        ),
                        FText(
                          '${cont.dateText}: ${dateToString('yy.MM.dd hh:mm', cont.report!.date)}',
                          color: ThemeCont.to.comment,
                          style: ThemeCont.to.bodyMedium,
                        ),
                        FText(
                          '${cont.categoryText}: ${cont.report!.category}',
                          color: ThemeCont.to.comment,
                          style: ThemeCont.to.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0.h),
                    FText(
                      cont.report!.content,
                      color: ThemeCont.to.outline,
                      style: ThemeCont.to.bodyLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0.h),
              _buildAdminAnswerCard(context),
            ],
          ),
        ),
      );
    });
  }

}
