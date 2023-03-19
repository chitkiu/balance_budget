import 'dart:async';

import 'package:flutter/widgets.dart';

class EventScrollConfiguration extends ValueNotifier<bool> {
  bool _shouldScroll = false;
  Duration? _duration;
  Curve? _curve;

  Completer<void>? _completer;

  EventScrollConfiguration() : super(false);

  bool get shouldScroll => _shouldScroll;
  Duration? get duration => _duration;
  Curve? get curve => _curve;

  // This function will be completed once [completeScroll] is called.
  Future<void> setScrollEvent({
    required Duration? duration,
    required Curve? curve,
  }) {
    if (shouldScroll || _completer != null) return Future.value();

    _completer = Completer();

    _duration = duration;
    _curve = curve;
    _shouldScroll = true;
    value = !value;

    return _completer!.future;
  }

  void resetScrollEvent() {
    _shouldScroll = false;
    _duration = null;
    _curve = null;
  }

  void completeScroll() {
    _completer?.complete();
    _completer = null;
  }
}
