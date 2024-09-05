import '../models/models.dart';
import '../models/roots.dart';

var goalsFixture = StorageRoot.from(
  [
    Goal(name: 'Learn BWV772 ?', goalType: GoalType.learning, tasks: [
      Task(name: 'LH Reading'),
      Task(name: 'RH Reading'),
      Task(name: 'Practice C Scale'),
      Task(name: 'Practice D Scale'),
      Task(name: 'Practice A minor Scale'),
      Task(name: 'Measures 1-4'),
      Task(name: 'Measures 2-8'),
    ]),
    Goal(
        name: 'Read Good Strategy Bad Strategy',
        goalType: GoalType.learning,
        tasks: [
          Task(name: 'Chapter 1'),
          Task(name: 'Chapter 2'),
        ]),
    Goal(name: 'Bake a traditional pie', goalType: GoalType.learning, tasks: [
      Task(name: 'Buy ingredients'),
      Task(name: 'Mix all together'),
      Task(name: 'Bake'),
    ]),
  ],
);

