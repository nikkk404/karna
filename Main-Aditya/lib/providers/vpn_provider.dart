import 'dart:async';

import 'package:flutter/material.dart';

class VpnState with ChangeNotifier {
  bool _isConnected = false;
  Timer? _timer;
  bool get isConnected => _isConnected;

  bool _isTimerActive = false;
  bool get isTimerActive => _isTimerActive;

  Duration _timerDuration = const Duration();
  Duration get timerDuration => _timerDuration;

  void connect() {
    _isConnected = true;
    startTimer();
    notifyListeners();
  }

  void disconnect() {
    _isConnected = false;
    stopTimer();
    notifyListeners();
  }

  void toggleConnection() {
    _isConnected = !_isConnected;
    if (!_isConnected) {
      stopTimer();
    }
    notifyListeners();
  }

  void startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _timerDuration += const Duration(seconds: 1);
        notifyListeners();
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _timerDuration = const Duration();
    notifyListeners();
  }

  void _startTimerUpdate() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateTimer();
    });
  }

  void updateTimer() {
    if (_isTimerActive) {
      _timerDuration += const Duration(seconds: 1);
      notifyListeners();
    }
  }
}
