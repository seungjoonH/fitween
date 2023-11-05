import 'package:fitween/global/global.dart';
import 'package:fitween/oss_licenses.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OSSLicensesPage extends FPage {
  const OSSLicensesPage({super.key});

  @override
  FPageState<OSSLicensesPage> createState() => _OSSLicensesPageState();
}

class _OSSLicensesPageState extends FPageState<OSSLicensesPage> {

  @override
  OSSLicensesPageCont get cont => OSSLicensesPageCont.to;

  Widget _buildBody(BuildContext context) {
    return Obx(() => ListView.separated(
      itemCount: cont.licenses.length,
      itemBuilder: (context, index) {
        Package package = cont.licenses[index];
        return FListTile(
          title: package.name,
          subtitle: package.description,
          trailing: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FTextTag(package.version),
                SizedBox(height: 10.0.h),
                Icon(Icons.chevron_right, color: ThemeCont.to.comment),
              ],
            ),
          ],
          onPressed: () => cont.listTilePressed(package),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10.0.h),
    ));
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }

}
