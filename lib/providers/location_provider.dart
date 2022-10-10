// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutri_app/helpers/custom_image_marker.dart';
import 'package:nutri_app/models/models.dart';
import 'package:nutri_app/themes/theme.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../services/services.dart';


class LocationProvider extends ChangeNotifier{

  GoogleMapController? mapController;

   Map<String, Marker> markers;

   LatLng? centerMap;

   List<Marcadores> marcadores =[];
   List<LatLng> latlng =[];

   final Set<Marker> misMarkers = Set();

   Ninio? ninioMarker;

  LocationProvider({
    Map<String, Marker>? markers,
    this.ninioMarker,
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
  //final String _firebaseToken='AIzaSyDr0sAYzHkwMm0Q0lCTBLf6pbfarXevxWo';

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



  Future<List<LatLng>> getMarkers(BuildContext context) async{
    final authService = AuthService().idUserToken;
    
    //isLoading = true;
    //notifyListeners();
    final ninioService = Provider.of<NiniosService>(context, listen: false);
    

    final url = Uri.https(_baseUrl, 'Marcadores.json',{
      'auth': authService
    });

    final resp = await http.get(url).then((value) async{

      final Map<String, dynamic> markersMap = json.decode(value.body);

      final imageMarker = await getassetImage();

      markersMap.forEach((key, value) {
        final tempLatLn = Marcadores.fromMap(value);
        tempLatLn.id = key;
        marcadores.add(tempLatLn);
      });

      marcadores.forEach((elementmarker) { 
          latlng.add(LatLng(elementmarker.lat, elementmarker.lng));
          
          ninioService.ninios.forEach((element) {
            if(elementmarker.cui == element.cui){
              ninioMarker = element;
              misMarkers.add(Marker(
                markerId: MarkerId(elementmarker.lat.toString() + elementmarker.lng.toString()),
                position: LatLng(elementmarker.lat, elementmarker.lng),
                icon: imageMarker,
                infoWindow: InfoWindow(
                  title: element.cui,
                  snippet: '${element.nombres} ${element.apellidos}',
                  onTap: (){
                    ninioService.selectedninio = element;
                    ninioService.exists = true;
                    Navigator.pushNamed(context, 'ninio');
                  }
                )     
              ));
            }
          });
      });

      });

    // latlng.forEach((element) {
      
    //   String cui = ninioMarker?.cui ??'';
    //   String nombres = '${ninioMarker?.nombres} ${ninioMarker?.apellidos}';

    //   misMarkers.add(Marker(
    //   markerId: MarkerId(element.latitude.toString() + element.longitude.toString()),
    //   position: element,
    //   icon: imageMarker,
    //   infoWindow: InfoWindow(
    //     title: cui != '' ? ninioMarker!.cui : '',
    //     snippet: nombres
    //   )
    //   ));
    // });

    return latlng;
  }


  Future saveOrCreateMarcador(Marcadores marcador, BuildContext context) async{

    //isSaving = true;
    //notifyListeners();

    if(marcador.id=='' || marcador.id == null){
      //Crear
      await createNinio(marcador);
    } else {
      //actualizar
      await updateNinio(marcador);
    }

    await getMarkers(context);

    notifyListeners();
  }




  Future<String> updateNinio(Marcadores marcador) async{

    final authService = AuthService().idUserToken;

    final url = Uri.https(_baseUrl, 'Marcadores/${marcador.id}.json',{
      'auth': authService
    });
    
    // ignore: unused_local_variable
    final resp = await http.put(url, body: marcador.toJson());

    //Actualizar listado de ninños
    final index = marcadores.indexWhere((element) => element.id == marcador.id);
    marcadores[index] = marcador;

    return marcador.id!;
  }


  Future<String> createNinio(Marcadores marcador) async{

    final authService = AuthService().idUserToken;

    final url = Uri.https(_baseUrl, 'Marcadores.json',{
      'auth': authService,
    });
    final resp = await http.post(url, body: marcador.toJson());

    final decodedData = json.decode(resp.body);

    marcador.id = decodedData['name'];

    marcadores.add(marcador);

    return marcador.id!;
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