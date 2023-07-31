import 'package:fitween/global/theme.dart';
import 'package:fitween/presenter/lang/language.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ReportType {
  uiux, auth, contents, etc, qna;
  String get category {
    String locale = Lang.locale;
    if (locale != 'ko') locale = 'en';

    return <String, List<String>>{
      'ko': [
        '디자인 결함', '계정정보 연동 오류',
        '컨텐츠', '기타 오류', '문의',
      ],
      'en': [
        'Design flaws', 'Account linking errors',
        'Contents', 'Other errors', 'QNA',
      ],
    }[locale]![index];
  }
  String get guide {
    String locale = Lang.locale;
    if (locale != 'ko') locale = 'en';
    return <String, List<String>>{
      'ko': [
        '1. 위젯의 레이아웃이 깨져 보여요.\n2. 위젯의 크기가 부자연스러워요.\n3. 버튼이 보이지 않아요.\n\n위와 유사한 제보사항이 있을 경우 여기에 적어주세요.',
        '1. 계정에 문제가 생겼어요.\n2. 정보 연동에 실패했어요.\n\n위와 유사한 제보사항이 있을 경우 여기에 적어주세요.',
        '1. 챌린지 컨텐츠를 진행하는데 문제가 있어요.\n2. 타임어택 컨텐츠에서 관절 인식이 잘 되지 않아요.\n\n위와 유사한 제보사항이 있을 경우 여기에 적어주세요.',
        '오류를 발견했지만 어떤 카테고리에도 속하지 않는다면 이곳에 적어주세요.',
        '오류 이외에 기타 문의사항이 있으면 이곳에 적어주세요.',
      ],
      'en': [
        '1. The layout of the widget looks broken\n2. The size of the widget is unnatural\n3. The buttons are invisible\n\nIf you have a report similar to the above, please write it here.',
        '1. There\'s something wrong with my account\n2. I\'m having trouble linking my information\n\nIf you have a report similar to the above, please write it here.',
        '1. I\'m having trouble progressing through the challenge content.\n2. I\'m having trouble recognizing joints in the Time Attack content.\n\nIf you have a similar report to the above, please write it here.',
        'If you find an error and it doesn\'t fit into any category, please write about it here.',
        'If you have any questions than errors, please write them here.',
      ],
    }[locale]![index];
  }

  static ReportType? toEnum(String? string) =>
      values.firstWhereOrNull((type) => type.name == string);
}

enum ReportStage {
  editing, saved, requested, accepted, answered;
  String get locale {
    String locale = Lang.locale;
    if (locale != 'ko') locale = 'en';
    return {
      'ko': [
        '작성 중', '임시저장', '접수대기', '접수완료', '답변완료',
      ],
      'en': values.map((e) => e.name).toList(),
    }[locale]![index];
  }
  Color get color => [
    FTheme.white, FTheme.lightGrey, FTheme.darkGrey,
    FTheme.colorC, FTheme.colorA
  ][index];

  static ReportStage? toEnum(String? string) =>
      values.firstWhereOrNull((stage) => stage.name == string);
}