import 'package:final_project/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/roots.dart';

class AchievPanel extends StatelessWidget {
  const AchievPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late StorageRoot storageRoot = Provider.of<StorageRoot>(context);

    const goalTotalGoals = 20;

    final countTasks = storageRoot.countTasks();
    const goalTasksCount = 50;

    final countByGoalType = storageRoot.countByGoalType();
    const goalTargetCount = 10;

    final completedTasksByGoalType = storageRoot.completedTasksByGoalType();
    const completedTaskTargetCount = 10;

    final totalElapsed = storageRoot.totalElapsed();
    const elapsedTargetCount = Duration.secondsPerHour;

    durationToString(Duration d) =>
        "${d.inHours}h ${d.inMinutes % 60}m  ${d.inSeconds % 60}s";

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text("Your trophy room", style: TextStyle(fontSize: 30),),
        ),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: [
                    AchievWidget(
                      title: "All goals",
                      icon: Icons.emoji_events,
                      description: "Goals created:",
                      value: storageRoot.goals.length.toString(),
                      completion: storageRoot.goals.length / goalTotalGoals,
                    ),
                    AchievWidget(
                      title: "All goals",
                      icon: Icons.emoji_events,
                      description: "Tasks created:",
                      value: countTasks.toString(),
                      completion: countTasks / goalTasksCount,
                    ),
                    AchievWidget(
                      title: "All goals",
                      icon: Icons.timelapse,
                      description: "Time invested:",
                      value: durationToString(totalElapsed),
                      completion: totalElapsed.inSeconds / elapsedTargetCount,
                    ),
                    for (var goalType in GoalType.values) ...[
                      AchievWidget(
                        title: goalType.description,
                        icon: goalType.icon,
                        description: "Goals created:",
                        value: countByGoalType[goalType]!.toString(),
                        completion: countByGoalType[goalType]! / goalTargetCount,
                      ),
                      AchievWidget(
                        title: goalType.description,
                        icon: goalType.icon,
                        description: "Tasks completed:",
                        value: completedTasksByGoalType[goalType]!.toString(),
                        completion: completedTasksByGoalType[goalType]! /
                            completedTaskTargetCount,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AchievWidget extends StatelessWidget {
  const AchievWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    required this.value,
    required this.completion,
  });

  final String title;
  final IconData icon;
  final String description;
  final String value;
  final double completion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progressValueColor = colorScheme.primary;
    final progressBackgroundColor = colorScheme.onPrimary;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final size = constraints.maxWidth > constraints.maxHeight
          ? constraints.maxHeight
          : constraints.maxWidth;

      return Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: size / 10),
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: CircularProgressIndicator(
                              strokeWidth: size / 30.0,
                              color: progressValueColor,
                              backgroundColor: progressBackgroundColor,
                              value: completion,
                            ),
                          ),
                          Icon(icon, size: size / 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                description,
                style: TextStyle(fontSize: size / 12),
              ),
              Text(
                value,
                style: TextStyle(fontSize: size / 9),
              )
            ],
          ),
        ),
      );
    });
  }
}
