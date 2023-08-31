import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitween/global/string.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/src/controller/lang.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/controller/validator/validator.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

enum RegisterFieldType {
  nickname, dateOfBirth, sex, weight, height;

  String get locale => LangCont.tr('word.${name.toDashed}');
  String get unit => ['', '', '', 'kg', 'cm'][index];
}

class RegisterPage extends FPage {
  const RegisterPage({super.key});

  @override
  FPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends FPageState {

  @override
  RegisterPageCont get cont => RegisterPageCont.to;

  double get _widgetWidth => PageCont.isPortrait
      ? double.infinity
      : PageCont.size.width * .35;

  Widget _buildInputField(BuildContext context, RegisterFieldType type) {
    InputFieldValidatorCont validator = cont.getValidator(type) as InputFieldValidatorCont;

    return SizedBox(
      width: _widgetWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FText(
            type.locale.capitalize!,
            style: FTheme.titleLarge,
            color: FTheme.text,
          ),
          SizedBox(height: 10.0.h),
          FInputField(validator: validator),
        ],
      ),
    );
  }


  Widget _buildNicknameField(BuildContext context) {
    return _buildInputField(context, RegisterFieldType.nickname);
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return _buildInputField(context, RegisterFieldType.dateOfBirth);
  }

  Widget _buildSexField(BuildContext context) {
    RegisterFieldType type = RegisterFieldType.sex;
    SexValidatorCont validator = cont.getValidator(type) as SexValidatorCont;

    return SizedBox(
      width: _widgetWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FText(
            RegisterFieldType.sex.locale.capitalize!,
            style: FTheme.titleLarge,
            color: FTheme.text,
          ),
          SizedBox(height: 10.0.h),
          FSelectionButton<Sex>(
            validator: validator,
            values: Sex.values,
            interval: 20.0.w,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentWidget(BuildContext context, int index) {
    return IntrinsicHeight(
      child: Container(
        width: _widgetWidth,
        alignment: Alignment.center,
        child: FCommentText(
          cont.getComment(index),
          maxLines: 2,
          align: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildNBSCarouselPortraitWidget(BuildContext context) {
    return Column(
      children: [
        _buildNicknameField(context),
        SizedBox(height: 40.0.h),
        _buildDateOfBirthField(context),
        SizedBox(height: 40.0.h),
        _buildSexField(context),
        SizedBox(height: 40.0.h),
        _buildCommentWidget(context, 0),
      ],
    );
  }

  Widget _buildNBSCarouselLandscapeWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _buildNicknameField(context),
            SizedBox(height: 40.0.h),
            _buildDateOfBirthField(context),
          ],
        ),
        Column(
          children: [
            _buildSexField(context),
            SizedBox(height: 40.0.h),
            _buildCommentWidget(context, 0),
          ],
        ),
      ],
    );
  }

  Widget _buildNBSCarouselWidget(BuildContext context) {
    return PageCont.isPortrait
        ? _buildNBSCarouselPortraitWidget(context)
        : _buildNBSCarouselLandscapeWidget(context);
  }

  Widget _buildNumberPickerField(BuildContext context, RegisterFieldType type) {
    TextStyle? style = FTheme.bodyMedium?.copyWith(color: FTheme.comment);
    TextStyle? selectedStyle = FTheme.headlineSmall?.copyWith(color: FTheme.text);

    late Function(int) onChanged;
    late Amount amount;
    late int value;
    late int minValue;
    late int maxValue;
    late String altAmount;

    switch (type) {
      case RegisterFieldType.weight:
        onChanged = cont.onWeightChanged;
        value = cont.weight;
        amount = WeightAmount();
        amount = amount as WeightAmount;
        amount.kg = cont.weight;
        minValue = cont.weightMin;
        maxValue = cont.weightMax;
        altAmount = amount.lbUnit;
        break;
      case RegisterFieldType.height:
        onChanged = cont.onHeightChanged;
        value = cont.height;
        amount = HeightAmount();
        amount = amount as HeightAmount;
        amount.cm = cont.height;
        minValue = cont.heightMin;
        maxValue = cont.heightMax;
        altAmount = amount.ftinUnit;
        break;
      default: assert(false);
    }

    return SizedBox(
      width: PageCont.isPortrait
          ? double.infinity
          : PageCont.size.width * .35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FText(
            type.locale.capitalize!,
            style: FTheme.titleLarge,
            color: FTheme.text,
          ),
          SizedBox(height: 10.0.h),
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: NumberPicker(
                  haptics: true,
                  onChanged: onChanged,
                  value: value,
                  minValue: minValue,
                  maxValue: maxValue,
                  textStyle: style,
                  selectedTextStyle: selectedStyle,
                  itemHeight: 35.0.h,
                  textMapper: (text) => '$text ${type.unit}',
                ),
              ),
              if (LangCont.isEnglish)
              Positioned(
                right: 15.0.w,
                child: FText(
                  '= $altAmount',
                  style: FTheme.bodyLarge,
                  color: FTheme.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightNumberPicker(BuildContext context) {
    return _buildNumberPickerField(context, RegisterFieldType.weight);
  }

  Widget _buildHeightNumberPicker(BuildContext context) {
    return _buildNumberPickerField(context, RegisterFieldType.height);
  }

  Widget _buildWHCarouselPortraitWidget(BuildContext context) {
    return Column(
      children: [
        _buildWeightNumberPicker(context),
        SizedBox(height: 40.0.h),
        _buildHeightNumberPicker(context),
        SizedBox(height: 40.0.h),
        _buildCommentWidget(context, 1),
      ],
    );
  }

  Widget _buildWHCarouselLandscapeWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildWeightNumberPicker(context),
            SizedBox(height: 50.0.h),
            _buildHeightNumberPicker(context),
          ],
        ),
        Column(
          children: [
            SizedBox(height: 50.0.h),
            _buildCommentWidget(context, 1),
          ],
        ),
      ],
    );
  }

  Widget _buildWHCarouselWidget(BuildContext context) {
    return Obx(() => PageCont.isPortrait
        ? _buildWHCarouselPortraitWidget(context)
        : _buildWHCarouselLandscapeWidget(context));
  }

  EdgeInsets get _padding => EdgeInsets.symmetric(
    horizontal: 28.0.w, vertical: 28.0.h,
  );

  List<Widget> _buildCarouselWidgets(BuildContext context) => [
    _buildNBSCarouselWidget(context),
    _buildWHCarouselWidget(context),
  ].map((w) => Padding(padding: _padding, child: w)).toList();


  @override
  void initState() {
    super.initState();
    cont.init();
  }

  @override
  Widget buildPage(BuildContext context) {
    return FKeyboardUsableScaffold(
      autoPadding: false,
      backgroundColor: FTheme.backgroundAlt,
      appBar: FAppBar(
        text: cont.appBarTitle,
        backPressed: cont.backButtonPressed,
      ),
      body: CarouselSlider(
        carouselController: cont.carouselCont,
        items: _buildCarouselWidgets(context),
        options: cont.carouselOptions,
      ),
      bottomWidget: FButton(
        text: cont.nextButtonText,
        stretch: true,
        onPressed: cont.nextButtonPressed,
      ),
    );
  }

}