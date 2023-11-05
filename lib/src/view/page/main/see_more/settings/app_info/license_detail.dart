import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LicenseDetailPage extends FPage {
  const LicenseDetailPage({super.key});

  @override
  FPageState<LicenseDetailPage> createState() => _LicenseDetailPageState();
}

class _LicenseDetailPageState extends FPageState<LicenseDetailPage> {

  @override
  LicenseDetailPageCont get cont => LicenseDetailPageCont.to;

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return Obx(() {
      if (cont.license == null) return const FScaffold();

      return Scaffold(
        appBar: FAppBar(text: cont.license!.name ?? ''),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0.w, vertical: 15.0.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FText(
                  cont.license!.name,
                  style: ThemeCont.to.titleSmall,
                  bold: true,
                ),
                SizedBox(height: 20.0.h),
                FTextTag(cont.license!.version),
                SizedBox(height: 20.0.h),
                FText(cont.license!.description, color: ThemeCont.to.comment, maxLines: 10),
                SizedBox(height: 20.0.h),
                Text(cont.license!.license ?? ''),
              ],
            ),
          ),
        ),
      );
    });
  }

}
