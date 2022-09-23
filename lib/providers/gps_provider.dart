import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GpsProvider extends ChangeNotifier{

  StreamSubscription? streamSubscription;

  bool _isGpsEnabled = false;
  bool _isGpsPermissionGranted = false;


  bool get isGpsEnabled => _isGpsEnabled;
  bool get isGpsPermissionGranted => _isGpsPermissionGranted;

  bool get isAllGranted => _isGpsEnabled && _isGpsPermissionGranted;


  set isGpsEnabled(bool value){
    _isGpsEnabled = value;
    notifyListeners();
  }

  set isGpsPermissionGranted(bool value){
    _isGpsPermissionGranted = value;
    notifyListeners();
  }


  Future<void> init() async{

    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted()
    ]);

    _isGpsEnabled = gpsInitStatus[0];
    _isGpsPermissionGranted = gpsInitStatus[1];
    notifyListeners();
    //this.isGpsPermissionGranted = false;
  }

  Future<bool> _isPermissionGranted() async{
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async{

    final isEnabled = await Geolocator.isLocationServiceEnabled();

    streamSubscription = Geolocator.getServiceStatusStream().listen((event){
      
      final bool isEnable = (event.index == 1) ? true : false;
      _isGpsEnabled = isEnable;
      notifyListeners();
      //this.isGpsPermissionGranted = false;
    });

    return isEnabled;
  }

  Future<void> askGpsAccess() async{
    final status = await Permission.location.request();

    switch (status) {
    
      case PermissionStatus.granted:
        _isGpsPermissionGranted = true;
        notifyListeners();
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted: 
      case PermissionStatus.limited: 
      case PermissionStatus.permanentlyDenied:
        _isGpsPermissionGranted = false;
        notifyListeners();
        openAppSettings();
    }

  }


  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }






}