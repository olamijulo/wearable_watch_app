import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class WatchConnectivityService extends ChangeNotifier {
  final watch = WatchConnectivity();

  void init() {
    isPaired();
    isReachable();
    applicationContext();
    receievedAppContext();
  }

  // Get the state of device connectivity
  Future<void> isPaired() async {
    print('paired ${await watch.isPaired}');
  }

  Future<void> isReachable() async {
    print('reachable ${await watch.isReachable}');
  }

  // Get existing data
  Future<void> applicationContext() async {
    log('application context: ${await watch.applicationContext}');
  }

  Future<void> receievedAppContext() async {
    log('receievedApp context: ${await watch.applicationContext}');
  }

  // Send data
  void sendMessage(data) {
    watch.sendMessage({
      'data': {'message': data}
    });
  }

  void updateApplicationContext(data) {
    watch.updateApplicationContext({'data': 0});
  }

  // Listen for updates
  void messageStrem(event) {
    watch.messageStream.listen(event);
  }

  set contextStrem(event) => watch.contextStream.listen(event);
}
