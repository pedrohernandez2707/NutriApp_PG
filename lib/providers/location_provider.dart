import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutri_app/themes/theme.dart';


class LocationProvider extends ChangeNotifier{

  GoogleMapController? mapController;

  final Map<String, Marker> markers;

  LocationProvider({
    Map<String, Marker>? markers,
    this.isMapInitialized = false, 
    this.followUser = false}) : markers = markers ?? const {}
    {
    //getCurrPosition();
  }

  LatLng? _lastKnowLocation = const LatLng(0, 0);

  LatLng? get lastKnowLocation => _lastKnowLocation;

  bool isMapInitialized;
  bool followUser;



  Future<Position> getCurrPosition() async{

   final position = await Geolocator.getCurrentPosition();
   _lastKnowLocation = LatLng(position.latitude, position.longitude);

   print('Posicion Actual: $_lastKnowLocation');
   
   if(_lastKnowLocation?.longitude != position.longitude && _lastKnowLocation?.latitude != position.latitude){ 
    _lastKnowLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();
   }

   //if(_lastKnowLocation?.longitude == position.longitude && _lastKnowLocation?.latitude == position.latitude) return position;

   if(_lastKnowLocation!.latitude != 0) notifyListeners();
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

  Future drawMarker() async{
    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: _lastKnowLocation!,
    );


    final currentMarker = Map<String, Marker>.from(markers);

    currentMarker['start'] = startMarker;
    //notifyListeners();

  }



}