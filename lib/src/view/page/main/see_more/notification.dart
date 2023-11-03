import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationPage extends FPage {
  const NotificationPage({super.key});

  @override
  FPageState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends FPageState<NotificationPage> {

  @override
  NotificationPageCont get cont => NotificationPageCont.to;
  NotificationCont get notificationCont => NotificationCont.to;

  Widget _buildNotificationTileWidget(BuildContext context, NotificationData notification) {
    return DarkPressableWidget(
      onPressed: () => cont.notificationPressed(notification),
      child: Obx(() => Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 28.0.w,
              vertical: 15.0.h,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FTexts(
                        notification.content,
                        style: ThemeCont.to.bodyLarge,
                        highlightStyle: ThemeCont.to.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        wordWrap: true,
                      ),
                      FText(
                        cont.now.difference(notification.date).ago,
                        style: ThemeCont.to.bodyMedium,
                        color: ThemeCont.to.comment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!notification.checked)
          Positioned.fill(
            child: Container(color: ThemeCont.colorA.withOpacity(.15)),
          ),
        ],
      ),
    ));
  }

  Widget _buildNotificationListWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
        children: notificationCont.notifications
            .map((data) => _buildNotificationTileWidget(context, data)).toList(),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (!notificationCont.loaded) return Container();
      return Padding(
        padding: EdgeInsets.only(top: 20.0.h),
        child: _buildNotificationListWidget(context),
      );
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      autoPadding: false,
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }

}