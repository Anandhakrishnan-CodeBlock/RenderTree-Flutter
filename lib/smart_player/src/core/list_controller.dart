import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../smart_player.dart';

class ListController extends ListControls {
  ListController._internal();

  static final ListController _instance = ListController._internal();

  factory ListController() {
    return _instance;
  }

  static const double _switchMarginRatio = 1.15;
  static const Duration _defaultSettleDelay = Duration(milliseconds: 200);

  final Map<Key, double> _visibilityScores = <Key, double>{};
  final Map<Key, Duration> _visibilityDurations = <Key, Duration>{};
  Key? _pendingWinner;
  Timer? _focusSettleTimer;

  @override
  void reportVisibility({
    required Key key,
    required double score,
    Duration? duration,
    required VoidCallback evaluateFocusWinner,
  }) {
    if (score <= 0.0) {
      _visibilityScores.remove(key);
      _visibilityDurations.remove(key);
    } else {
      _visibilityScores[key] = score;
      _visibilityDurations[key] = duration ?? _defaultSettleDelay;
    }
    evaluateFocusWinner();
  }

  @override
  void clearVisibility({
    required Key key,
    required VoidCallback evaluateFocusWinner,
  }) {
    _visibilityScores.remove(key);
    _visibilityDurations.remove(key);
    if (_pendingWinner == key) {
      _pendingWinner = null;
      _focusSettleTimer?.cancel();
    }
    evaluateFocusWinner();
  }

  @override
  void evaluateFocusWinner({
    required Key? selectedKey,
    required OnWinnerCallback onWinner
  }) {
    if (_visibilityScores.isEmpty) {
      _pendingWinner = null;
      _focusSettleTimer?.cancel();
      return;
    }

    Key? candidate;
    double maxScore = 0.0;
    _visibilityScores.forEach((key, score) {
      if (score > maxScore) {
        maxScore = score;
        candidate = key;
      }
    });

    if (candidate == null || candidate == selectedKey) {
      _pendingWinner = null;
      _focusSettleTimer?.cancel();
      return;
    }

    final double currentScore = selectedKey != null ? (_visibilityScores[selectedKey] ?? 0.0) : 0.0;
    final bool clearsMargin = selectedKey == null || maxScore >= currentScore * _switchMarginRatio;

    if (!clearsMargin) return;

    if (_pendingWinner != candidate) {
      _pendingWinner = candidate;
      _focusSettleTimer?.cancel();
      final Duration settleDuration =
          _visibilityDurations[candidate] ?? _defaultSettleDelay;
      _focusSettleTimer = Timer(settleDuration, () {
        if (_pendingWinner == candidate) {
          onWinner(key: candidate!);
        }
      });
    }
  }

  @override
  void clearList() {
    _visibilityScores.clear();
    _visibilityDurations.clear();
    _pendingWinner = null;
  }
}