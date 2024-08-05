import '../models/collections.dart';
import '../models/models.dart';

class GoalsRepo {
  GoalsModel readAll() => GoalsModel.from(
        [
          Goal(name: 'Learn BWV772 ?', goalType: GoalType.learning, tasks: [
            Task(
                name: 'LH Reading',
                tool: {},
                estimation: Duration(minutes: 10)),
            Task(
                name: 'RH Reading',
                tool: {},
                estimation: Duration(minutes: 10)),
            Task(
                name: 'Practice C Scale',
                tool: <Tool>{StopwatchTool()},
                estimation: Duration(minutes: 10)),
            Task(
                name: 'Practice D Scale',
                tool: <Tool>{StopwatchTool()},
                estimation: Duration(minutes: 10)),
            Task(
                name: 'Practice A minor Scale',
                tool: <Tool>{StopwatchTool()},
                estimation: Duration(minutes: 10)),
            Task(
                name: 'Measures 1-4',
                tool: <Tool>{StopwatchTool()},
                estimation: Duration(minutes: 10)),
            Task(
                name: 'Measures 2-8',
                tool: <Tool>{StopwatchTool()},
                estimation: Duration(minutes: 10)),
          ]),
          Goal(
              name: 'Read Good Strategy Bad Strategy',
              goalType: GoalType.learning,
              tasks: [
                Task(
                    name: 'Chapter 1',
                    tool: {},
                    estimation: Duration(minutes: 15)),
                Task(
                    name: 'Chapter 2',
                    tool: {},
                    estimation: Duration(minutes: 15)),
              ]),
          Goal(
              name: 'Bake a traditional pie',
              goalType: GoalType.learning,
              tasks: [
                Task(
                    name: 'Buy ingredients',
                    tool: {},
                    estimation: Duration(minutes: 60)),
                Task(
                    name: 'Mix all together',
                    tool: {},
                    estimation: Duration(minutes: 15)),
                Task(name: 'Bake', tool: {}, estimation: Duration(minutes: 30)),
              ]),
        ],
      );
}
