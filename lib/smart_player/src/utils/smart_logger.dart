import 'package:flutter/foundation.dart';
import 'package:renter_tree_test/smart_player/smart_player.dart';

class SmartLogger {
  // Private constructor to prevent instantiation
  SmartLogger._();

  // ANSI Escape Codes for console colors
  static const String _reset = '\x1B[0m';
  static const String _green = '\x1B[32m';   // Added
  static const String _yellow = '\x1B[33m';  // Cleared
  static const String _red = '\x1B[31m';     // Clear All
  static const String _cyan = '\x1B[36m';    // Current Value
  static const String _magenta = '\x1B[35m'; // Paint

  /// Log when an item or info is added (Green)
  static void added<T>(Key key, [Map<Key, T>? data]) {
    _log(
      key: key,
      color: _green,
      prefix: '[ADDED TO PLAYER]',
      data: data,
    );
  }

  /// Log when a specific item is cleared (Yellow)
  static void cleared<T>(Key key, [Map<Key, T>? data]) {
    _log(
      key: key,
      color: _yellow,
      prefix: '[CLEARED FROM PLAYER]',
      data: data,
    );
  }

  /// Log when all items/map are wiped or cleared (Red)
  static void clearAll<T>(Key? key, [Map<Key, T>? data]) {
    _log(
      key: key,
      color: _red,
      prefix: '[PLAYER CLEAR ALL]',
      data: data,
    );
  }

  /// Log the current state/value of the map (Cyan)
  static void currentValue<T>(Key key, [Map<Key, T>? data]) {
    _log(
      key: key,
      color: _cyan,
      prefix: '[PLAYER SELECTED]',
      data: data,
    );
  }

  /// Log when a render object paint phase executes (Magenta)
  static void paint<T>(Key key, [Map<Key, T>? data]) {
    _log(
      key: key,
      color: _magenta,
      prefix: '[PLAYING]',
      data: data,
    );
  }

  static void info(String tag, String data) {
    _logInfo(
      color: _magenta,
      prefix: tag,
      data: data,
    );
  }

  /// Core logger implementation
  static void _log<T>({
    required Key? key,
    required String color,
    required String prefix,
    Map<Key, T>? data,
  }) {
    // Ensures logs only print in debug mode
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('$color$prefix ${key ?? ''}');

    if (data != null && data.isNotEmpty) {
      if (key != null && data.containsKey(key)) {
        // Look up and log only the single matching item
        final value = data[key];
        if (value is SmartVideoInfo) {
          buffer.writeln('  └─ Key: $key => Video: ${value.videoUrl} Looping: ${value.looping}');
        } else {
          buffer.writeln('  └─ Key: $key => Value: $value');
        }
      } else if (key == null) {
        // Fallback summary if no specific key is target (e.g. clearAll)
        buffer.writeln('${data.length} items total in map');
      } else {
        buffer.writeln('  └─ Key: $key not found in map');
      }
    } else if (data != null && data.isEmpty) {
      buffer.writeln('Data Map: {} (Empty)');
    }

    // Reset color at the end of the log output
    buffer.write(_reset);

    // debugPrint prevents output truncation for large maps
    debugPrint(buffer.toString());
  }

  static void _logInfo({
    required String color,
    required String prefix,
    String? data,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer();
    buffer.writeln('$color$prefix $data');
    buffer.write(_reset);

    debugPrint(buffer.toString());
  }
}