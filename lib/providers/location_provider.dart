import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutri_app/themes/theme.dart';


class LocationProvider extends ChangeNotifier{

  GoogleMapController? mapController;

  LocationProvider({
    this.isMapInitialized = false, 
    this.followUser = false}){
    getCurrPosition();
  }

  late LatLng? lastKnowLocation;

  bool isMapInitialized;
  bool followUser;



  Future<Position> getCurrPosition() async{

   final position = await Geolocator.getCurrentPosition();
   lastKnowLocation = LatLng(position.latitude, position.longitude);

   print('Posicion Actual: $position');
   
   if(lastKnowLocation?.longitude != position.longitude && lastKnowLocation?.latitude != position.latitude){ 
    lastKnowLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();
   }
   return position;
  }


  void onInitMap(GoogleMapController controller){

    isMapInitialized = true;
    mapController = controller;

    mapController!.setMapStyle(jsonEncode(uber2017) );
  }

  void moveCamera(LatLng newLocation){

    final cameraUpdate = CameraUpdate.newLatLng(newLocation);

    mapController?.animateCamera(cameraUpdate);

  }




}