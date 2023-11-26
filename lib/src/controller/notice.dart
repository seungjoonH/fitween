import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitween/global/global.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:get/get.dart';

class NoticeCont extends GetxController {
  static NoticeCont get to => Get.find<NoticeCont>();

  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;

  final _notices = <Notice>[];
  Notice? get _notice {
    List<Notice> list = _notices.where((notice) => notice.noticeable).toList();
    if (list.isEmpty) return null;
    return list.last;
  }
  bool get noticeable => _notice != null && _notice!.noticeable;
  String? get message => _notice!.message;

  void clearNotices() => _notices.clear();
  void addNotice(Notice notice) => _notices.add(notice);

  @override
  void onInit() async {
    super.onInit();
    stream = f.collection('notices').snapshots();
  }
}