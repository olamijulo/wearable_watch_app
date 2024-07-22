import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

class FlutterOSConnectivity {
  FlutterWearOsConnectivity _flutterWearOsConnectivity =
      FlutterWearOsConnectivity();
  List<WearOsDevice> _deviceList = [];
  WearOsDevice? _selectedDevice;
  WearOSMessage? _currentMessage;
  DataItem? _dataItem;
  List<StreamSubscription<WearOSMessage>> _messageSubscriptions = [];
  List<StreamSubscription<List<DataEvent>>> _dataEventsSubscriptions = [];
  StreamSubscription<CapabilityInfo>? _connectedDeviceCapabilitySubscription;
  File? _imageFile;

  void init() {
    _flutterWearOsConnectivity.configureWearableAPI().then((_) {
      _flutterWearOsConnectivity.getConnectedDevices().then((value) {
        _updateDeviceList(value.toList());
      });
      // _flutterWearOsConnectivity
      //     .findCapabilityByName("flutter_smart_watch_connected_nodes")
      //     .then((info) {
      //   _updateDeviceList(info!.associatedDevices.toList());
      // });
      _flutterWearOsConnectivity.getAllDataItems().then(inspect);
      _connectedDeviceCapabilitySubscription = _flutterWearOsConnectivity
          .capabilityChanged(
              capabilityPathURI: Uri(
                  scheme: "wear", // Default scheme for WearOS app
                  host: "*", // Accept all path
                  path:
                      "/flutter_smart_watch_connected_nodes" // Capability path
                  ))
          .listen((info) {
        if (info.associatedDevices.isEmpty) {
          _selectedDevice = null;
        }
        _updateDeviceList(info.associatedDevices.toList());
      });
    });
  }

  _clearAllListeners() {
    _connectedDeviceCapabilitySubscription?.cancel();
  }

  void _updateDeviceList(List<WearOsDevice> devices) {
    _deviceList = devices;
    log('devices: $_deviceList');
  }
}
