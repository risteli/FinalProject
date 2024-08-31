import 'dart:collection';

import 'package:flutter/material.dart';
import 'models.dart';

import 'dart:developer';

const String configDefaultTimebox = 'default_timebox';
const String configDefaultCooldown = 'default_cooldown';

class Config {
  Config({
    this.defaultTimebox = const Duration(seconds: 30),
    this.defaultCooldown = const Duration(seconds: 30),
  });

  final Duration defaultTimebox;
  final Duration defaultCooldown;

  Config.fromMap(Map<String, String> configMap)
      : defaultTimebox =
            Duration(minutes: int.parse(configMap[configDefaultTimebox]!)),
        defaultCooldown =
            Duration(minutes: int.parse(configMap[configDefaultCooldown]!));


  @override
  String toString() {
    return "Config(defaultTimebox=$defaultTimebox,defaultCooldown=$defaultCooldown)";
  }
}

class StorageRoot extends ChangeNotifier {
  final List<Goal> _goals;
  Config _config;

  StorageRoot()
      : _goals = [],
        _config = Config();

  StorageRoot.from(List<Goal> items)
      : _goals = items,
        _config = Config();

  UnmodifiableListView<Goal> get goals => UnmodifiableListView(_goals);
  Config get config => _config;

  int get goalsLength => _goals.length;

  void loadGoals(List<Goal> goals) {
    _goals.clear();
    _goals.addAll(goals);
    notifyListeners();
  }

  void setConfig(Map<String,String> configMap) {
    _config = Config.fromMap(configMap);
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
