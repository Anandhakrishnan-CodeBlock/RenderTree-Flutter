
import 'package:flutter/foundation.dart';

import '../../smart_import.dart';


abstract mixin class ListControls {
  void reportVisibility({
    required Key key,
    required double score,
    Duration? duration,
    required VoidCallback evaluateFocusWinner,
  });

  void clearVisibility({
    required Key key,
    required VoidCallback evaluateFocusWinner,
  });

  void evaluateFocusWinner({
    required Key? selectedKey,
    required OnWinnerCallback onWinner
  });

  void clearList();
}
