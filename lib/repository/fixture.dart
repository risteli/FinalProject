import '../models/models.dart';
import '../models/roots.dart';

var goalsFixture = StorageRoot.from(
  [
    Goal(name: 'Piano: Learn BWV772', goalType: GoalType.learning, tasks: [
      Task(name: 'Harmonic analysis', status: TaskStatusValue.done),
      Task(name: 'Left Hand Reading', repeatable: true, lastRunAt: DateTime(2024, 7, 10), status: TaskStatusValue.done, duration: Duration(minutes: 90)),
      Task(name: 'Right Hand Reading', repeatable: true, lastRunAt: DateTime(2024, 7, 12), status: TaskStatusValue.stopped, duration: Duration(minutes: 43)),
      Task(name: 'Practice C Scale', repeatable: true),
      Task(name: 'Practice D Scale', repeatable: true),
      Task(name: 'Practice A minor Scale', repeatable: true),
      Task(name: 'Learn Measures 1-4 @ 45 bpm', repeatable: true),
      Task(name: 'Learn Measures 2-8 @ 45 bpm', repeatable: true),
    ]),
    Goal(
        name: 'Read "Good Strategy Bad Strategy"',
        goalType: GoalType.learning,
        tasks: [
          Task(name: 'Read Chapter 1', status: TaskStatusValue.done, lastRunAt: DateTime(2024, 7, 1), duration: Duration(minutes: 30)),
          Task(name: 'Read Chapter 2', status: TaskStatusValue.done, lastRunAt: DateTime(2024, 7, 15), duration: Duration(minutes: 20)),
          Task(name: 'Read Chapter 3'),
          Task(name: 'Read Chapter 4'),
          Task(name: 'Self-Reflection on Bad Strategies'),
        ]),
    Goal(
      name: 'Bake a traditional lemon pie',
      goalType: GoalType.building,
      tasks: [
        Task(name: 'Buy ingredients', status: TaskStatusValue.done),
        Task(name: 'Prepare dough'),
        Task(name: 'Press lemons'),
        Task(name: 'Mix all together'),
        Task(name: 'Bake'),
      ],
      deadline: DateTime(2024, 12, 25),
    ),
    Goal(
      name: 'Request German citizenship',
      goalType: GoalType.todo,
      tasks: [
        Task(name: 'Talk with officials for guidelines', status: TaskStatusValue.done),
        Task(name: 'Acquire documents', status: TaskStatusValue.done),
        Task(name: 'Get B1 certificate'),
        Task(name: 'Compile forms'),
        Task(name: 'Send to Burgeramt'),
        Task(name: 'Wait for response'),
        Task(name: 'Prepare the celebration party'),
      ],
      deadline: DateTime(2027, 5, 25),
    ),
  ],
);
