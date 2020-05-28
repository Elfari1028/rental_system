import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';

abstract class Tasker {
  VoidCallback onFinished;

  TaskerStatus status;

  Tasker({@required this.onFinished});

  Future<void> task();

  Future<void> start() async {
    if (status == TaskerStatus.onGoing) return;
    status = TaskerStatus.onGoing;
    await task();
    onFinished();
    status = TaskerStatus.onPause;
  }
}

enum TaskerStatus { onPause, onGoing }
