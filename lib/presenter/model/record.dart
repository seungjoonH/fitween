import 'package:fitween/global/date.dart';
import 'package:fitween/global/unit.dart';
import 'package:fitween/model/class/exercises.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';

abstract class Record {
  late double _amount;
  ActivityType? _type;
  ExerciseUnit? _state;

  double get amount => _amount;
  ActivityType? get type => _type;
  ExerciseUnit? get state => _state;
  set amount(double amount) => this.amount = amount;
  set type(ActivityType? type) => this.type = type;
  set state(ExerciseUnit? state) => this.state = state;

  static Record init(
    ActivityType type, double amount,
    [ExerciseUnit? unit]
  ) {
    assert(type != ActivityType.distance || unit != null);
    assert(type != ActivityType.weight || unit != null);

    switch (type) {
      case ActivityType.calorie:
        return CalorieRecord(amount: amount);
      case ActivityType.distance:
        return DistanceRecord(
          amount: amount, state: unit!,
        );
      case ActivityType.height:
        return HeightRecord(amount: amount);
      case ActivityType.weight:
        return WeightRecord(
          amount: amount, state: unit!,
        );
    }
  }

  double convert(ExerciseUnit? unit) => amount;
}

class CalorieRecord extends Record {
  @override
  double amount = 0;

  @override
  ActivityType? type = ActivityType.calorie;

  static double from(ActivityType type, double amount) {
    double velocity = velocities[type]!.toDouble();
    return calories[type]! * (1 / velocity) * amount;
  }

  CalorieRecord({required this.amount});
}

class DistanceRecord extends Record {
  @override
  double amount = 0;

  @override
  ActivityType? type = ActivityType.distance;

  @override
  ExerciseUnit? state;

  double get step => convert(ExerciseUnit.step);
  double get minute => convert(ExerciseUnit.minute);
  double get kilometer => convert(ExerciseUnit.kilometer);

  DistanceRecord({
    required this.amount,
    required this.state,
  });

  @override
  double convert(ExerciseUnit? unit) {
    assert(ExerciseUnit.distances.contains(unit));

    double velocity = Walking.velocity * .8
        + Jogging.velocity * .1 + Running.velocity * .1;
    const double kilometerPerStep = 0.00074;

    double value = amount;
    int direction = unit!.index - state!.index;

    switch(direction) {
      case -2:
        value /= (velocity * kilometerPerStep); break;
      case -1:
        if (unit == ExerciseUnit.step) value /= kilometerPerStep;
        if (unit == ExerciseUnit.minute) value /= velocity;
        break;
      case 1:
        if (unit == ExerciseUnit.kilometer) value *= kilometerPerStep;
        if (unit == ExerciseUnit.step) value *= velocity;
        break;
      case 2:
        value *= (velocity * kilometerPerStep); break;
    }

    amount = value;
    state = unit;
    return amount;
  }
}

class HeightRecord extends Record {
  @override
  double amount = 0;

  @override
  ActivityType? type = ActivityType.height;

  int get lifeExtensionInSec => (amount * 100).ceil();
  String get lifeExtension => timeToString(lifeExtensionInSec);

  HeightRecord({required this.amount});
}

class WeightRecord extends Record {
  @override
  double amount = 0;

  @override
  ExerciseUnit? state;

  @override
  ActivityType? type = ActivityType.weight;

  double get count => convert(ExerciseUnit.count);
  double get weight => convert(ExerciseUnit.weight);

  WeightRecord({
    required this.amount,
    required this.state,
  });

  @override
  double convert(ExerciseUnit? unit) {
    assert(ExerciseUnit.weights.contains(unit));

    double value = amount;
    if (state == unit) return value;

    switch (unit) {
      case ExerciseUnit.count:
        value /= userWeight;
        break;
      case ExerciseUnit.weight:
        value *= userWeight;
        break;
      default: break;
    }

    amount = value;
    state = unit;
    return amount;
  }
}