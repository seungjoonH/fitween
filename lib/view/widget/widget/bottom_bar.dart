import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/presenter/model/user/info.dart';
import 'package:fitween/presenter/model/user/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/global.dart';
import 'package:fitween/view/widget/widget/icon.dart';

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
            )),
          );
        },
      ),
    );
  }
}