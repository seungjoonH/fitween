import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReportEditPage extends FPage {
  const ReportEditPage({super.key});

  @override
  FPageState<ReportEditPage> createState() => _ReportEditPageState();
}

class _ReportEditPageState extends FPageState<ReportEditPage> {

  @override
  ReportEditPageCont get cont => ReportEditPageCont.to;

  Widget _buildButton(ReportType type) {
    return Obx(() {
      bool isSelected = cont.selectedType == type;
      return FButton(
        text: type.locale,
        border: true,
        stretch: true,
        backgroundColor: isSelected
            ? ThemeCont.to.text
            : ThemeCont.to.background,
        textColor: isSelected
            ? ThemeCont.to.background
            : ThemeCont.to.text,
        onPressed: () => cont.selectType(type),
      );
    });
  }

  Widget _buildButtonWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildButton(ReportType.bugReport)),
        Expanded(child: _buildButton(ReportType.request)),
      ].separateW(width: 20.0.w),
    );
  }

  Widget _buildCategoryWidget(BuildContext context) {
    if (cont.selectedType == ReportType.request) return SizedBox(height: 90.0.h);
    return SizedBox(
      height: 90.0.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FText(cont.categoryText, bold: true),
          Obx(() => Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0.r,
              vertical: 5.0.r,
            ),
            decoration: BoxDecoration(
              color: ThemeCont.to.backgroundAlt,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButton<BugReportType>(
              value: cont.selectedBugType,
              dropdownColor: ThemeCont.to.background,
              items: BugReportType.values.map((type) => DropdownMenuItem<BugReportType>(
                value: type,
                child: FText(type.category),
              )).toList(),
              onChanged: cont.selectBugType,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 30.0.r,
              underline: const SizedBox(),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInputFieldWidget(BuildContext context) {
    return Column(
      children: [
        FInputField(validator: ReportTitleValidatorCont.to),
        SizedBox(height: 20.0.h),
        FInputField(
          validator: ReportContentValidatorCont.to,
          maxLines: 10,
        ),
      ],
    );
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
            IconButton(
              onPressed: cont.saveButtonPressed,
              icon: const Icon(Icons.save_rounded),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildButtonWidget(context),
              _buildCategoryWidget(context),
              _buildInputFieldWidget(context),
              SizedBox(height: 50.0.h),
              FButton(
                text: cont.submitButtonText,
                stretch: true,
                onPressed: cont.submitButtonPressed,
              ),
            ],
          ),
        ),
      );
    });
  }

}
