import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:renter_tree_test/smart_player/src/controls/info_controls.dart';
import 'package:renter_tree_test/smart_player/src/controls/list_controls.dart';
import '../../smart_player.dart';

class SmartListItemWidget extends StatefulWidget {
  final Key itemKey;
  final Duration duration;
  final Widget child;
  final bool isFirst;
  final bool isLast;

  const SmartListItemWidget({
    required this.itemKey,
    this.duration = const Duration(milliseconds: 200),
    this.isFirst = false,
    this.isLast = false,
    required this.child,
  })  : assert(
  duration >= const Duration(milliseconds: 200),
  'SmartListItemWidget.duration must be at least 200ms '
      '(got $duration). Shorter buffers make it too easy for fast or '
      'boundary-jitter scrolling to repeatedly re-initialize the video '
      'player, which is expensive and visibly janky.',
  ),super(key: itemKey);

  @override
  State<SmartListItemWidget> createState() => _SmartListItemWidgetState();
}

class _SmartListItemWidgetState extends State<SmartListItemWidget> {

  final smartManager = SmartManager();

  ScrollPosition? _scrollPosition;
  SmartZoneRenderBox? _renderBox;
  bool _recomputeScheduled = false;
  bool _hasScrolledOnce = false;

  static const double _edgeTolerance = 0.5;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final scrollable = Scrollable.maybeOf(context);
    final newPosition = scrollable?.position;

    if (_scrollPosition != newPosition) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_onScroll);
    }
  }

  @override
  void didUpdateWidget(covariant SmartListItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.isFirst != widget.isFirst ||
        oldWidget.isLast != widget.isLast) {
      _scheduleRecompute();
    }
  }

  void _onScroll() {
    _hasScrolledOnce = true;
    _scheduleRecompute();
  }

  void _scheduleRecompute() {
    if (_recomputeScheduled) return;
    _recomputeScheduled = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _recomputeScheduled = false;
      final box = _renderBox;
      if (box == null || !mounted) return;

      double score = box.computeScore();

      final position = _scrollPosition;
      final bool dimensionsReady = position != null && position.hasContentDimensions;

      // Rule 2: before any real scroll, treat the list as pinned to top.
      final atTop = dimensionsReady
          ? position.pixels <= position.minScrollExtent + _edgeTolerance
          : !_hasScrolledOnce;

      // Rule 4: pinned at bottom.
      final atBottom = dimensionsReady &&
          position.pixels >= position.maxScrollExtent - _edgeTolerance;

      if (atTop && widget.isFirst) {
        score = 1.0;
      } else if (atBottom && widget.isLast) {
        score = 1.0;
      }

      // Single path — goes through the settle-duration guard every time.
      smartManager.reportVisibility(key: widget.itemKey, score: score, duration: widget.duration);

      if (!dimensionsReady && !_hasScrolledOnce) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _scheduleRecompute();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    smartManager.onDispose(key: widget.itemKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartListScope(
      child: _SmartZoneRenderObjectWidget(
        itemKey: widget.itemKey,
        onRenderObjectCreated: (box) {
          _renderBox = box;
        },
        onPainted: _scheduleRecompute,
        child: widget.child,
      ),
    );
  }
}

class _SmartZoneRenderObjectWidget extends SingleChildRenderObjectWidget {
  final Key itemKey;
  final ValueChanged<SmartZoneRenderBox> onRenderObjectCreated;
  final VoidCallback onPainted;

  const _SmartZoneRenderObjectWidget({
    required this.itemKey,
    required this.onRenderObjectCreated,
    required this.onPainted,
    required Widget child,
  }) : super(child: child);

  @override
  SmartZoneRenderBox createRenderObject(BuildContext context) {
    final box = SmartZoneRenderBox(
      itemKey: itemKey,
      onPainted: onPainted,
    );
    onRenderObjectCreated(box);
    return box;
  }

  @override
  void updateRenderObject(BuildContext context, SmartZoneRenderBox renderObject) {
    renderObject
      ..itemKey = itemKey
      ..onPainted = onPainted;
  }
}