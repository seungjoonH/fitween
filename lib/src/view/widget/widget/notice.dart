import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';

class NoticeWidget extends StatefulWidget {
  const NoticeWidget({super.key});

  @override
  State<NoticeWidget> createState() => _NoticeWidgetState();
}

class _NoticeWidgetState extends State<NoticeWidget> {
  NoticeCont get cont => NoticeCont.to;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: cont.stream,
      builder: (context, snapshot) {
        var data = snapshot.data;
        if (data == null) return Container();

        cont.clearNotices();
        for (var doc in data.docs) {
          var json = doc.data();
          cont.addNotice(Notice.fromJson(json));
        }
        if (!cont.noticeable) return Container();
        return Container(
          width: double.infinity,
          height: 25.0.h,
          color: ThemeCont.achro5.withOpacity(.05),
          alignment: Alignment.center,
          child: Marquee(
            text: cont.message!,
            style: ThemeCont.to.bodyLarge
                ?.copyWith(color: ThemeCont.colorA),
            fadingEdgeStartFraction: .1,
            fadingEdgeEndFraction: .1,
            blankSpace: PageCont.size.width * .8,
          ),
        );
      }
    );
  }
}
