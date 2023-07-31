import 'package:fitween/presenter/lang/language.dart';

enum Workout {
  squat, shoulderPress;
  String get kr => [
    '스쿼트', '숄더 프레스',
  ][index];
  String get local => [
    'squat', 'sldr-press',
  ][index];
}

enum WorkoutState {
  stop, ready, pause, workout, complete;
  String get message {
    String locale = Lang.locale;

    return {
      'ko': [
        '디바이스를 거치하고\n시작버튼을 눌러주세요',
        '자세를 인식할게요',
        '운동을 완료하려면\n횟수 버튼을 클릭하세요.', '',
        '완료! 수고하셨어요',
      ],
      'en': [
        'Place the device and\npress the Start button',
        'Recognizing your posture',
        'Click the count button\nto complete the exercise.', '',
        'Finished! You did a great job.',
      ]
    }[locale]![index];
  }
}
enum WorkoutStage {
  down, up;
  String get message {
    String locale = Lang.locale;

    return {
      'ko': ['내려가세요', '올라오세요'],
      'en': ['Go Up', 'Go Down'],
    }[locale]![index];
  }
}
enum WorkoutPosture {
  unbent, correct, wrong, fast;

  String get message {
    String locale = Lang.locale;

    return {
      'ko': [
        '', '잘하고 있어요!',
        '자세를 바르게 해주세요!',
        '조금만 천천히 해주세요',
      ],
      'en': [
        '', 'Great!',
        'Correct your posture!',
        'Too fast',
      ],
    }[locale]![index];
  }
}
enum HumanDistance {
  undetected, middle, near, far;

  String get message {
    String locale = Lang.locale;

    return {
      'ko': [
        '사람이 인식되지 않습니다',
        '', '너무 가까워요',
        '조금 더 가까이 와주세요',
      ],
      'en': [
        'No people are recognized',
        '', 'Too close!',
        'Too far!',
      ],
    }[locale]![index];
  }
}
enum TimerState { stop, run }