import 'package:fitween/global/theme.dart';
import 'package:fitween/oss_licenses.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LicenseDetailPage extends StatelessWidget {
  const LicenseDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Package package = Get.arguments;

    return Scaffold(
      appBar: FAppBar(title: package.name),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0.r, vertical: 20.0.r,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText(
                package.name,
                style: textTheme(context).titleSmall,
                bold: true,
              ),
              SizedBox(height: 20.0.h),
              FTag(package.version),
              SizedBox(height: 20.0.h),
              FText(package.description, color: FTheme.grey, maxLines: 10),
              SizedBox(height: 20.0.h),
              Text(package.license ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
