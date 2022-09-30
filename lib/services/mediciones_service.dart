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
  bool exits = false;


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

    medicionesMap.forEach((key, value) {
      final tempMedicion = Medicion.fromMap(value);
      tempMedicion.id = key;
      
      medicionesLita.clear();
      medicionesLita.add(tempMedicion);
    });

    isLoading = false;
    notifyListeners();
    return medicionesLita;
  }



}