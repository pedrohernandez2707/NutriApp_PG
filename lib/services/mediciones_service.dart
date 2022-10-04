import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutri_app/models/models.dart';

class MedicionesService extends ChangeNotifier{

  final String _baseUrl ='desnutriapp-default-rtdb.firebaseio.com';
  final String _firebaseToken='AIzaSyDr0sAYzHkwMm0Q0lCTBLf6pbfarXevxWo';

  final List<Medicion> medicionesLita = [];
  final List<TablaTallaEdad> tallas = [];

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

    String buscarTalla(int meses, String genero, double talla){

      String resultadoFinal = '';

      tallas.forEach((element) { 
        if(element.meses == meses) {
          if(element.genero == genero) {
            if(talla >= element.tallaInicio && talla <= element.tallaFin){
              resultadoFinal = element.resultado;
            }
          }
        } 
      });

      if(resultadoFinal != ''){
        return resultadoFinal;
      } else {
        return 'No es Posible determinar el estado Nutricional de la talla - Fuera del Intervalo';
      }

    }



    void llenarMapas(){

    tallas.add(TablaTallaEdad(meses: 0, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 45.4, tallaFin: 47.29));
    tallas.add(TablaTallaEdad(meses: 0, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 47.3, tallaFin: 49.09 ));
    tallas.add(TablaTallaEdad(meses: 0, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 49.1, tallaFin: 50.99 ));
    tallas.add(TablaTallaEdad(meses: 0, genero: 'Femenino', resultado: '1DE',   tallaInicio: 51.0, tallaFin: 52.89));
    tallas.add(TablaTallaEdad(meses: 0, genero: 'Femenino', resultado: '2DE',   tallaInicio: 52.9, tallaFin: 62));

    tallas.add(TablaTallaEdad(meses: 1, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 49.8, tallaFin: 51.69));
    tallas.add(TablaTallaEdad(meses: 1, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 51.7, tallaFin: 52.69 ));
    tallas.add(TablaTallaEdad(meses: 1, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 53.7, tallaFin: 54.59 ));
    tallas.add(TablaTallaEdad(meses: 1, genero: 'Femenino', resultado: '1DE',   tallaInicio: 55.6, tallaFin: 56.99));
    tallas.add(TablaTallaEdad(meses: 1, genero: 'Femenino', resultado: '2DE',   tallaInicio: 57.0, tallaFin: 67));

    tallas.add(TablaTallaEdad(meses: 2, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 53.0, tallaFin: 54.99));
    tallas.add(TablaTallaEdad(meses: 2, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 55.0, tallaFin: 57.09 ));
    tallas.add(TablaTallaEdad(meses: 2, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 57.10, tallaFin: 59.09 ));
    tallas.add(TablaTallaEdad(meses: 2, genero: 'Femenino', resultado: '1DE',   tallaInicio: 59.1, tallaFin: 61.09));
    tallas.add(TablaTallaEdad(meses: 2, genero: 'Femenino', resultado: '2DE',   tallaInicio: 61.1, tallaFin: 71.1));

    tallas.add(TablaTallaEdad(meses: 3, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 55.6, tallaFin: 57.69));
    tallas.add(TablaTallaEdad(meses: 3, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 57.7, tallaFin: 58.79 ));
    tallas.add(TablaTallaEdad(meses: 3, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 59.8, tallaFin: 61.89 ));
    tallas.add(TablaTallaEdad(meses: 3, genero: 'Femenino', resultado: '1DE',   tallaInicio: 61.9, tallaFin: 63.99));
    tallas.add(TablaTallaEdad(meses: 3, genero: 'Femenino', resultado: '2DE',   tallaInicio: 64.0, tallaFin: 74));

    tallas.add(TablaTallaEdad(meses: 4, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 57.8, tallaFin: 59.89));
    tallas.add(TablaTallaEdad(meses: 4, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 59.9, tallaFin: 62.09 ));
    tallas.add(TablaTallaEdad(meses: 4, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 62.1, tallaFin: 64.29 ));
    tallas.add(TablaTallaEdad(meses: 4, genero: 'Femenino', resultado: '1DE',   tallaInicio: 64.3, tallaFin: 66.39));
    tallas.add(TablaTallaEdad(meses: 4, genero: 'Femenino', resultado: '2DE',   tallaInicio: 66.4, tallaFin: 76));

    tallas.add(TablaTallaEdad(meses: 5, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 49.8, tallaFin: 51.69));
    tallas.add(TablaTallaEdad(meses: 5, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 51.7, tallaFin: 52.69 ));
    tallas.add(TablaTallaEdad(meses: 5, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 53.7, tallaFin: 54.59 ));
    tallas.add(TablaTallaEdad(meses: 5, genero: 'Femenino', resultado: '1DE',   tallaInicio: 55.6, tallaFin: 56.99));
    tallas.add(TablaTallaEdad(meses: 5, genero: 'Femenino', resultado: '2DE',   tallaInicio: 57.0, tallaFin: 67));

    tallas.add(TablaTallaEdad(meses: 6, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 61.2, tallaFin: 63.49));
    tallas.add(TablaTallaEdad(meses: 6, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 63.5, tallaFin: 65.69 ));
    tallas.add(TablaTallaEdad(meses: 6, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 65.7, tallaFin: 67.99 ));
    tallas.add(TablaTallaEdad(meses: 6, genero: 'Femenino', resultado: '1DE',   tallaInicio: 68.0, tallaFin: 70.29));
    tallas.add(TablaTallaEdad(meses: 6, genero: 'Femenino', resultado: '2DE',   tallaInicio: 70.3, tallaFin: 80));

    tallas.add(TablaTallaEdad(meses: 7, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 62.7, tallaFin: 64.99));
    tallas.add(TablaTallaEdad(meses: 7, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 65.0, tallaFin: 67.29 ));
    tallas.add(TablaTallaEdad(meses: 7, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 67.3, tallaFin: 69.59 ));
    tallas.add(TablaTallaEdad(meses: 7, genero: 'Femenino', resultado: '1DE',   tallaInicio: 69.6, tallaFin: 71.89));
    tallas.add(TablaTallaEdad(meses: 7, genero: 'Femenino', resultado: '2DE',   tallaInicio: 71.9, tallaFin: 81));

    tallas.add(TablaTallaEdad(meses: 8, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 64.0, tallaFin: 63.39));
    tallas.add(TablaTallaEdad(meses: 8, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 66.4, tallaFin: 68.69 ));
    tallas.add(TablaTallaEdad(meses: 8, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 68.7, tallaFin: 71.49 ));
    tallas.add(TablaTallaEdad(meses: 8, genero: 'Femenino', resultado: '1DE',   tallaInicio: 71.5, tallaFin: 73.49));
    tallas.add(TablaTallaEdad(meses: 8, genero: 'Femenino', resultado: '2DE',   tallaInicio: 73.5, tallaFin: 83.5));

    tallas.add(TablaTallaEdad(meses: 9, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 65.3, tallaFin: 67.69));
    tallas.add(TablaTallaEdad(meses: 9, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 67.7, tallaFin: 70.09));
    tallas.add(TablaTallaEdad(meses: 9, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 70.1, tallaFin: 72.69 ));
    tallas.add(TablaTallaEdad(meses: 9, genero: 'Femenino', resultado: '1DE',   tallaInicio: 72.7, tallaFin: 74.99));
    tallas.add(TablaTallaEdad(meses: 9, genero: 'Femenino', resultado: '2DE',   tallaInicio: 75.0, tallaFin: 85));

    tallas.add(TablaTallaEdad(meses: 10, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 66.5, tallaFin: 68.99));
    tallas.add(TablaTallaEdad(meses: 10, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 69.0, tallaFin: 71.49 ));
    tallas.add(TablaTallaEdad(meses: 10, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 71.5, tallaFin: 73.89 ));
    tallas.add(TablaTallaEdad(meses: 10, genero: 'Femenino', resultado: '1DE',   tallaInicio: 73.9, tallaFin: 76.39));
    tallas.add(TablaTallaEdad(meses: 10, genero: 'Femenino', resultado: '2DE',   tallaInicio: 76.4, tallaFin: 86.4));

    tallas.add(TablaTallaEdad(meses: 11, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 67.7, tallaFin: 70.29));
    tallas.add(TablaTallaEdad(meses: 11, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 70.3, tallaFin: 72.79 ));
    tallas.add(TablaTallaEdad(meses: 11, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 72.8, tallaFin: 75.29 ));
    tallas.add(TablaTallaEdad(meses: 11, genero: 'Femenino', resultado: '1DE',   tallaInicio: 75.3, tallaFin: 77.79));
    tallas.add(TablaTallaEdad(meses: 11, genero: 'Femenino', resultado: '2DE',   tallaInicio: 77.8, tallaFin: 87.8));

    tallas.add(TablaTallaEdad(meses: 12, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 68.9, tallaFin: 71.39));
    tallas.add(TablaTallaEdad(meses: 12, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 71.4, tallaFin: 73.99 ));
    tallas.add(TablaTallaEdad(meses: 12, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 74.0, tallaFin: 76.59 ));
    tallas.add(TablaTallaEdad(meses: 12, genero: 'Femenino', resultado: '1DE',   tallaInicio: 76.6, tallaFin: 79.19));
    tallas.add(TablaTallaEdad(meses: 12, genero: 'Femenino', resultado: '2DE',   tallaInicio: 79.2, tallaFin: 89.2));

    tallas.add(TablaTallaEdad(meses: 13, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 13, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 13, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 13, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 13, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 14, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 71.0, tallaFin: 73.69));
    tallas.add(TablaTallaEdad(meses: 14, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 73.7, tallaFin: 76.39 ));
    tallas.add(TablaTallaEdad(meses: 14, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 76.4, tallaFin: 79.09 ));
    tallas.add(TablaTallaEdad(meses: 14, genero: 'Femenino', resultado: '1DE',   tallaInicio: 79.1, tallaFin: 81.69));
    tallas.add(TablaTallaEdad(meses: 14, genero: 'Femenino', resultado: '2DE',   tallaInicio: 81.7, tallaFin: 91.7));

    tallas.add(TablaTallaEdad(meses: 15, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 72.0, tallaFin: 74.79));
    tallas.add(TablaTallaEdad(meses: 15, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 74.8, tallaFin: 77.49 ));
    tallas.add(TablaTallaEdad(meses: 15, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 77.5, tallaFin: 80.19 ));
    tallas.add(TablaTallaEdad(meses: 15, genero: 'Femenino', resultado: '1DE',   tallaInicio: 80.2, tallaFin: 82.99));
    tallas.add(TablaTallaEdad(meses: 15, genero: 'Femenino', resultado: '2DE',   tallaInicio: 83.0, tallaFin: 93.0));

    tallas.add(TablaTallaEdad(meses: 16, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 73.0, tallaFin: 75.79));
    tallas.add(TablaTallaEdad(meses: 16, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 75.8, tallaFin: 78.59 ));
    tallas.add(TablaTallaEdad(meses: 16, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 78.6, tallaFin: 81.39 ));
    tallas.add(TablaTallaEdad(meses: 16, genero: 'Femenino', resultado: '1DE',   tallaInicio: 81.4, tallaFin: 84.19));
    tallas.add(TablaTallaEdad(meses: 16, genero: 'Femenino', resultado: '2DE',   tallaInicio: 84.2, tallaFin: 94.2));

    tallas.add(TablaTallaEdad(meses: 17, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 74.0, tallaFin: 76.79));
    tallas.add(TablaTallaEdad(meses: 17, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 76.8, tallaFin: 79.69 ));
    tallas.add(TablaTallaEdad(meses: 17, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 79.7, tallaFin: 82.49 ));
    tallas.add(TablaTallaEdad(meses: 17, genero: 'Femenino', resultado: '1DE',   tallaInicio: 82.5, tallaFin: 84.39));
    tallas.add(TablaTallaEdad(meses: 17, genero: 'Femenino', resultado: '2DE',   tallaInicio: 85.4, tallaFin: 95.4));
    //
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));
    
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 45.4, tallaFin: 47.29));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 47.3, tallaFin: 49.09 ));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 49.1, tallaFin: 50.99 ));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: '1DE',   tallaInicio: 51.0, tallaFin: 52.89));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: '2DE',   tallaInicio: 52.9, tallaFin: 62));

    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 49.8, tallaFin: 51.69));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 51.7, tallaFin: 52.69 ));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 53.7, tallaFin: 54.59 ));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: '1DE',   tallaInicio: 55.6, tallaFin: 56.99));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: '2DE',   tallaInicio: 57.0, tallaFin: 67));

    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 53.0, tallaFin: 54.99));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 55.0, tallaFin: 57.09 ));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 57.10, tallaFin: 59.09 ));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: '1DE',   tallaInicio: 59.1, tallaFin: 61.09));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: '2DE',   tallaInicio: 61.1, tallaFin: 71.1));

    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 55.6, tallaFin: 57.69));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 57.7, tallaFin: 58.79 ));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 59.8, tallaFin: 61.89 ));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: '1DE',   tallaInicio: 61.9, tallaFin: 63.99));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: '2DE',   tallaInicio: 64.0, tallaFin: 74));

    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 57.8, tallaFin: 59.89));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 59.9, tallaFin: 62.09 ));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 62.1, tallaFin: 64.29 ));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: '1DE',   tallaInicio: 64.3, tallaFin: 66.39));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: '2DE',   tallaInicio: 66.4, tallaFin: 76));

    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 49.8, tallaFin: 51.69));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 51.7, tallaFin: 52.69 ));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 53.7, tallaFin: 54.59 ));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: '1DE',   tallaInicio: 55.6, tallaFin: 56.99));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: '2DE',   tallaInicio: 57.0, tallaFin: 67));

    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 61.2, tallaFin: 63.49));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 63.5, tallaFin: 65.69 ));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 65.7, tallaFin: 67.99 ));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: '1DE',   tallaInicio: 68.0, tallaFin: 70.29));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: '2DE',   tallaInicio: 70.3, tallaFin: 80));

    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 62.7, tallaFin: 64.99));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 65.0, tallaFin: 67.29 ));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 67.3, tallaFin: 69.59 ));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: '1DE',   tallaInicio: 69.6, tallaFin: 71.89));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: '2DE',   tallaInicio: 71.9, tallaFin: 81));

    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 64.0, tallaFin: 63.39));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 66.4, tallaFin: 68.69 ));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 68.7, tallaFin: 71.49 ));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: '1DE',   tallaInicio: 71.5, tallaFin: 73.49));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: '2DE',   tallaInicio: 73.5, tallaFin: 83.5));

    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 65.3, tallaFin: 67.69));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 67.7, tallaFin: 70.09));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 70.1, tallaFin: 72.69 ));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: '1DE',   tallaInicio: 72.7, tallaFin: 74.99));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: '2DE',   tallaInicio: 75.0, tallaFin: 85));

    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 66.5, tallaFin: 68.99));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 69.0, tallaFin: 71.49 ));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 71.5, tallaFin: 73.89 ));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: '1DE',   tallaInicio: 73.9, tallaFin: 76.39));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: '2DE',   tallaInicio: 76.4, tallaFin: 86.4));

    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 67.7, tallaFin: 70.29));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 70.3, tallaFin: 72.79 ));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 72.8, tallaFin: 75.29 ));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: '1DE',   tallaInicio: 75.3, tallaFin: 77.79));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: '2DE',   tallaInicio: 77.8, tallaFin: 87.8));

    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 68.9, tallaFin: 71.39));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 71.4, tallaFin: 73.99 ));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 74.0, tallaFin: 76.59 ));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: '1DE',   tallaInicio: 76.6, tallaFin: 79.19));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: '2DE',   tallaInicio: 79.2, tallaFin: 89.2));

    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 71.0, tallaFin: 73.69));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 73.7, tallaFin: 76.39 ));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 76.4, tallaFin: 79.09 ));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: '1DE',   tallaInicio: 79.1, tallaFin: 81.69));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: '2DE',   tallaInicio: 81.7, tallaFin: 91.7));

    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 72.0, tallaFin: 74.79));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 74.8, tallaFin: 77.49 ));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 77.5, tallaFin: 80.19 ));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: '1DE',   tallaInicio: 80.2, tallaFin: 82.99));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: '2DE',   tallaInicio: 83.0, tallaFin: 93.0));

    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 73.0, tallaFin: 75.79));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 75.8, tallaFin: 78.59 ));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 78.6, tallaFin: 81.39 ));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: '1DE',   tallaInicio: 81.4, tallaFin: 84.19));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: '2DE',   tallaInicio: 84.2, tallaFin: 94.2));

    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 74.0, tallaFin: 76.79));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 76.8, tallaFin: 79.69 ));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 79.7, tallaFin: 82.49 ));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: '1DE',   tallaInicio: 82.5, tallaFin: 84.39));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: '2DE',   tallaInicio: 85.4, tallaFin: 95.4));
    //
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));
    
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 74.0, tallaFin: 76.79));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 76.8, tallaFin: 79.69 ));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 79.7, tallaFin: 82.49 ));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: '1DE',   tallaInicio: 82.5, tallaFin: 84.39));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: '2DE',   tallaInicio: 85.4, tallaFin: 95.4));
    //
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));
    
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));
  }


}