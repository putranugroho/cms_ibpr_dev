import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cms_ibpr/pref/pref.dart';

class AutoLogoutWrapper extends StatefulWidget {
  final Widget child;
  final Duration idleDuration;
  final Future<void> Function() onIdleTimeout;

  const AutoLogoutWrapper({
    super.key,
    required this.child,
    required this.onIdleTimeout,
    this.idleDuration = const Duration(minutes: 15),
  });

  @override
  State<AutoLogoutWrapper> createState() => _AutoLogoutWrapperState();
}

class _AutoLogoutWrapperState extends State<AutoLogoutWrapper> {
  Timer? _idleTimer;
  bool _isTimeoutProcessing = false;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  DateTime? _lastSavedActivity;

  void _resetTimer() {
    if (_isTimeoutProcessing) return;

    final now = DateTime.now();

    if (_lastSavedActivity == null || now.difference(_lastSavedActivity!) >= const Duration(seconds: 30)) {
      _lastSavedActivity = now;
      Pref().setLastActivityNow();
    }

    _idleTimer?.cancel();
    _idleTimer = Timer(widget.idleDuration, () async {
      if (_isTimeoutProcessing) return;
      _isTimeoutProcessing = true;
      await widget.onIdleTimeout();
    });
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      onPointerSignal: (_) => _resetTimer(),
      child: Focus(
        autofocus: true,
        onKeyEvent: (_, __) {
          _resetTimer();
          return KeyEventResult.ignored;
        },
        child: widget.child,
      ),
    );
  }
}
