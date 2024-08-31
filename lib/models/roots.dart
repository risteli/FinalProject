import 'dart:collection';

import 'package:flutter/material.dart';
import 'models.dart';

import 'dart:developer';

class StorageRoot extends ChangeNotifier {
  final List<Goal> _goals = [];

  StorageRoot();

  StorageRoot.from(List<Goal> items) {
    _goals.addAll(items);
  }

  UnmodifiableListView<Goal> get goals => UnmodifiableListView(_goals);

  int get goalsLength => _goals.length;

  void loadGoals(List<Goal> goals) {
    _goals.clear();
    _goals.addAll(goals);
    notifyListeners();
  }

  void addGoal(Goal value) {
    _goals.add(value);
  }

  void updateGoalAt(int index, Goal value) {
    _goals[index] = value;
    notifyListeners();
  }

  void deleteGoalAt(int index) {
    _goals.removeAt(index);
    notifyListeners();
  }

  void moveGoal(int oldIndex, int newIndex) {
    _goals.insert(newIndex, _goals.removeAt(oldIndex));
    notifyListeners();
  }

  Goal findGoalById(int? goalId) {
    return _goals.firstWhere((element) => element.id == goalId);
  }

  void clearGoals() {
    _goals.clear();
    notifyListeners();
  }
}
