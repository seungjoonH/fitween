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
                  hasNotification |= json?['rivalData'].values
                      .any((data) => !data['checked']) ?? false;
                  return FIcon(
                    FIcons.values[index],
                    selected: index == globalP.navIndex,
                    hasNotification: index == 1 && hasNotification,
                  );
                },
              ),
              label: FIcons.values[index].label,
            ),
            ),
          );
        },
      ),
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
