import 'package:fitween/global/string.dart';
import 'package:fitween/src/controller/theme.dart';
import 'package:fitween/main.dart';
import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DialogCont {
  static get _context => PageCont.context;

  static void showNetworkErrorDialog() {
    showFDialog(
      title: '네트워크 에러',
      content: FText(
        '네트워크가 연결되어 있지 않습니다.\nWifi 혹은 셀룰러 데이터를 연결한 후 앱을 이용해주세요.',
        style: ThemeCont.to.bodyMedium,
        color: ThemeCont.error,
        maxLines: 3,
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }

  static void showVersionInvalidDialog() {
    showFDialog(
      title: '버전 미호환',
      content: FText(
        '$versionNumber 버전은 더 이상 지원하지 않습니다.\n최신버전으로 업데이트 해주세요.',
        maxLines: 2,
        style: ThemeCont.to.bodyMedium,
      ),
      type: DialogType.mono,
      onPressed: Get.back,
    );
  }

  static void _showReallyRemoveDialog<T extends Model>(
    T t, String text, DAO<T> dao, [Widget? underContent]
  ) async {
    bool accepted = await showFDialog(
      title: '$text 삭제',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FText(
            '해당 ${withEulReul(text)}\n정말 삭제하시겠습니까?',
            style: ThemeCont.to.titleSmall!,
            maxLines: 0,
          ),
          if (underContent != null)
          Column(
            children: [
              SizedBox(height: 10.0.h),
              underContent,
            ],
          ),
        ],
      ),
      type: DialogType.bi,
      rightText: '삭제',
      rightBackgroundColor: ThemeCont.error,
    );

    if (!accepted) return;

    LoadingCont.start();
    await dao.removeOne(t);
    LoadingCont.end();

    await showFDialog(
    title: '$text 삭제 완료',
    content: FText('${withIGa(text)} 삭제되었습니다', maxLines: 0),
    type: DialogType.mono,
    );
  }

  static void showReallyRemovePartyDialog(Party party) async {
    String text = '파티';
    DAO<Party> dao = PartyDAO();
    Widget underContent = Builder(
      builder: (context) {
        TextStyle? style = ThemeCont.to.bodySmall;
        String code = party.key;
        String nickname = party.leader.nickname;
        int memberCount = party.memberUids.length;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FText('코드: $code', style: style, color: ThemeCont.to.comment),
              FText('리더: $nickname', style: style, color: ThemeCont.to.comment),
              FText('인원 수: $memberCount', style: style, color: ThemeCont.to.comment),
            ],
          ),
        );
      },
    );
    _showReallyRemoveDialog<Party>(party, text, dao, underContent);
  }


  static Future showResponseTimeoutErrorDialog() async {
    await showFDialog(
      title: '응답시간 초과',
      content: FText(
        '응답시간이 초과되었습니다.\n네트워크를 확인해주세요.',
        maxLines: 2,
        style: textTheme(_context).bodyMedium,
      ),
      type: DialogType.mono,
    );
    AuthCont.fLogout();
    FRoute.toLogin();
  }
}