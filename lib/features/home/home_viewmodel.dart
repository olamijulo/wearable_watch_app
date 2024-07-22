import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wearable_app/app/locator.dart';
import 'package:wearable_app/model/mesage_model.dart';
import 'package:wearable_app/services/notification_service.dart';
import 'package:wearable_app/services/watch_connectivity_service.dart';

final homeViewModel =
    ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModel());

class HomeViewModel extends ChangeNotifier {
  WatchConnectivityService _watchConnectivityService =
      getIt<WatchConnectivityService>();

  NotificationService _notificationService = getIt<NotificationService>();

  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  Timer? timer;
  bool isPaused = true;
  bool isReset = false;
  bool isStopped = true;

  void messageStream() {
    _watchConnectivityService.messageStrem(
      (data) {
        log('data ${data.toString()}');
        MessageModel messageModel =
            MessageModel.fromJson(data['data']['message']);
        hours = messageModel.hours;
        minutes = messageModel.minutes;
        seconds = messageModel.seconds;
        isPaused = messageModel.isPaused;
        isReset = messageModel.isReset;
        isStopped = messageModel.isStopped;
        isStopped ? stopNotification() : null;
        isReset ? resetTimerNotification() : null;
        isPaused ? pauseNotification() : null;
        notifyListeners();
      },
    );
  }

  void timerControll() {
    MessageModel messageModel = MessageModel(
        hours: hours,
        seconds: seconds,
        minutes: minutes,
        isPaused: isPaused,
        isReset: isReset,
        isStopped: isStopped);
    _watchConnectivityService.sendMessage(messageModel.toJson());
  }

  void startTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        notifyListeners();
      } else {
        if (minutes > 0) {
          minutes--;
          seconds = 59;
          notifyListeners();
        } else {
          if (hours > 0) {
            hours--;
            minutes = 59;
            seconds = 59;
            notifyListeners();
          } else {
            timer.cancel();
            stopTimer();
            notifyListeners();
          }
        }
      }
      timerControll();
    });
    isPaused = false;
    isReset = false;
    isStopped = false;
    notifyListeners();
  }

  void pauseTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      isPaused = true;
      timerControll();
      pauseNotification();
      notifyListeners();
    }
  }

  void pauseNotification() {
    _notificationService.showNotification(
        title: 'Stop watch',
        body:
            'Timer paused at ${formatTime(hours)} :${formatTime(minutes)}: ${formatTime(seconds)}');
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    hours = 0;
    minutes = 0;
    seconds = 0;
    isPaused = true;
    isStopped = true;
    timerControll();
    stopNotification();
    notifyListeners();
  }

  void stopNotification() {
    _notificationService.showNotification(
        title: 'Stop watch', body: 'Timer stopped');
  }

  void resetTimer() {
    stopTimer();
    startTimer();
    isPaused = true;
    isReset = true;
    resetTimerNotification();
    notifyListeners();
  }

  void resetTimerNotification() {
    _notificationService.showNotification(
        title: 'Stop watch', body: 'Timer reset');
  }

  String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  void setInitialTime(int h, int m, int s) {
    hours = h;
    minutes = m;
    seconds = s;
    notifyListeners();
  }
}
