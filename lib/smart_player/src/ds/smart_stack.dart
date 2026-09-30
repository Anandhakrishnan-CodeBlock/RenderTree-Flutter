import 'package:flutter/material.dart';
import '../../smart_import.dart';

class SmartStack {
  SmartStack._internal();
  static final SmartStack _instance = SmartStack._internal();
  factory SmartStack() {
    return _instance;
  }

  final List<Map<Key, SmartVideoInfo>> _list = [];

  void push(Map<Key, SmartVideoInfo> value) {
    _list.add(Map<Key, SmartVideoInfo>.from(value));
    debugPrint('Push: $_list');
  }

  Map<Key, SmartVideoInfo> pop() {
    if (_list.isEmpty) return {};
    final removed = _list.removeLast();
    debugPrint('Pop: $removed');
    return removed;
  }

  Map<Key, SmartVideoInfo> top() {
    if (_list.isEmpty) {
      return {};
    }
    debugPrint('Top: ${_list.last}');
    return _list.last;
  }

  bool get isEmpty => _list.isEmpty;

  bool get isNotEmpty => _list.isNotEmpty;

  int get length => _list.length;

  @override
  String toString() => _list.toString();
}