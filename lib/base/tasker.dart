import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';

abstract class Tasker {
  VoidCallback onFinished;
  bool cancelOrder = false;
  TaskerStatus status;
  Tasker({@required this.onFinished});

  Future<void> task();

  Future<void> start() async {
    cancelOrder = false;
    if (status == TaskerStatus.onGoing) return;
    status = TaskerStatus.onGoing;
    await task();
    status = TaskerStatus.onPause;
    if (cancelOrder == false) onFinished();
  }
}

enum TaskerStatus { onPause, onGoing }
