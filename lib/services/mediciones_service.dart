import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutri_app/models/models.dart';

class MedicionesService extends ChangeNotifier{

  final String _baseUrl ='desnutriapp-default-rtdb.firebaseio.com';
  final String _firebaseToken='AIzaSyDr0sAYzHkwMm0Q0lCTBLf6pbfarXevxWo';

  final List<Medicion> medicionesLita = [];

  late Medicion selectedMedicion;

  bool isLoading = true;
  bool exists = false;


  Future<List<Medicion>> loadMediciones(String cui) async{
    //isLoading = true;
    //notifyListeners();

    final url = Uri.https(_baseUrl,'Mediciones.json',{
      'auth': _firebaseToken,
      'orderBy': '"cuiNinio"',
      'equalTo': '"$cui"'
    });

    final resp = await http.get(url);

    final Map<String, dynamic> medicionesMap = json.decode(resp.body);

    medicionesLita.clear();

    medicionesMap.forEach((key, value) {
      final tempMedicion = Medicion.fromMap(value);
      tempMedicion.id = key;
      
      medicionesLita.add(tempMedicion);
    });

    isLoading = false;
    notifyListeners();
    return medicionesLita;
  }


  Future saveOrCreateMedicion(Medicion medicion) async{

    isLoading = true;
    notifyListeners();

    if(exists == false){
      //Crear
      await createMedicion(medicion);
    } else {
      //actualizar
      await updateMedicion(medicion);
    }

    isLoading = false;
    notifyListeners();
  }


  Future<String> updateMedicion(Medicion medicion) async{

    final url = Uri.https(_baseUrl, 'Mediciones/${medicion.id}.json',{
      'auth': _firebaseToken
    });
    
    // ignore: unused_local_variable
    final resp = await http.put(url, body: medicion.toJson());

    //Actualizar listado de ninños
    final index = medicionesLita.indexWhere((element) => element.id == medicion.id);
    medicionesLita[index] = medicion;

    return medicion.id!;
  }


  Future<String> createMedicion(Medicion medicion) async{

    final url = Uri.https(_baseUrl, 'Mediciones.json',{
      'auth': _firebaseToken
    });
    
    final resp = await http.post(url, body: medicion.toJson());

    final decodedData = json.decode(resp.body);

    medicion.id = decodedData['name'];

    medicionesLita.add(medicion);

    return medicion.id!;
  }


  void fecha(DateTime date){
    selectedMedicion.fechaMedicion = date.toString();
    notifyListeners();
  }



}