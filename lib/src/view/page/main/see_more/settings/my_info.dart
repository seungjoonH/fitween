import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyInfoPage extends FPage {
  const MyInfoPage({super.key});

  @override
  FPageState<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends FPageState<MyInfoPage> {

  @override
  MyInfoPageCont get cont => MyInfoPageCont.to;

  TextStyle? get style => ThemeCont.to.bodySmall?.copyWith(color: ThemeCont.to.comment);
  TextStyle? get selectedStyle => ThemeCont.to.titleMedium?.copyWith(color: ThemeCont.to.text, fontWeight: FontWeight.bold);


  Widget _buildHeightSettingCardWidget(BuildContext context) {
    return Obx(() {
      if (cont.height == null) return Container();

      HeightAmount amount = HeightAmount()..cm = cont.height!;
      String altAmount = amount.ftinUnit;

      Widget child = Center(
        child: FText(
          '${cont.height!} cm',
          style: ThemeCont.to.titleMedium,
          bold: true,
        ),
      );

      if (cont.heightSettable) {
        child = Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: NumberPicker(
                haptics: true,
                onChanged: cont.onHeightChanged,
                value: cont.height!,
                minValue: cont.heightMin,
                maxValue: cont.heightMax,
                textStyle: style,
                selectedTextStyle: selectedStyle,
                itemHeight: 25.0.h,
                textMapper: (text) => '$text cm',
              ),
            ),
            if (LangCont.isEnglish)
            Positioned(
              right: 15.0.w,
              child: FText(
                '= $altAmount',
                style: ThemeCont.to.bodyLarge,
                color: ThemeCont.to.text,
              ),
            ),
          ],
        );
      }

      return FCard(
        child: SizedBox(
          height: 80.0.h,
          child: Center(child: child),
        ),
      );
    });
  }

  Widget _buildHeightWidget(BuildContext context) {
    return Column(
      children: [
        Obx(() => HeaderWidget(
          text: cont.heightText,
          icon: Icon(cont.heightSettable ? Icons.save : Icons.edit),
          onPressed: cont.heightSettingBarPressed,
        )),
        _buildHeightSettingCardWidget(context),
      ],
    );
  }

  Widget _buildWeightSettingCardWidget(BuildContext context) {
    return Obx(() {
      if (cont.weight == null) return Container();

      WeightAmount amount = WeightAmount()..kg = cont.weight!;
      String altAmount = amount.lbUnit;

      Widget child = Center(
        child: FText(
          '${cont.weight!} kg',
          style: ThemeCont.to.titleMedium,
          bold: true,
        ),
      );

      if (cont.weightSettable) {
        child = Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: NumberPicker(
                haptics: true,
                onChanged: cont.onWeightChanged,
                value: cont.weight!,
                minValue: cont.weightMin,
                maxValue: cont.weightMax,
                textStyle: style,
                selectedTextStyle: selectedStyle,
                itemHeight: 25.0.h,
                textMapper: (text) => '$text kg',
              ),
            ),
            if (LangCont.isEnglish)
            Positioned(
              right: 15.0.w,
              child: FText(
                '= $altAmount',
                style: ThemeCont.to.bodyLarge,
                color: ThemeCont.to.text,
              ),
            ),
          ],
        );
      }

      return FCard(
        child: SizedBox(
          height: 80.0.h,
          child: Center(child: child),
        ),
      );
    });
  }

  Widget _buildWeightWidget(BuildContext context) {
    return Column(
      children: [
        Obx(() => HeaderWidget(
          text: cont.weightText,
          icon: Icon(cont.weightSettable ? Icons.save : Icons.edit),
          onPressed: cont.weightSettingBarPressed,
        )),
        _buildWeightSettingCardWidget(context),
      ],
    );
  }

  Widget _buildGoalByTypeWidget(BuildContext context, FType type) {
    return Expanded(
      child: Column(
        children: [
          FText(
            type.locale.capitalize!,
            style: ThemeCont.to.titleSmall,
          ),
          FTexts(
            cont.getGoalTextOf(type),
            style: ThemeCont.to.bodySmall,
            textColor: type.color,
            highlightStyle: ThemeCont.to.titleSmall
                ?.apply(color: type.color),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsWidget(BuildContext context) {
    Widget divider = SizedBox(
      height: 50.0.h,
      child: VerticalDivider(
        width: 10.0.w,
        thickness: .5,
        color: ThemeCont.to.stroke,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: FType.activeValues.map((type) {
        return _buildGoalByTypeWidget(context, type);
      }).separateW(separator: divider),
    );
  }

  Widget _buildGoalSettingCardWidget(BuildContext context) {
    return FCard(
      pressMode: FCardPressMode.icon,
      child: _buildGoalsWidget(context),
    );
  }

  Widget _buildGoalWidget(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(
          text: cont.goalText,
          icon: const Icon(Icons.edit),
          onPressed: cont.goalSettingBarPressed,
        ),
        _buildGoalSettingCardWidget(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildHeightWidget(context),
        _buildWeightWidget(context),
        _buildGoalWidget(context),
      ].separateH(height: 20.0.h),
    );
  }


  @override
  Widget buildPage(BuildContext context) {
    return FRefreshScaffold(
      refreshController: RefreshController(),
      onRefresh: cont.onRefresh,
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }
}
