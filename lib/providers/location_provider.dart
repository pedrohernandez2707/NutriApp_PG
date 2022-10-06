import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutri_app/helpers/custom_image_marker.dart';
import 'package:nutri_app/models/models.dart';
import 'package:nutri_app/themes/theme.dart';
import 'package:http/http.dart' as http;


class LocationProvider extends ChangeNotifier{

  GoogleMapController? mapController;

   Map<String, Marker> markers;

   LatLng? centerMap;

   List<Marcadores> marcadores =[];
   List<LatLng> latlng =[];

   final Set<Marker> misMarkers = new Set();

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
  bool _displayManualMarker = false;

  bool get displayManualMarker => _displayManualMarker;

  set displayManualMarker(bool value){
    _displayManualMarker = value;
    notifyListeners();
  }

  final String _baseUrl ='desnutriapp-default-rtdb.firebaseio.com';
  final String _firebaseToken='AIzaSyDr0sAYzHkwMm0Q0lCTBLf6pbfarXevxWo';

  Future<Position> getCurrPosition() async{

   final position = await Geolocator.getCurrentPosition();
   _lastKnowLocation = LatLng(position.latitude, position.longitude);

   //print('Posicion Actual: $_lastKnowLocation');
   
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



  Future<List<LatLng>> getMarkers() async{
    
    //isLoading = true;
    //notifyListeners();

    final url = Uri.https(_baseUrl, 'Marcadores.json',{
      'auth': _firebaseToken
    });

    final resp = await http.get(url);

    final Map<String, dynamic> markersMap = json.decode(resp.body);

    final imageMarker = await getassetImage();

    markersMap.forEach((key, value) {
      final tempLatLn = Marcadores.fromMap(value);
      marcadores.add(tempLatLn);
    });

    marcadores.forEach((elementmarker) { 
        latlng.add(LatLng(elementmarker.lat, elementmarker.lng));
    });

    latlng.forEach((element) {
      misMarkers.add(Marker(
      markerId: MarkerId(element.latitude.toString() + element.longitude.toString()),
      position: element,
      icon: imageMarker,
      // infoWindow: const InfoWindow(
      //   title: elementmarker.cui,
      //   snippet: 'Petter'
      // )
      ));
    });

    return latlng;
  }

  //custom markers

  Future drawMarker() async{

    final imageMarker = await getassetImage();

    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: _lastKnowLocation!,
      infoWindow: const InfoWindow(
        title: 'Hola mundo',
        snippet: 'Petter'
      ),
      icon: imageMarker

    );


    final currentMarker = Map<String, Marker>.from(markers);

    currentMarker['start'] = startMarker;

    markers = currentMarker;
    //notifyListeners();

  }



}