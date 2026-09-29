import 'package:flutter/material.dart';

class SmartList {

  final List<String> _data = [];

  // Add data
  void add(String value) {
    _data.add(value);
  }

  // Get data
  String get(int index) {
    return _data[index];
  }

  // Remove data
  void remove(int index) {
    _data.removeAt(index);
  }

  // Check is empty
  bool isEmpty() {
    return _data.isEmpty;
  }

  void printAll() {
    for (var value in _data) {
      debugPrint("List data [ $value ]");
    }
  }
}