enum WorkoutState {
  stop, ready, pause, workout, complete;
  String get message => [
    '디바이스를 거치하고\n시작버튼을 눌러주세요',
    '자세를 인식할게요',
    '운동을 완료하려면\n횟수 버튼을 클릭하세요.', '',
    '완료! 수고하셨어요',
  ][index];
}
enum WorkoutStage {
  down, up;
  String get message => [
    '내려가세요',
    '올라오세요',
  ][index];
}
enum WorkoutPosture {
  unbent, correct, wrong, fast;
  String get message => [
    '', '잘하고 있어요!',
    '자세를 바르게 해주세요!',
    '조금만 천천히 해주세요',
  ][index];
}
enum HumanDistance {
  undetected, middle, near, far;
  String get message => [
    '사람이 인식되지 않습니다',
    '', '너무 가까워요',
    '조금 더 가까이 와주세요',
  ][index];
}
enum TimerState { stop, run }