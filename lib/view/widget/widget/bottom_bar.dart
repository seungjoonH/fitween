import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/presenter/page/exercise/input.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/icon.dart';
import 'package:fitween/view/widget/widget/text.dart';

class FBottomNavigationBar extends StatelessWidget {
  const FBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserInfoP>();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40.0)),
      child: GetBuilder<GlobalP>(
        builder: (globalP) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: FTheme.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: globalP.navIndex,
            onTap: globalP.navigate,
            items: List.generate(4, (index) => BottomNavigationBarItem(
              icon: StreamBuilder<DocumentSnapshot>(
                stream: UserNotificationP.collection
                    .doc(userP.loggedUser.uid).snapshots(),
                builder: (context, snapshot) {
                  var json = snapshot.data?.data() as Map<String, dynamic>?;
                  if (json == null) Container();
                  bool hasNotification = false;
                  hasNotification |= json?['friendData'].values
                      .any((data) => !data['checked']) ?? false;
                  hasNotification |= json?['rivalData']
                      .values.any((data) => !data['checked']) ?? false;

                  return FIcon(
                    FIcons.values[index],
                    selected: index == globalP.navIndex,
                    hasNotification: index == 1 && hasNotification,
                  );
                },
              ),
              label: FIcons.values[index].label,
            )),
          );
        },
      ),
    );
  }
}



/* 커스텀 하단 바 위젯 */
class PBottomSheetBar extends StatelessWidget {
  const PBottomSheetBar({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.vertical(
      top: Radius.circular(30.0),
    );

    return BottomSheetBar(
      locked: false,
      height: 80.0.h,
      controller: GlobalPresenter.barCont,
      borderRadiusExpanded: radius,
      isDismissable: false,
      color: FTheme.white,
      expandedBuilder: (_) => Container(
        width: double.infinity,
        height: 350.0.h,
        decoration: BoxDecoration(
          color: FTheme.white,
          border: Border.all(color: FTheme.black, width: 1.5),
          borderRadius: radius,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              width: 100.0, height: 7.0,
              decoration: BoxDecoration(
                border: Border.all(color: FTheme.black, width: 1.5),
                borderRadius: BorderRadius.circular(3.5),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FText('일일 기록 입력하기', style: textTheme.headlineSmall),
                  SizedBox(height: 10.0.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: FTheme.black, width: 1.5 * .5),
                    ),
                    child: GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1.0,
                      ),
                      children: ActivityType.values.sublist(1, 3)
                          .map((type) => RecordNavigateButton(type: type)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      collapsed: const CollapsedBottomBar(),
      body: Container(
        color: FTheme.background,
        child: body,
      ),
    );
  }
}

class CollapsedBottomBar extends StatelessWidget {
  const CollapsedBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            const Divider(height: 1.5, thickness: 1.5, color: FTheme.black),
            const SizedBox(height: 3.0),
            SizedBox(
              width: double.infinity,
              child: GetBuilder<GlobalPresenter>(
                builder: (controller) {
                  List<FIcons> icons = [
                    FIcons.homeHouse, FIcons.pencil, FIcons.star,
                  ];

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) => FIconButton(
                      icon: FIcon(icons[index],
                        selected: index == controller.navIndex,
                      ),
                      onPressed: () => controller.navigate(index),
                      backgroundColor: Colors.transparent,
                    )),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RecordNavigateButton extends StatelessWidget {
  const RecordNavigateButton({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    const asset = 'assets/image/widget/bottom_bar/';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ExerciseInput.toExerciseInput(type),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: FTheme.black, width: 1.5 * .5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('$asset${type.name}.svg'),
                SizedBox(height: 20.0.h),
                FText(type.kr, style: textTheme.labelSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
