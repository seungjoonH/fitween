import 'package:fitween/global/theme.dart';
import 'package:fitween/oss_licenses.dart';
import 'package:fitween/presenter/page/see_more/app_info/license/detail.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
import 'package:fitween/view/widget/widget/list_tile.dart';
import 'package:fitween/view/widget/widget/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OSSLicensePage extends StatelessWidget {
  const OSSLicensePage({super.key});

  static List<Package> loadLicenses() {
    final ossKeys = ossLicenses.toList();
    return ossKeys..sort((p1, p2) {
      return p1.name.compareTo(p2.name);
    });
  }

  static final _licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FAppBar(title: 'Licenses'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 28.0.w,
          vertical: 28.0.h,
        ),
        child: ListView.builder(
          itemCount: _licenses.length,
          itemBuilder: (context, index) {
            Package package = _licenses[index];
            return FListTile(
              title: package.name,
              tag: FTag(package.version),
              subtitle: package.description,
              trailing: const Icon(Icons.chevron_right, color: FTheme.lightGrey),
              onPressed: () => LicenseDetailP.toLicenseDetail(package),
            );
          },
        ),
      ),
    );
  }
}