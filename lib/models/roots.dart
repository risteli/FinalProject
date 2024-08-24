import 'dart:collection';

import 'package:flutter/material.dart';
import 'models.dart';

import 'dart:developer';

class GoalsModel extends ChangeNotifier {
  final List<Goal> _items = [];

  GoalsModel();

  GoalsModel.from(List<Goal> items) {
    _items.addAll(items);
  }

  UnmodifiableListView<Goal> get items => UnmodifiableListView(_items);

  void load(List<Goal> items) {
    _items.clear();
    _items.addAll(items);
    notifyListeners();
  }

  void add(Goal value) {
    _items.add(value);
    notifyListeners();
  }

  void update(int index, Goal value) {
    _items[index] = value;
    notifyListeners();
  }

  void move(int oldIndex, int newIndex) {
    _items.insert(newIndex, _items.removeAt(oldIndex));
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
