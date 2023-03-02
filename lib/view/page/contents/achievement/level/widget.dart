import 'package:fitween/global/number.dart';
import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/json/level.dart';
import 'package:fitween/model/enum/activity_type.dart';
import 'package:fitween/model/enum/unit.dart';
import 'package:fitween/presenter/model/json/level.dart';
import 'package:fitween/presenter/model/record.dart';
import 'package:fitween/presenter/model/user/record.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AchievementLevelView extends StatelessWidget {
  const AchievementLevelView({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserRecordP>();
    double amount = userP.loggedUser.getAmounts(type);
    Record record = Record.init(type, amount, {
      ActivityType.distance: ExerciseUnit.step,
      ActivityType.weight: ExerciseUnit.count,
    }[type]);

    List<Level> levels = LevelJsonP
        .getUnlockedLevels(type, record).reversed.toList();

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: levels.length,
        itemBuilder: (_, index) {
          double amount = levels[index].amount!;
          Record record = Record.init(type, amount, {
            ActivityType.distance: ExerciseUnit.kilometer,
            ActivityType.weight: ExerciseUnit.weight,
          }[type]);

          record.convert({
            ActivityType.distance: ExerciseUnit.step,
            ActivityType.weight: ExerciseUnit.count,
          }[type]);

          amount = record.amount;
          if (type == ActivityType.distance) amount = amount ~/ 100 * 100;

          String amountString = '${toLocalString(amount)}${type.unit}';
          String title = levels[index].title!;

          if (title.length > 10) {
            title = '${title.substring(0, title.length ~/ 3 * 2)}'
                '\n${title.substring(title.length ~/ 3 * 2, title.length)}';
          }

          return FCard(
            borderColor: FTheme.stroke,
            constraints: const BoxConstraints(minHeight: 240.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220.0,
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    levels[index].imageUrl!,
                    width: 100.0,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0,
                            ),
                            decoration: BoxDecoration(
                              color: type.color,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: FText(
                              'LVL ${levels.length - index}',
                              color: FTheme.white,
                              style: textTheme.bodyLarge,
                            ),
                          ),
                          FText(
                            '조건: $amountString',
                            color: FTheme.lightGrey,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      FText(title, maxLines: 2),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 100.0,
                        child: FText(
                          levels[index].description!,
                          color: FTheme.grey,
                          style: textTheme.bodySmall,
                          maxLines: 7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, index) => const SizedBox(height: 20.0),
      ),
    );
  }
}