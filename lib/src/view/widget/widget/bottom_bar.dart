import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FBottomNavigationBar extends FWidget {
  const FBottomNavigationBar({Key? key}) : super(key: key);

  @override
  FWidgetState<FWidget> createState() => FBottomNavigationBarState();
}

class FBottomNavigationBarState extends FWidgetState<FWidget> {
  BottomBarCont get cont => BottomBarCont.to;

  @override
  Widget buildWidget(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(40.0.r),
      ),
      child: Obx(() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: ThemeCont.to.card,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: cont.pageIndex,
        onTap: cont.navigate,
        items: List.generate(4, (index) => BottomNavigationBarItem(
          icon: FIcon(
            FIcons.values[index],
            selected: index == cont.pageIndex,
          ),
          label: FIcons.values[index].label,
        )),
      ),
    ));
  }
}