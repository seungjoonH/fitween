import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/page/see_more/info_edit/info_edit.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InfoEditPage extends StatelessWidget {
  const InfoEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FTheme.white,
      appBar: const FAppBar(
        title: '정보 수정',
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: InfoEditP.backPressed,
        ),
        color: FTheme.white,
      ),
      body: GetBuilder<InfoEditP>(
        builder: (infoEditP) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 28.0.w,
              vertical: 28.0.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FText('닉네임'),
                      const SizedBox(height: 10.0),
                      Builder(
                        builder: (context) {
                          Field field = InfoEditP.fields['nickname']!;
                          return FInputField(
                            controller: field.controller,
                            invalid: field.invalid,
                            hintText: field.hintText,
                            hintColor: field.invalid
                                ? FTheme.colorB
                                : FTheme.lightGrey,
                            completed: field.completed,
                            onEditingComplete: infoEditP.updateNickname,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FText('신장'),
                          VisibilityButton(
                            state: infoEditP.heightVisibility,
                            onPressed: infoEditP.toggleHeightVisibility,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Builder(
                        builder: (context) {
                          Field field = InfoEditP.fields['height']!;
                          return FInputField(
                            controller: field.controller,
                            invalid: field.invalid,
                            hintText: field.hintText,
                            hintColor: field.invalid
                                ? FTheme.colorB
                                : FTheme.lightGrey,
                            completed: field.completed,
                            onEditingComplete: infoEditP.updateHeight,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FText('체중'),
                          VisibilityButton(
                            state: infoEditP.weightVisibility,
                            onPressed: infoEditP.toggleWeightVisibility,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Builder(
                        builder: (context) {
                          Field field = InfoEditP.fields['weight']!;
                          return FInputField(
                            controller: field.controller,
                            invalid: field.invalid,
                            hintText: field.hintText,
                            hintColor: field.invalid
                                ? FTheme.colorB
                                : FTheme.lightGrey,
                            completed: field.completed,
                            onEditingComplete: infoEditP.updateWeight,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VisibilityButton extends StatelessWidget {
  const VisibilityButton({
    Key? key,
    required this.state,
    required this.onPressed,
  }) : super(key: key);

  final bool state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    String text = '정보 ${state ? '표시' : '숨김'}';
    IconData data = state ? Icons.visibility : Icons.visibility_off;
    Color color = state ? FTheme.grey : FTheme.lightGrey;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 3.0, vertical: 1.0,
          ),
          child: Row(
            children: [
              FText(text, style: textTheme(context).bodyMedium, color: FTheme.lightGrey),
              const SizedBox(width: 5.0),
              Icon(data, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
