import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutri_app/models/models.dart';

class MedicionesService extends ChangeNotifier{

  final String _baseUrl ='desnutriapp-default-rtdb.firebaseio.com';
  final String _firebaseToken='AIzaSyDr0sAYzHkwMm0Q0lCTBLf6pbfarXevxWo';

  final List<Medicion> medicionesLita = [];
  final List<TablaTallaEdad> tallas = [];
  final List<TablaPesoEdad> pesos = [];

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


    String buscarPeso(int meses, String genero, double peso){

      String resultadoFinal = '';

      pesos.forEach((element) { 
        if(element.meses == meses) {
          if(element.genero == genero) {
            if(peso >= element.pesoInicio && peso <= element.pesoFin){
              resultadoFinal = element.resultado;
            }
          }
        } 
      });

      if(resultadoFinal != ''){
        return resultadoFinal;
      } else {
        return 'No es Posible determinar el estado Nutricional del peso - Fuera del Intervalo';
      }

    }




    void llenarTallas(){

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
    
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 74.9, tallaFin: 75.79));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 75.8, tallaFin: 80.69 ));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 80.7, tallaFin: 83.59 ));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: '1DE',   tallaInicio: 83.6, tallaFin: 86.49));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Femenino', resultado: '2DE',   tallaInicio: 86.5, tallaFin: 96.5));
    
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 75.8, tallaFin: 78.79));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 78.8, tallaFin: 81.69 ));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 81.7, tallaFin: 84.69 ));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: '1DE',   tallaInicio: 84.7, tallaFin: 87.59));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Femenino', resultado: '2DE',   tallaInicio: 87.6, tallaFin: 97.6));

    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 76.7, tallaFin: 79.69));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 79.7, tallaFin: 82.69 ));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 82.7, tallaFin: 85.69 ));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: '1DE',   tallaInicio: 85.7, tallaFin: 88.69));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Femenino', resultado: '2DE',   tallaInicio: 88.7, tallaFin: 98.7));

    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 77.5, tallaFin: 80.59));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 80.6, tallaFin: 83.69 ));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 83.7, tallaFin: 86.69 ));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: '1DE',   tallaInicio: 86.7, tallaFin: 89.79));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Femenino', resultado: '2DE',   tallaInicio: 89.8, tallaFin: 99.8));

    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 78.4, tallaFin: 81.39));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 81.4, tallaFin: 84.59 ));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 84.6, tallaFin: 87.69 ));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: '1DE',   tallaInicio: 87.7, tallaFin: 90.79));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Femenino', resultado: '2DE',   tallaInicio: 90.8, tallaFin: 100.8));

    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 79.2, tallaFin: 82.29));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 82.3, tallaFin: 85.49 ));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 85.5, tallaFin: 88.69 ));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: '1DE',   tallaInicio: 88.7, tallaFin: 91.89));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Femenino', resultado: '2DE',   tallaInicio: 91.9, tallaFin: 101.9));

    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 80.0, tallaFin: 82.19));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 83.2, tallaFin: 86.39 ));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 86.4, tallaFin: 89.59 ));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: '1DE',   tallaInicio: 89.6, tallaFin: 92.89));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Femenino', resultado: '2DE',   tallaInicio: 92.9, tallaFin: 102.9));

    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 80.0, tallaFin: 82.29));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 83.3, tallaFin: 86.59 ));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 86.6, tallaFin: 89.89 ));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: '1DE',   tallaInicio: 89.9, tallaFin: 93.09));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Femenino', resultado: '2DE',   tallaInicio: 93.1, tallaFin: 103.1));

    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 80.8, tallaFin: 84.09));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 84.1, tallaFin: 87.39 ));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 87.4, tallaFin: 90.79 ));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: '1DE',   tallaInicio: 90.8, tallaFin: 94.09));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Femenino', resultado: '2DE',   tallaInicio: 94.1, tallaFin: 104.1));

    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 81.5, tallaFin: 84.89));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 84.9, tallaFin: 88.29 ));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 88.3, tallaFin: 91.69 ));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: '1DE',   tallaInicio: 91.7, tallaFin: 94.99));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Femenino', resultado: '2DE',   tallaInicio: 95, tallaFin: 105));

    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 82.2, tallaFin: 85.69));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 85.7, tallaFin: 89.09 ));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 89.1, tallaFin: 92.49 ));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: '1DE',   tallaInicio: 92.5, tallaFin: 95.99));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Femenino', resultado: '2DE',   tallaInicio: 96.0, tallaFin: 106));

    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 82.9, tallaFin: 86.39));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 86.4, tallaFin: 89.89 ));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 89.9, tallaFin: 93.39 ));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: '1DE',   tallaInicio: 93.4, tallaFin: 96.89));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Femenino', resultado: '2DE',   tallaInicio: 96.9, tallaFin: 106.9));

    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 83.6, tallaFin: 87.09));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 87.1, tallaFin: 90.69 ));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 90.7, tallaFin: 94.19 ));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: '1DE',   tallaInicio: 94.2, tallaFin: 97.69));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Femenino', resultado: '2DE',   tallaInicio: 97.7, tallaFin: 107.7));

    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 84.3, tallaFin: 87.89));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 87.9, tallaFin: 91.39 ));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 91.4, tallaFin: 94.99 ));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: '1DE',   tallaInicio: 95.0, tallaFin: 98.59));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Femenino', resultado: '2DE',   tallaInicio: 98.6, tallaFin: 108.6));

    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 84.9, tallaFin: 88.59));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 88.6, tallaFin: 92.19 ));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 92.2, tallaFin: 95.79 ));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: '1DE',   tallaInicio: 95.8, tallaFin: 99.39));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Femenino', resultado: '2DE',   tallaInicio: 99.4, tallaFin: 109.4));

    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 85.6, tallaFin: 89.29));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 89.3, tallaFin: 92.89 ));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 92.9, tallaFin: 96.59 ));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: '1DE',   tallaInicio: 96.6, tallaFin: 100.29));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Femenino', resultado: '2DE',   tallaInicio: 100.3, tallaFin: 110.3));

    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 86.2, tallaFin: 89.89));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 89.9, tallaFin: 93.59));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 93.6, tallaFin: 97.39 ));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: '1DE',   tallaInicio: 97.4, tallaFin: 101.09));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Femenino', resultado: '2DE',   tallaInicio: 101.1, tallaFin: 111.1));

    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 86.8, tallaFin: 90.59));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 90.6, tallaFin: 94.39 ));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 94.4, tallaFin: 98.09 ));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: '1DE',   tallaInicio: 98.1, tallaFin: 101.89));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Femenino', resultado: '2DE',   tallaInicio: 101.9, tallaFin: 111.9));

    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 87.4, tallaFin: 92.19));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 91.2, tallaFin: 95.09 ));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 95.1, tallaFin: 98.89 ));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: '1DE',   tallaInicio: 98.9, tallaFin: 102.69));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Femenino', resultado: '2DE',   tallaInicio: 102.7, tallaFin: 112.7));

    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 88.0, tallaFin: 91.39));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 91.4, tallaFin: 95.69 ));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 95.7, tallaFin: 99.59 ));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: '1DE',   tallaInicio: 99.6, tallaFin: 103.39));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Femenino', resultado: '2DE',   tallaInicio: 103.4, tallaFin: 113.4));

    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 88.6, tallaFin: 92.49));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 92.5, tallaFin: 95.39 ));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 96.4, tallaFin: 100.29 ));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: '1DE',   tallaInicio: 100.3, tallaFin: 104.19));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Femenino', resultado: '2DE',   tallaInicio: 104.2, tallaFin: 114.2));

    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 89.2, tallaFin: 93.09));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 93.1, tallaFin: 97.09 ));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 97.1, tallaFin: 100.99 ));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: '1DE',   tallaInicio: 101.0, tallaFin: 104.99));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Femenino', resultado: '2DE',   tallaInicio: 105.0, tallaFin: 115));

    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 89.8, tallaFin: 93.79));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 93.8, tallaFin: 97.69 ));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 97.7, tallaFin: 101.69 ));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: '1DE',   tallaInicio: 101.7, tallaFin: 105.69));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Femenino', resultado: '2DE',   tallaInicio: 105.7, tallaFin: 115.7));

    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 90.4, tallaFin: 94.39));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 94.4, tallaFin: 98.39 ));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 98.4, tallaFin: 102.39 ));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: '1DE',   tallaInicio: 102.4, tallaFin: 106.39));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Femenino', resultado: '2DE',   tallaInicio: 106.4, tallaFin: 116.4));

    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 90.9, tallaFin: 94.99));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 95.0, tallaFin: 98.99 ));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 99.0, tallaFin: 103.09 ));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: '1DE',   tallaInicio: 103.1, tallaFin: 107.19));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Femenino', resultado: '2DE',   tallaInicio: 107.2, tallaFin: 117.2));
    
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 91.5, tallaFin: 95.59));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 95.6, tallaFin: 99.69 ));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 99.7, tallaFin: 103.79 ));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: '1DE',   tallaInicio: 103.8, tallaFin: 107.89));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Femenino', resultado: '2DE',   tallaInicio: 107.9, tallaFin: 117.9));
    
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 92.0, tallaFin: 96.19));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 96.2, tallaFin: 100.29 ));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 100.3, tallaFin: 104.49 ));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: '1DE',   tallaInicio: 104.5, tallaFin: 108.59));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Femenino', resultado: '2DE',   tallaInicio: 108.6, tallaFin: 119.6));

    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 92.5, tallaFin: 96.69));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 96.7, tallaFin: 100.89 ));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 100.9, tallaFin: 105.09 ));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: '1DE',   tallaInicio: 105.1, tallaFin: 109.29));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Femenino', resultado: '2DE',   tallaInicio: 109.3, tallaFin: 119.3));

    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 93.1, tallaFin: 97.29));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 97.3, tallaFin: 101.49 ));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 101.5, tallaFin: 105.79 ));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: '1DE',   tallaInicio: 105.8, tallaFin: 109.99));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Femenino', resultado: '2DE',   tallaInicio: 110, tallaFin: 120));

    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 93.6, tallaFin: 97.89));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 97.9, tallaFin: 102.09 ));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 102.1, tallaFin: 106.39 ));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: '1DE',   tallaInicio: 106.4, tallaFin: 109.69));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Femenino', resultado: '2DE',   tallaInicio: 110.7, tallaFin: 120.7));

    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 94.1, tallaFin: 98.39));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 98.4, tallaFin: 102.69 ));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 102.7, tallaFin: 106.99 ));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: '1DE',   tallaInicio: 107.0, tallaFin: 111.29));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Femenino', resultado: '2DE',   tallaInicio: 111.3, tallaFin: 121.3));

    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 94.6, tallaFin: 98.99));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 99.0, tallaFin: 103.29 ));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 103.3, tallaFin: 107.69 ));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: '1DE',   tallaInicio: 107.7, tallaFin: 111.99));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Femenino', resultado: '2DE',   tallaInicio: 112.0, tallaFin: 122));

    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 95.1, tallaFin: 99.49));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 99.5, tallaFin: 103.89 ));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 103.9, tallaFin: 108.29 ));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: '1DE',   tallaInicio: 108.3, tallaFin: 112.69));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Femenino', resultado: '2DE',   tallaInicio: 112.7, tallaFin: 122.7));
    //
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 95.6, tallaFin: 100.09));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 100.1, tallaFin: 103.49 ));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 104.5, tallaFin: 109.89 ));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: '1DE',   tallaInicio: 108.9, tallaFin: 112.29));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Femenino', resultado: '2DE',   tallaInicio: 113.3, tallaFin: 123.3));
    
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 96.1, tallaFin: 100.59));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 100.6, tallaFin: 104.99 ));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 105.0, tallaFin: 108.49 ));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: '1DE',   tallaInicio: 109.5, tallaFin: 113.99));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Femenino', resultado: '2DE',   tallaInicio: 114.0, tallaFin: 124));

    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 96.6, tallaFin: 101.09));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 101.1, tallaFin: 105.59 ));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 105.6, tallaFin: 110.09 ));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: '1DE',   tallaInicio: 110.1, tallaFin: 114.59));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Femenino', resultado: '2DE',   tallaInicio: 114.6, tallaFin: 124.6));

    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 97.1, tallaFin: 101.59));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 101.6, tallaFin: 106.19 ));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 106.2, tallaFin: 110.69 ));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: '1DE',   tallaInicio: 110.7, tallaFin: 115.19));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Femenino', resultado: '2DE',   tallaInicio: 115.2, tallaFin: 125.2));

    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 97.6, tallaFin: 102.19));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 102.2, tallaFin: 106.69 ));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 106.7, tallaFin: 111.29 ));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: '1DE',   tallaInicio: 111.3, tallaFin: 115.89));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Femenino', resultado: '2DE',   tallaInicio: 115.9, tallaFin: 125.9));

    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 98.1, tallaFin: 102.69));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 102.7, tallaFin: 107.29 ));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 107.3, tallaFin: 111.89 ));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: '1DE',   tallaInicio: 111.9, tallaFin: 116.49));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Femenino', resultado: '2DE',   tallaInicio: 116.5, tallaFin: 126.5));

    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 98.5, tallaFin: 103.19));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 103.2, tallaFin: 107.79 ));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 107.8, tallaFin: 112.49 ));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: '1DE',   tallaInicio: 112.5, tallaFin: 117.09));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Femenino', resultado: '2DE',   tallaInicio: 117.1, tallaFin: 127.1));

    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 99, tallaFin: 103.69));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 103.7, tallaFin: 108.39 ));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 108.4, tallaFin: 112.99 ));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: '1DE',   tallaInicio: 113.0, tallaFin: 117.69));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Femenino', resultado: '2DE',   tallaInicio: 117.7, tallaFin: 127.7));

    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 99.5, tallaFin: 104.19));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 104.2, tallaFin: 108.89 ));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 108.9, tallaFin: 113.59 ));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: '1DE',   tallaInicio: 113.6, tallaFin: 118.29));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Femenino', resultado: '2DE',   tallaInicio: 118.3, tallaFin: 128.3));

    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: '-2DE',  tallaInicio: 99.9, tallaFin: 104.69));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: '-1DE',  tallaInicio: 104.7, tallaFin: 109.39 ));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: 'MEDIA', tallaInicio: 109.4, tallaFin: 114.19 ));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: '1DE',   tallaInicio: 114.2, tallaFin: 118.89));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Femenino', resultado: '2DE',   tallaInicio: 118.9, tallaFin: 128.9));

    
    
    //***********************MASCULINO */********************** */ */



    tallas.add(TablaTallaEdad(meses: 0, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 46.1, tallaFin: 47.99));
    tallas.add(TablaTallaEdad(meses: 0, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 48.0, tallaFin: 49.89 ));
    tallas.add(TablaTallaEdad(meses: 0, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 49.9, tallaFin: 51.79 ));
    tallas.add(TablaTallaEdad(meses: 0, genero: 'Masculino', resultado: '1DE',   tallaInicio: 51.8, tallaFin: 53.69));
    tallas.add(TablaTallaEdad(meses: 0, genero: 'Masculino', resultado: '2DE',   tallaInicio: 53.7, tallaFin: 63.7));

    tallas.add(TablaTallaEdad(meses: 1, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 50.8, tallaFin: 52.79));
    tallas.add(TablaTallaEdad(meses: 1, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 52.8, tallaFin: 54.69 ));
    tallas.add(TablaTallaEdad(meses: 1, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 54.7, tallaFin: 56.69 ));
    tallas.add(TablaTallaEdad(meses: 1, genero: 'Masculino', resultado: '1DE',   tallaInicio: 56.7, tallaFin: 58.59));
    tallas.add(TablaTallaEdad(meses: 1, genero: 'Masculino', resultado: '2DE',   tallaInicio: 58.6, tallaFin:68.6));

    tallas.add(TablaTallaEdad(meses: 2, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 54.4, tallaFin: 56.39));
    tallas.add(TablaTallaEdad(meses: 2, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 56.4, tallaFin: 58.39 ));
    tallas.add(TablaTallaEdad(meses: 2, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 58.4, tallaFin: 64.39 ));
    tallas.add(TablaTallaEdad(meses: 2, genero: 'Masculino', resultado: '1DE',   tallaInicio: 60.4, tallaFin: 62.39));
    tallas.add(TablaTallaEdad(meses: 2, genero: 'Masculino', resultado: '2DE',   tallaInicio: 62.4, tallaFin: 72.4));

    tallas.add(TablaTallaEdad(meses: 3, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 57.3, tallaFin: 59.39));
    tallas.add(TablaTallaEdad(meses: 3, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 59.4, tallaFin: 61.39 ));
    tallas.add(TablaTallaEdad(meses: 3, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 61.4, tallaFin: 63.49 ));
    tallas.add(TablaTallaEdad(meses: 3, genero: 'Masculino', resultado: '1DE',   tallaInicio: 63.5, tallaFin: 65.49));
    tallas.add(TablaTallaEdad(meses: 3, genero: 'Masculino', resultado: '2DE',   tallaInicio: 65.5, tallaFin: 75.5));

    tallas.add(TablaTallaEdad(meses: 4, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 59.7, tallaFin: 61.79));
    tallas.add(TablaTallaEdad(meses: 4, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 61.8, tallaFin: 63.89 ));
    tallas.add(TablaTallaEdad(meses: 4, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 63.9, tallaFin: 65.99 ));
    tallas.add(TablaTallaEdad(meses: 4, genero: 'Masculino', resultado: '1DE',   tallaInicio: 66.0, tallaFin: 67.99));
    tallas.add(TablaTallaEdad(meses: 4, genero: 'Masculino', resultado: '2DE',   tallaInicio: 68.0, tallaFin:78));

    tallas.add(TablaTallaEdad(meses: 5, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 61.7, tallaFin: 63.79));
    tallas.add(TablaTallaEdad(meses: 5, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 63.8, tallaFin: 65.89 ));
    tallas.add(TablaTallaEdad(meses: 5, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 65.9, tallaFin: 67.99 ));
    tallas.add(TablaTallaEdad(meses: 5, genero: 'Masculino', resultado: '1DE',   tallaInicio: 68.0, tallaFin: 70.09));
    tallas.add(TablaTallaEdad(meses: 5, genero: 'Masculino', resultado: '2DE',   tallaInicio: 70.1, tallaFin: 80.1));

    tallas.add(TablaTallaEdad(meses: 6, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 63.29, tallaFin: 65.49));
    tallas.add(TablaTallaEdad(meses: 6, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 65.5, tallaFin: 67.59 ));
    tallas.add(TablaTallaEdad(meses: 6, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 67.6, tallaFin: 69.79 ));
    tallas.add(TablaTallaEdad(meses: 6, genero: 'Masculino', resultado: '1DE',   tallaInicio: 69.8, tallaFin: 71.89));
    tallas.add(TablaTallaEdad(meses: 6, genero: 'Masculino', resultado: '2DE',   tallaInicio: 71.9, tallaFin: 81.9));

    tallas.add(TablaTallaEdad(meses: 7, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 64.8, tallaFin: 66.99));
    tallas.add(TablaTallaEdad(meses: 7, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 67.0, tallaFin: 69.19 ));
    tallas.add(TablaTallaEdad(meses: 7, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 69.2, tallaFin: 71.29 ));
    tallas.add(TablaTallaEdad(meses: 7, genero: 'Masculino', resultado: '1DE',   tallaInicio: 71.3, tallaFin: 73.49));
    tallas.add(TablaTallaEdad(meses: 7, genero: 'Masculino', resultado: '2DE',   tallaInicio: 73.5, tallaFin: 83.5));

    tallas.add(TablaTallaEdad(meses: 8, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 66.2, tallaFin: 68.39));
    tallas.add(TablaTallaEdad(meses: 8, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 68.4, tallaFin: 70.59 ));
    tallas.add(TablaTallaEdad(meses: 8, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 70.6, tallaFin: 72.79 ));
    tallas.add(TablaTallaEdad(meses: 8, genero: 'Masculino', resultado: '1DE',   tallaInicio: 72.8, tallaFin: 74.99));
    tallas.add(TablaTallaEdad(meses: 8, genero: 'Masculino', resultado: '2DE',   tallaInicio: 75.0, tallaFin: 85.0));

    tallas.add(TablaTallaEdad(meses: 9, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 67.5, tallaFin: 69.69));
    tallas.add(TablaTallaEdad(meses: 9, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 69.7, tallaFin: 71.99));
    tallas.add(TablaTallaEdad(meses: 9, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 72.0, tallaFin: 74.19 ));
    tallas.add(TablaTallaEdad(meses: 9, genero: 'Masculino', resultado: '1DE',   tallaInicio: 74.2, tallaFin: 76.49));
    tallas.add(TablaTallaEdad(meses: 9, genero: 'Masculino', resultado: '2DE',   tallaInicio: 76.5, tallaFin: 86.5));

    tallas.add(TablaTallaEdad(meses: 10, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 68.7, tallaFin: 70.99));
    tallas.add(TablaTallaEdad(meses: 10, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 71.0, tallaFin: 73.29 ));
    tallas.add(TablaTallaEdad(meses: 10, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 73.3, tallaFin: 75.59 ));
    tallas.add(TablaTallaEdad(meses: 10, genero: 'Masculino', resultado: '1DE',   tallaInicio: 75.6, tallaFin: 77.89));
    tallas.add(TablaTallaEdad(meses: 10, genero: 'Masculino', resultado: '2DE',   tallaInicio: 77.9, tallaFin: 87.9));

    tallas.add(TablaTallaEdad(meses: 11, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 69.9, tallaFin: 72.19));
    tallas.add(TablaTallaEdad(meses: 11, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.2, tallaFin: 74.49 ));
    tallas.add(TablaTallaEdad(meses: 11, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 74.5, tallaFin: 76.89 ));
    tallas.add(TablaTallaEdad(meses: 11, genero: 'Masculino', resultado: '1DE',   tallaInicio: 76.9, tallaFin: 79.19));
    tallas.add(TablaTallaEdad(meses: 11, genero: 'Masculino', resultado: '2DE',   tallaInicio: 79.2, tallaFin: 89.2));

    tallas.add(TablaTallaEdad(meses: 12, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 71.0, tallaFin: 73.39));
    tallas.add(TablaTallaEdad(meses: 12, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 73.4, tallaFin: 75.69 ));
    tallas.add(TablaTallaEdad(meses: 12, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.7, tallaFin: 78.09 ));
    tallas.add(TablaTallaEdad(meses: 12, genero: 'Masculino', resultado: '1DE',   tallaInicio: 78.1, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 12, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 13, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 72.1, tallaFin: 74.49));
    tallas.add(TablaTallaEdad(meses: 13, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 74.5, tallaFin: 76.89 ));
    tallas.add(TablaTallaEdad(meses: 13, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 76.9, tallaFin: 79.29 ));
    tallas.add(TablaTallaEdad(meses: 13, genero: 'Masculino', resultado: '1DE',   tallaInicio: 79.3, tallaFin: 81.79));
    tallas.add(TablaTallaEdad(meses: 13, genero: 'Masculino', resultado: '2DE',   tallaInicio: 81.8, tallaFin: 91.8));

    tallas.add(TablaTallaEdad(meses: 14, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 73.1, tallaFin: 75.59));
    tallas.add(TablaTallaEdad(meses: 14, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 75.6, tallaFin: 77.99 ));
    tallas.add(TablaTallaEdad(meses: 14, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 78.0, tallaFin: 80.49 ));
    tallas.add(TablaTallaEdad(meses: 14, genero: 'Masculino', resultado: '1DE',   tallaInicio: 80.5, tallaFin: 82.99));
    tallas.add(TablaTallaEdad(meses: 14, genero: 'Masculino', resultado: '2DE',   tallaInicio: 83.0, tallaFin: 93.0));

    tallas.add(TablaTallaEdad(meses: 15, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 74.1, tallaFin: 76.59));
    tallas.add(TablaTallaEdad(meses: 15, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 76.6, tallaFin: 79.09 ));
    tallas.add(TablaTallaEdad(meses: 15, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 79.1, tallaFin: 81.69 ));
    tallas.add(TablaTallaEdad(meses: 15, genero: 'Masculino', resultado: '1DE',   tallaInicio: 81.7, tallaFin: 84.19));
    tallas.add(TablaTallaEdad(meses: 15, genero: 'Masculino', resultado: '2DE',   tallaInicio: 84.2, tallaFin: 94.2));

    tallas.add(TablaTallaEdad(meses: 16, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 75.0, tallaFin: 77.59));
    tallas.add(TablaTallaEdad(meses: 16, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 77.6, tallaFin: 80.19 ));
    tallas.add(TablaTallaEdad(meses: 16, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 80.2, tallaFin: 82.79 ));
    tallas.add(TablaTallaEdad(meses: 16, genero: 'Masculino', resultado: '1DE',   tallaInicio: 82.8, tallaFin: 85.39));
    tallas.add(TablaTallaEdad(meses: 16, genero: 'Masculino', resultado: '2DE',   tallaInicio: 85.4, tallaFin: 95.4));

    tallas.add(TablaTallaEdad(meses: 17, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 76.0, tallaFin: 78.59));
    tallas.add(TablaTallaEdad(meses: 17, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 78.6, tallaFin: 81.19 ));
    tallas.add(TablaTallaEdad(meses: 17, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 81.2, tallaFin: 83.89 ));
    tallas.add(TablaTallaEdad(meses: 17, genero: 'Masculino', resultado: '1DE',   tallaInicio: 83.9, tallaFin: 86.49));
    tallas.add(TablaTallaEdad(meses: 17, genero: 'Masculino', resultado: '2DE',   tallaInicio: 86.5, tallaFin: 96.5));
    //
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 76.9, tallaFin: 79.59));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 79.6, tallaFin: 82.29 ));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 82.3, tallaFin: 84.99 ));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Masculino', resultado: '1DE',   tallaInicio: 85.0, tallaFin: 87.69));
    tallas.add(TablaTallaEdad(meses: 18, genero: 'Masculino', resultado: '2DE',   tallaInicio: 87.7, tallaFin: 97.7));
    
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 77.7, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 80.5, tallaFin: 83.19 ));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 83.2, tallaFin: 85.99 ));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Masculino', resultado: '1DE',   tallaInicio: 86.0, tallaFin: 88.79));
    tallas.add(TablaTallaEdad(meses: 19, genero: 'Masculino', resultado: '2DE',   tallaInicio: 88.8, tallaFin: 98.8));

    tallas.add(TablaTallaEdad(meses: 20, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 78.6, tallaFin: 81.39));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 81.4, tallaFin: 84.19 ));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 84.2, tallaFin: 86.99 ));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Masculino', resultado: '1DE',   tallaInicio: 87.0, tallaFin: 89.79));
    tallas.add(TablaTallaEdad(meses: 20, genero: 'Masculino', resultado: '2DE',   tallaInicio: 89.8, tallaFin: 99.8));

    tallas.add(TablaTallaEdad(meses: 21, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 79.4, tallaFin: 82.29));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 82.3, tallaFin: 85.09 ));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 85.1, tallaFin: 87.99 ));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Masculino', resultado: '1DE',   tallaInicio: 88.0, tallaFin: 90.89));
    tallas.add(TablaTallaEdad(meses: 21, genero: 'Masculino', resultado: '2DE',   tallaInicio: 90.9, tallaFin: 100.9));

    tallas.add(TablaTallaEdad(meses: 22, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 80.2, tallaFin: 83.09));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 83.1, tallaFin: 85.99 ));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 86.0, tallaFin: 88.99 ));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Masculino', resultado: '1DE',   tallaInicio: 89.0, tallaFin: 91.89));
    tallas.add(TablaTallaEdad(meses: 22, genero: 'Masculino', resultado: '2DE',   tallaInicio: 91.9, tallaFin: 101.9));

    tallas.add(TablaTallaEdad(meses: 23, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 81.0, tallaFin: 83.89));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 83.9, tallaFin: 86.89 ));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 86.9, tallaFin: 89.89 ));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Masculino', resultado: '1DE',   tallaInicio: 89.9, tallaFin: 92.89));
    tallas.add(TablaTallaEdad(meses: 23, genero: 'Masculino', resultado: '2DE',   tallaInicio: 92.9, tallaFin: 102.9));
    
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 81.7, tallaFin: 84.79));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 84.8, tallaFin: 87.79 ));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 87.8, tallaFin: 90.89 ));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Masculino', resultado: '1DE',   tallaInicio: 90.9, tallaFin: 93.89));
    tallas.add(TablaTallaEdad(meses: 24, genero: 'Masculino', resultado: '2DE',   tallaInicio: 93.9, tallaFin: 103.9));

    tallas.add(TablaTallaEdad(meses: 25, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 81.7, tallaFin: 84.89));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 84.9, tallaFin: 87.99 ));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 88.0, tallaFin: 91.09 ));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Masculino', resultado: '1DE',   tallaInicio: 91.1, tallaFin: 94.19));
    tallas.add(TablaTallaEdad(meses: 25, genero: 'Masculino', resultado: '2DE',   tallaInicio: 94.2, tallaFin: 104.2));

    tallas.add(TablaTallaEdad(meses: 26, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 82.5, tallaFin: 85.59));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 85.6, tallaFin: 88.79 ));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 88.8, tallaFin: 91.99 ));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Masculino', resultado: '1DE',   tallaInicio: 92.0, tallaFin: 95.19));
    tallas.add(TablaTallaEdad(meses: 26, genero: 'Masculino', resultado: '2DE',   tallaInicio: 95.2, tallaFin: 105.2));

    tallas.add(TablaTallaEdad(meses: 27, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 83.1, tallaFin: 86.39));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 86.4, tallaFin: 89.59 ));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 89.6, tallaFin: 92.89 ));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Masculino', resultado: '1DE',   tallaInicio: 92.9, tallaFin: 96.09));
    tallas.add(TablaTallaEdad(meses: 27, genero: 'Masculino', resultado: '2DE',   tallaInicio: 96.1, tallaFin: 106.1));

    tallas.add(TablaTallaEdad(meses: 28, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 83.9, tallaFin: 87.09));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 87.1, tallaFin: 90.39 ));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 90.4, tallaFin: 93.69 ));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Masculino', resultado: '1DE',   tallaInicio: 93.7, tallaFin: 96.99));
    tallas.add(TablaTallaEdad(meses: 28, genero: 'Masculino', resultado: '2DE',   tallaInicio: 97.0, tallaFin: 107.0));

    tallas.add(TablaTallaEdad(meses: 29, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 84.5, tallaFin: 87.79));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 87.8, tallaFin: 92.19 ));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 91.2, tallaFin: 94.49 ));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Masculino', resultado: '1DE',   tallaInicio: 94.5, tallaFin: 97.89));
    tallas.add(TablaTallaEdad(meses: 29, genero: 'Masculino', resultado: '2DE',   tallaInicio: 97.9, tallaFin: 107.9));

    tallas.add(TablaTallaEdad(meses: 30, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 85.1, tallaFin: 51.69));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 88.5, tallaFin: 52.69 ));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 91.9, tallaFin: 54.59 ));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Masculino', resultado: '1DE',   tallaInicio: 95.3, tallaFin: 56.99));
    tallas.add(TablaTallaEdad(meses: 30, genero: 'Masculino', resultado: '2DE',   tallaInicio: 98.7, tallaFin: 67));

    tallas.add(TablaTallaEdad(meses: 31, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 85.7, tallaFin: 89.19));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 89.2, tallaFin: 92.68 ));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 92.7, tallaFin: 96.09 ));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Masculino', resultado: '1DE',   tallaInicio: 96.1, tallaFin: 99.59));
    tallas.add(TablaTallaEdad(meses: 31, genero: 'Masculino', resultado: '2DE',   tallaInicio: 99.6, tallaFin: 109.6));

    tallas.add(TablaTallaEdad(meses: 32, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 86.4, tallaFin: 89.19));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 89.2, tallaFin: 92.69 ));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 92.7, tallaFin: 96.09 ));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Masculino', resultado: '1DE',   tallaInicio: 96.1, tallaFin: 99.59));
    tallas.add(TablaTallaEdad(meses: 32, genero: 'Masculino', resultado: '2DE',   tallaInicio: 99.6, tallaFin: 109.6));
    //ACA 
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 64.0, tallaFin: 63.39));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 66.4, tallaFin: 68.69 ));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 68.7, tallaFin: 71.49 ));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Masculino', resultado: '1DE',   tallaInicio: 71.5, tallaFin: 73.49));
    tallas.add(TablaTallaEdad(meses: 33, genero: 'Masculino', resultado: '2DE',   tallaInicio: 73.5, tallaFin: 83.5));

    tallas.add(TablaTallaEdad(meses: 34, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 65.3, tallaFin: 67.69));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 67.7, tallaFin: 70.09));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 70.1, tallaFin: 72.69 ));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Masculino', resultado: '1DE',   tallaInicio: 72.7, tallaFin: 74.99));
    tallas.add(TablaTallaEdad(meses: 34, genero: 'Masculino', resultado: '2DE',   tallaInicio: 75.0, tallaFin: 85));

    tallas.add(TablaTallaEdad(meses: 35, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 66.5, tallaFin: 68.99));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 69.0, tallaFin: 71.49 ));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 71.5, tallaFin: 73.89 ));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Masculino', resultado: '1DE',   tallaInicio: 73.9, tallaFin: 76.39));
    tallas.add(TablaTallaEdad(meses: 35, genero: 'Masculino', resultado: '2DE',   tallaInicio: 76.4, tallaFin: 86.4));

    tallas.add(TablaTallaEdad(meses: 36, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 67.7, tallaFin: 70.29));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 70.3, tallaFin: 72.79 ));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 72.8, tallaFin: 75.29 ));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Masculino', resultado: '1DE',   tallaInicio: 75.3, tallaFin: 77.79));
    tallas.add(TablaTallaEdad(meses: 36, genero: 'Masculino', resultado: '2DE',   tallaInicio: 77.8, tallaFin: 87.8));

    tallas.add(TablaTallaEdad(meses: 37, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 68.9, tallaFin: 71.39));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 71.4, tallaFin: 73.99 ));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 74.0, tallaFin: 76.59 ));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Masculino', resultado: '1DE',   tallaInicio: 76.6, tallaFin: 79.19));
    tallas.add(TablaTallaEdad(meses: 37, genero: 'Masculino', resultado: '2DE',   tallaInicio: 79.2, tallaFin: 89.2));

    tallas.add(TablaTallaEdad(meses: 38, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 38, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 39, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 71.0, tallaFin: 73.69));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 73.7, tallaFin: 76.39 ));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 76.4, tallaFin: 79.09 ));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Masculino', resultado: '1DE',   tallaInicio: 79.1, tallaFin: 81.69));
    tallas.add(TablaTallaEdad(meses: 39, genero: 'Masculino', resultado: '2DE',   tallaInicio: 81.7, tallaFin: 91.7));

    tallas.add(TablaTallaEdad(meses: 40, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 72.0, tallaFin: 74.79));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 74.8, tallaFin: 77.49 ));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 77.5, tallaFin: 80.19 ));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Masculino', resultado: '1DE',   tallaInicio: 80.2, tallaFin: 82.99));
    tallas.add(TablaTallaEdad(meses: 40, genero: 'Masculino', resultado: '2DE',   tallaInicio: 83.0, tallaFin: 93.0));

    tallas.add(TablaTallaEdad(meses: 41, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 73.0, tallaFin: 75.79));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 75.8, tallaFin: 78.59 ));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 78.6, tallaFin: 81.39 ));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Masculino', resultado: '1DE',   tallaInicio: 81.4, tallaFin: 84.19));
    tallas.add(TablaTallaEdad(meses: 41, genero: 'Masculino', resultado: '2DE',   tallaInicio: 84.2, tallaFin: 94.2));

    tallas.add(TablaTallaEdad(meses: 42, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 74.0, tallaFin: 76.79));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 76.8, tallaFin: 79.69 ));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 79.7, tallaFin: 82.49 ));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Masculino', resultado: '1DE',   tallaInicio: 82.5, tallaFin: 84.39));
    tallas.add(TablaTallaEdad(meses: 42, genero: 'Masculino', resultado: '2DE',   tallaInicio: 85.4, tallaFin: 95.4));
    //
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 43, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));
    
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 44, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 45, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 45, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 46, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 46, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 47, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 47, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 48, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 48, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 49, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 49, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 50, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 74.0, tallaFin: 76.79));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 76.8, tallaFin: 79.69 ));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 79.7, tallaFin: 82.49 ));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Masculino', resultado: '1DE',   tallaInicio: 82.5, tallaFin: 84.39));
    tallas.add(TablaTallaEdad(meses: 50, genero: 'Masculino', resultado: '2DE',   tallaInicio: 85.4, tallaFin: 95.4));
    //
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 51, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));
    
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 52, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 53, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 53, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 54, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 54, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 55, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 55, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 56, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 56, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 57, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 57, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 58, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 58, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 59, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 59, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

    tallas.add(TablaTallaEdad(meses: 60, genero: 'Masculino', resultado: '-2DE',  tallaInicio: 70.0, tallaFin: 72.59));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Masculino', resultado: '-1DE',  tallaInicio: 72.6, tallaFin: 75.19 ));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Masculino', resultado: 'MEDIA', tallaInicio: 75.2, tallaFin: 77.79 ));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Masculino', resultado: '1DE',   tallaInicio: 77.8, tallaFin: 80.49));
    tallas.add(TablaTallaEdad(meses: 60, genero: 'Masculino', resultado: '2DE',   tallaInicio: 80.5, tallaFin: 90.5));

  }






  void llenarPesos(){

    pesos.add(TablaPesoEdad(meses: 0, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 45.4, pesoFin: 47.29));
    pesos.add(TablaPesoEdad(meses: 0, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 47.3, pesoFin: 49.09 ));
    pesos.add(TablaPesoEdad(meses: 0, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 49.1, pesoFin: 50.99 ));
    pesos.add(TablaPesoEdad(meses: 0, genero: 'Femenino', resultado: '1DE',   pesoInicio: 51.0, pesoFin: 52.89));
    pesos.add(TablaPesoEdad(meses: 0, genero: 'Femenino', resultado: '2DE',   pesoInicio: 52.9, pesoFin: 62));

    pesos.add(TablaPesoEdad(meses: 1, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 49.8, pesoFin: 51.69));
    pesos.add(TablaPesoEdad(meses: 1, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 51.7, pesoFin: 52.69 ));
    pesos.add(TablaPesoEdad(meses: 1, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 53.7, pesoFin: 54.59 ));
    pesos.add(TablaPesoEdad(meses: 1, genero: 'Femenino', resultado: '1DE',   pesoInicio: 55.6, pesoFin: 56.99));
    pesos.add(TablaPesoEdad(meses: 1, genero: 'Femenino', resultado: '2DE',   pesoInicio: 57.0, pesoFin: 67));

    pesos.add(TablaPesoEdad(meses: 2, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 53.0, pesoFin: 54.99));
    pesos.add(TablaPesoEdad(meses: 2, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 55.0, pesoFin: 57.09 ));
    pesos.add(TablaPesoEdad(meses: 2, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 57.10, pesoFin: 59.09 ));
    pesos.add(TablaPesoEdad(meses: 2, genero: 'Femenino', resultado: '1DE',   pesoInicio: 59.1, pesoFin: 61.09));
    pesos.add(TablaPesoEdad(meses: 2, genero: 'Femenino', resultado: '2DE',   pesoInicio: 61.1, pesoFin: 71.1));

    pesos.add(TablaPesoEdad(meses: 3, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 55.6, pesoFin: 57.69));
    pesos.add(TablaPesoEdad(meses: 3, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 57.7, pesoFin: 58.79 ));
    pesos.add(TablaPesoEdad(meses: 3, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 59.8, pesoFin: 61.89 ));
    pesos.add(TablaPesoEdad(meses: 3, genero: 'Femenino', resultado: '1DE',   pesoInicio: 61.9, pesoFin: 63.99));
    pesos.add(TablaPesoEdad(meses: 3, genero: 'Femenino', resultado: '2DE',   pesoInicio: 64.0, pesoFin: 74));

    pesos.add(TablaPesoEdad(meses: 4, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 57.8, pesoFin: 59.89));
    pesos.add(TablaPesoEdad(meses: 4, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 59.9, pesoFin: 62.09 ));
    pesos.add(TablaPesoEdad(meses: 4, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 62.1, pesoFin: 64.29 ));
    pesos.add(TablaPesoEdad(meses: 4, genero: 'Femenino', resultado: '1DE',   pesoInicio: 64.3, pesoFin: 66.39));
    pesos.add(TablaPesoEdad(meses: 4, genero: 'Femenino', resultado: '2DE',   pesoInicio: 66.4, pesoFin: 76));

    pesos.add(TablaPesoEdad(meses: 5, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 49.8, pesoFin: 51.69));
    pesos.add(TablaPesoEdad(meses: 5, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 51.7, pesoFin: 52.69 ));
    pesos.add(TablaPesoEdad(meses: 5, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 53.7, pesoFin: 54.59 ));
    pesos.add(TablaPesoEdad(meses: 5, genero: 'Femenino', resultado: '1DE',   pesoInicio: 55.6, pesoFin: 56.99));
    pesos.add(TablaPesoEdad(meses: 5, genero: 'Femenino', resultado: '2DE',   pesoInicio: 57.0, pesoFin: 67));

    pesos.add(TablaPesoEdad(meses: 6, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 61.2, pesoFin: 63.49));
    pesos.add(TablaPesoEdad(meses: 6, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 63.5, pesoFin: 65.69 ));
    pesos.add(TablaPesoEdad(meses: 6, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 65.7, pesoFin: 67.99 ));
    pesos.add(TablaPesoEdad(meses: 6, genero: 'Femenino', resultado: '1DE',   pesoInicio: 68.0, pesoFin: 70.29));
    pesos.add(TablaPesoEdad(meses: 6, genero: 'Femenino', resultado: '2DE',   pesoInicio: 70.3, pesoFin: 80));

    pesos.add(TablaPesoEdad(meses: 7, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 62.7, pesoFin: 64.99));
    pesos.add(TablaPesoEdad(meses: 7, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 65.0, pesoFin: 67.29 ));
    pesos.add(TablaPesoEdad(meses: 7, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 67.3, pesoFin: 69.59 ));
    pesos.add(TablaPesoEdad(meses: 7, genero: 'Femenino', resultado: '1DE',   pesoInicio: 69.6, pesoFin: 71.89));
    pesos.add(TablaPesoEdad(meses: 7, genero: 'Femenino', resultado: '2DE',   pesoInicio: 71.9, pesoFin: 81));

    pesos.add(TablaPesoEdad(meses: 8, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 64.0, pesoFin: 63.39));
    pesos.add(TablaPesoEdad(meses: 8, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 66.4, pesoFin: 68.69 ));
    pesos.add(TablaPesoEdad(meses: 8, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 68.7, pesoFin: 71.49 ));
    pesos.add(TablaPesoEdad(meses: 8, genero: 'Femenino', resultado: '1DE',   pesoInicio: 71.5, pesoFin: 73.49));
    pesos.add(TablaPesoEdad(meses: 8, genero: 'Femenino', resultado: '2DE',   pesoInicio: 73.5, pesoFin: 83.5));

    pesos.add(TablaPesoEdad(meses: 9, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 65.3, pesoFin: 67.69));
    pesos.add(TablaPesoEdad(meses: 9, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 67.7, pesoFin: 70.09));
    pesos.add(TablaPesoEdad(meses: 9, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 70.1, pesoFin: 72.69 ));
    pesos.add(TablaPesoEdad(meses: 9, genero: 'Femenino', resultado: '1DE',   pesoInicio: 72.7, pesoFin: 74.99));
    pesos.add(TablaPesoEdad(meses: 9, genero: 'Femenino', resultado: '2DE',   pesoInicio: 75.0, pesoFin: 85));

    pesos.add(TablaPesoEdad(meses: 10, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 66.5, pesoFin: 68.99));
    pesos.add(TablaPesoEdad(meses: 10, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 69.0, pesoFin: 71.49 ));
    pesos.add(TablaPesoEdad(meses: 10, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 71.5, pesoFin: 73.89 ));
    pesos.add(TablaPesoEdad(meses: 10, genero: 'Femenino', resultado: '1DE',   pesoInicio: 73.9, pesoFin: 76.39));
    pesos.add(TablaPesoEdad(meses: 10, genero: 'Femenino', resultado: '2DE',   pesoInicio: 76.4, pesoFin: 86.4));

    pesos.add(TablaPesoEdad(meses: 11, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 67.7, pesoFin: 70.29));
    pesos.add(TablaPesoEdad(meses: 11, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 70.3, pesoFin: 72.79 ));
    pesos.add(TablaPesoEdad(meses: 11, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 72.8, pesoFin: 75.29 ));
    pesos.add(TablaPesoEdad(meses: 11, genero: 'Femenino', resultado: '1DE',   pesoInicio: 75.3, pesoFin: 77.79));
    pesos.add(TablaPesoEdad(meses: 11, genero: 'Femenino', resultado: '2DE',   pesoInicio: 77.8, pesoFin: 87.8));

    pesos.add(TablaPesoEdad(meses: 12, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 68.9, pesoFin: 71.39));
    pesos.add(TablaPesoEdad(meses: 12, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 71.4, pesoFin: 73.99 ));
    pesos.add(TablaPesoEdad(meses: 12, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 74.0, pesoFin: 76.59 ));
    pesos.add(TablaPesoEdad(meses: 12, genero: 'Femenino', resultado: '1DE',   pesoInicio: 76.6, pesoFin: 79.19));
    pesos.add(TablaPesoEdad(meses: 12, genero: 'Femenino', resultado: '2DE',   pesoInicio: 79.2, pesoFin: 89.2));

    pesos.add(TablaPesoEdad(meses: 13, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 13, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 13, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 13, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 13, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 14, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 71.0, pesoFin: 73.69));
    pesos.add(TablaPesoEdad(meses: 14, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 73.7, pesoFin: 76.39 ));
    pesos.add(TablaPesoEdad(meses: 14, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 76.4, pesoFin: 79.09 ));
    pesos.add(TablaPesoEdad(meses: 14, genero: 'Femenino', resultado: '1DE',   pesoInicio: 79.1, pesoFin: 81.69));
    pesos.add(TablaPesoEdad(meses: 14, genero: 'Femenino', resultado: '2DE',   pesoInicio: 81.7, pesoFin: 91.7));

    pesos.add(TablaPesoEdad(meses: 15, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 72.0, pesoFin: 74.79));
    pesos.add(TablaPesoEdad(meses: 15, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 74.8, pesoFin: 77.49 ));
    pesos.add(TablaPesoEdad(meses: 15, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 77.5, pesoFin: 80.19 ));
    pesos.add(TablaPesoEdad(meses: 15, genero: 'Femenino', resultado: '1DE',   pesoInicio: 80.2, pesoFin: 82.99));
    pesos.add(TablaPesoEdad(meses: 15, genero: 'Femenino', resultado: '2DE',   pesoInicio: 83.0, pesoFin: 93.0));

    pesos.add(TablaPesoEdad(meses: 16, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 73.0, pesoFin: 75.79));
    pesos.add(TablaPesoEdad(meses: 16, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 75.8, pesoFin: 78.59 ));
    pesos.add(TablaPesoEdad(meses: 16, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 78.6, pesoFin: 81.39 ));
    pesos.add(TablaPesoEdad(meses: 16, genero: 'Femenino', resultado: '1DE',   pesoInicio: 81.4, pesoFin: 84.19));
    pesos.add(TablaPesoEdad(meses: 16, genero: 'Femenino', resultado: '2DE',   pesoInicio: 84.2, pesoFin: 94.2));

    pesos.add(TablaPesoEdad(meses: 17, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 74.0, pesoFin: 76.79));
    pesos.add(TablaPesoEdad(meses: 17, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 76.8, pesoFin: 79.69 ));
    pesos.add(TablaPesoEdad(meses: 17, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 79.7, pesoFin: 82.49 ));
    pesos.add(TablaPesoEdad(meses: 17, genero: 'Femenino', resultado: '1DE',   pesoInicio: 82.5, pesoFin: 84.39));
    pesos.add(TablaPesoEdad(meses: 17, genero: 'Femenino', resultado: '2DE',   pesoInicio: 85.4, pesoFin: 95.4));
    //
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));
    
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 20, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 20, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 20, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 20, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 20, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 21, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 21, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 21, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 21, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 21, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 22, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 22, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 22, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 22, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 22, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 23, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 23, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 23, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 23, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 23, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 24, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 24, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 24, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 24, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 24, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 25, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 45.4, pesoFin: 47.29));
    pesos.add(TablaPesoEdad(meses: 25, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 47.3, pesoFin: 49.09 ));
    pesos.add(TablaPesoEdad(meses: 25, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 49.1, pesoFin: 50.99 ));
    pesos.add(TablaPesoEdad(meses: 25, genero: 'Femenino', resultado: '1DE',   pesoInicio: 51.0, pesoFin: 52.89));
    pesos.add(TablaPesoEdad(meses: 25, genero: 'Femenino', resultado: '2DE',   pesoInicio: 52.9, pesoFin: 62));

    pesos.add(TablaPesoEdad(meses: 26, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 49.8, pesoFin: 51.69));
    pesos.add(TablaPesoEdad(meses: 26, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 51.7, pesoFin: 52.69 ));
    pesos.add(TablaPesoEdad(meses: 26, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 53.7, pesoFin: 54.59 ));
    pesos.add(TablaPesoEdad(meses: 26, genero: 'Femenino', resultado: '1DE',   pesoInicio: 55.6, pesoFin: 56.99));
    pesos.add(TablaPesoEdad(meses: 26, genero: 'Femenino', resultado: '2DE',   pesoInicio: 57.0, pesoFin: 67));

    pesos.add(TablaPesoEdad(meses: 27, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 53.0, pesoFin: 54.99));
    pesos.add(TablaPesoEdad(meses: 27, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 55.0, pesoFin: 57.09 ));
    pesos.add(TablaPesoEdad(meses: 27, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 57.10, pesoFin: 59.09 ));
    pesos.add(TablaPesoEdad(meses: 27, genero: 'Femenino', resultado: '1DE',   pesoInicio: 59.1, pesoFin: 61.09));
    pesos.add(TablaPesoEdad(meses: 27, genero: 'Femenino', resultado: '2DE',   pesoInicio: 61.1, pesoFin: 71.1));

    pesos.add(TablaPesoEdad(meses: 28, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 55.6, pesoFin: 57.69));
    pesos.add(TablaPesoEdad(meses: 28, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 57.7, pesoFin: 58.79 ));
    pesos.add(TablaPesoEdad(meses: 28, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 59.8, pesoFin: 61.89 ));
    pesos.add(TablaPesoEdad(meses: 28, genero: 'Femenino', resultado: '1DE',   pesoInicio: 61.9, pesoFin: 63.99));
    pesos.add(TablaPesoEdad(meses: 28, genero: 'Femenino', resultado: '2DE',   pesoInicio: 64.0, pesoFin: 74));

    pesos.add(TablaPesoEdad(meses: 29, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 57.8, pesoFin: 59.89));
    pesos.add(TablaPesoEdad(meses: 29, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 59.9, pesoFin: 62.09 ));
    pesos.add(TablaPesoEdad(meses: 29, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 62.1, pesoFin: 64.29 ));
    pesos.add(TablaPesoEdad(meses: 29, genero: 'Femenino', resultado: '1DE',   pesoInicio: 64.3, pesoFin: 66.39));
    pesos.add(TablaPesoEdad(meses: 29, genero: 'Femenino', resultado: '2DE',   pesoInicio: 66.4, pesoFin: 76));

    pesos.add(TablaPesoEdad(meses: 30, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 49.8, pesoFin: 51.69));
    pesos.add(TablaPesoEdad(meses: 30, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 51.7, pesoFin: 52.69 ));
    pesos.add(TablaPesoEdad(meses: 30, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 53.7, pesoFin: 54.59 ));
    pesos.add(TablaPesoEdad(meses: 30, genero: 'Femenino', resultado: '1DE',   pesoInicio: 55.6, pesoFin: 56.99));
    pesos.add(TablaPesoEdad(meses: 30, genero: 'Femenino', resultado: '2DE',   pesoInicio: 57.0, pesoFin: 67));

    pesos.add(TablaPesoEdad(meses: 31, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 61.2, pesoFin: 63.49));
    pesos.add(TablaPesoEdad(meses: 31, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 63.5, pesoFin: 65.69 ));
    pesos.add(TablaPesoEdad(meses: 31, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 65.7, pesoFin: 67.99 ));
    pesos.add(TablaPesoEdad(meses: 31, genero: 'Femenino', resultado: '1DE',   pesoInicio: 68.0, pesoFin: 70.29));
    pesos.add(TablaPesoEdad(meses: 31, genero: 'Femenino', resultado: '2DE',   pesoInicio: 70.3, pesoFin: 80));

    pesos.add(TablaPesoEdad(meses: 32, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 62.7, pesoFin: 64.99));
    pesos.add(TablaPesoEdad(meses: 32, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 65.0, pesoFin: 67.29 ));
    pesos.add(TablaPesoEdad(meses: 32, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 67.3, pesoFin: 69.59 ));
    pesos.add(TablaPesoEdad(meses: 32, genero: 'Femenino', resultado: '1DE',   pesoInicio: 69.6, pesoFin: 71.89));
    pesos.add(TablaPesoEdad(meses: 32, genero: 'Femenino', resultado: '2DE',   pesoInicio: 71.9, pesoFin: 81));

    pesos.add(TablaPesoEdad(meses: 33, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 64.0, pesoFin: 63.39));
    pesos.add(TablaPesoEdad(meses: 33, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 66.4, pesoFin: 68.69 ));
    pesos.add(TablaPesoEdad(meses: 33, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 68.7, pesoFin: 71.49 ));
    pesos.add(TablaPesoEdad(meses: 33, genero: 'Femenino', resultado: '1DE',   pesoInicio: 71.5, pesoFin: 73.49));
    pesos.add(TablaPesoEdad(meses: 33, genero: 'Femenino', resultado: '2DE',   pesoInicio: 73.5, pesoFin: 83.5));

    pesos.add(TablaPesoEdad(meses: 34, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 65.3, pesoFin: 67.69));
    pesos.add(TablaPesoEdad(meses: 34, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 67.7, pesoFin: 70.09));
    pesos.add(TablaPesoEdad(meses: 34, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 70.1, pesoFin: 72.69 ));
    pesos.add(TablaPesoEdad(meses: 34, genero: 'Femenino', resultado: '1DE',   pesoInicio: 72.7, pesoFin: 74.99));
    pesos.add(TablaPesoEdad(meses: 34, genero: 'Femenino', resultado: '2DE',   pesoInicio: 75.0, pesoFin: 85));

    pesos.add(TablaPesoEdad(meses: 35, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 66.5, pesoFin: 68.99));
    pesos.add(TablaPesoEdad(meses: 35, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 69.0, pesoFin: 71.49 ));
    pesos.add(TablaPesoEdad(meses: 35, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 71.5, pesoFin: 73.89 ));
    pesos.add(TablaPesoEdad(meses: 35, genero: 'Femenino', resultado: '1DE',   pesoInicio: 73.9, pesoFin: 76.39));
    pesos.add(TablaPesoEdad(meses: 35, genero: 'Femenino', resultado: '2DE',   pesoInicio: 76.4, pesoFin: 86.4));

    pesos.add(TablaPesoEdad(meses: 36, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 67.7, pesoFin: 70.29));
    pesos.add(TablaPesoEdad(meses: 36, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 70.3, pesoFin: 72.79 ));
    pesos.add(TablaPesoEdad(meses: 36, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 72.8, pesoFin: 75.29 ));
    pesos.add(TablaPesoEdad(meses: 36, genero: 'Femenino', resultado: '1DE',   pesoInicio: 75.3, pesoFin: 77.79));
    pesos.add(TablaPesoEdad(meses: 36, genero: 'Femenino', resultado: '2DE',   pesoInicio: 77.8, pesoFin: 87.8));

    pesos.add(TablaPesoEdad(meses: 37, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 68.9, pesoFin: 71.39));
    pesos.add(TablaPesoEdad(meses: 37, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 71.4, pesoFin: 73.99 ));
    pesos.add(TablaPesoEdad(meses: 37, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 74.0, pesoFin: 76.59 ));
    pesos.add(TablaPesoEdad(meses: 37, genero: 'Femenino', resultado: '1DE',   pesoInicio: 76.6, pesoFin: 79.19));
    pesos.add(TablaPesoEdad(meses: 37, genero: 'Femenino', resultado: '2DE',   pesoInicio: 79.2, pesoFin: 89.2));

    pesos.add(TablaPesoEdad(meses: 38, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 38, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 38, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 38, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 38, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 39, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 71.0, pesoFin: 73.69));
    pesos.add(TablaPesoEdad(meses: 39, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 73.7, pesoFin: 76.39 ));
    pesos.add(TablaPesoEdad(meses: 39, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 76.4, pesoFin: 79.09 ));
    pesos.add(TablaPesoEdad(meses: 39, genero: 'Femenino', resultado: '1DE',   pesoInicio: 79.1, pesoFin: 81.69));
    pesos.add(TablaPesoEdad(meses: 39, genero: 'Femenino', resultado: '2DE',   pesoInicio: 81.7, pesoFin: 91.7));

    pesos.add(TablaPesoEdad(meses: 40, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 72.0, pesoFin: 74.79));
    pesos.add(TablaPesoEdad(meses: 40, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 74.8, pesoFin: 77.49 ));
    pesos.add(TablaPesoEdad(meses: 40, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 77.5, pesoFin: 80.19 ));
    pesos.add(TablaPesoEdad(meses: 40, genero: 'Femenino', resultado: '1DE',   pesoInicio: 80.2, pesoFin: 82.99));
    pesos.add(TablaPesoEdad(meses: 40, genero: 'Femenino', resultado: '2DE',   pesoInicio: 83.0, pesoFin: 93.0));

    pesos.add(TablaPesoEdad(meses: 41, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 73.0, pesoFin: 75.79));
    pesos.add(TablaPesoEdad(meses: 41, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 75.8, pesoFin: 78.59 ));
    pesos.add(TablaPesoEdad(meses: 41, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 78.6, pesoFin: 81.39 ));
    pesos.add(TablaPesoEdad(meses: 41, genero: 'Femenino', resultado: '1DE',   pesoInicio: 81.4, pesoFin: 84.19));
    pesos.add(TablaPesoEdad(meses: 41, genero: 'Femenino', resultado: '2DE',   pesoInicio: 84.2, pesoFin: 94.2));

    pesos.add(TablaPesoEdad(meses: 42, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 74.0, pesoFin: 76.79));
    pesos.add(TablaPesoEdad(meses: 42, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 76.8, pesoFin: 79.69 ));
    pesos.add(TablaPesoEdad(meses: 42, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 79.7, pesoFin: 82.49 ));
    pesos.add(TablaPesoEdad(meses: 42, genero: 'Femenino', resultado: '1DE',   pesoInicio: 82.5, pesoFin: 84.39));
    pesos.add(TablaPesoEdad(meses: 42, genero: 'Femenino', resultado: '2DE',   pesoInicio: 85.4, pesoFin: 95.4));
    //
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));
    
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 45, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 45, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 45, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 45, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 45, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 46, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 46, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 46, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 46, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 46, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 47, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 47, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 47, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 47, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 47, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 48, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 48, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 48, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 48, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 48, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 49, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 49, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 49, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 49, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 49, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 50, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 74.0, pesoFin: 76.79));
    pesos.add(TablaPesoEdad(meses: 50, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 76.8, pesoFin: 79.69 ));
    pesos.add(TablaPesoEdad(meses: 50, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 79.7, pesoFin: 82.49 ));
    pesos.add(TablaPesoEdad(meses: 50, genero: 'Femenino', resultado: '1DE',   pesoInicio: 82.5, pesoFin: 84.39));
    pesos.add(TablaPesoEdad(meses: 50, genero: 'Femenino', resultado: '2DE',   pesoInicio: 85.4, pesoFin: 95.4));
    //
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));
    
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 53, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 53, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 53, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 53, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 53, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 54, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 54, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 54, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 54, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 54, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 55, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 55, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 55, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 55, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 55, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 56, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 56, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 56, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 56, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 56, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 57, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 57, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 57, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 57, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 57, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 58, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 58, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 58, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 58, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 58, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 59, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 59, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 59, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 59, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 59, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 60, genero: 'Femenino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 60, genero: 'Femenino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 60, genero: 'Femenino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 60, genero: 'Femenino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 60, genero: 'Femenino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    //***********************MASCULINO */********************** */ */



    pesos.add(TablaPesoEdad(meses: 0, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 45.4, pesoFin: 47.29));
    pesos.add(TablaPesoEdad(meses: 0, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 47.3, pesoFin: 49.09 ));
    pesos.add(TablaPesoEdad(meses: 0, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 49.1, pesoFin: 50.99 ));
    pesos.add(TablaPesoEdad(meses: 0, genero: 'Masculino', resultado: '1DE',   pesoInicio: 51.0, pesoFin: 52.89));
    pesos.add(TablaPesoEdad(meses: 0, genero: 'Masculino', resultado: '2DE',   pesoInicio: 52.9, pesoFin: 62));

    pesos.add(TablaPesoEdad(meses: 1, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 49.8, pesoFin: 51.69));
    pesos.add(TablaPesoEdad(meses: 1, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 51.7, pesoFin: 52.69 ));
    pesos.add(TablaPesoEdad(meses: 1, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 53.7, pesoFin: 54.59 ));
    pesos.add(TablaPesoEdad(meses: 1, genero: 'Masculino', resultado: '1DE',   pesoInicio: 55.6, pesoFin: 56.99));
    pesos.add(TablaPesoEdad(meses: 1, genero: 'Masculino', resultado: '2DE',   pesoInicio: 57.0, pesoFin: 67));

    pesos.add(TablaPesoEdad(meses: 2, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 53.0, pesoFin: 54.99));
    pesos.add(TablaPesoEdad(meses: 2, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 55.0, pesoFin: 57.09 ));
    pesos.add(TablaPesoEdad(meses: 2, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 57.10, pesoFin: 59.09 ));
    pesos.add(TablaPesoEdad(meses: 2, genero: 'Masculino', resultado: '1DE',   pesoInicio: 59.1, pesoFin: 61.09));
    pesos.add(TablaPesoEdad(meses: 2, genero: 'Masculino', resultado: '2DE',   pesoInicio: 61.1, pesoFin: 71.1));

    pesos.add(TablaPesoEdad(meses: 3, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 55.6, pesoFin: 57.69));
    pesos.add(TablaPesoEdad(meses: 3, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 57.7, pesoFin: 58.79 ));
    pesos.add(TablaPesoEdad(meses: 3, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 59.8, pesoFin: 61.89 ));
    pesos.add(TablaPesoEdad(meses: 3, genero: 'Masculino', resultado: '1DE',   pesoInicio: 61.9, pesoFin: 63.99));
    pesos.add(TablaPesoEdad(meses: 3, genero: 'Masculino', resultado: '2DE',   pesoInicio: 64.0, pesoFin: 74));

    pesos.add(TablaPesoEdad(meses: 4, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 57.8, pesoFin: 59.89));
    pesos.add(TablaPesoEdad(meses: 4, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 59.9, pesoFin: 62.09 ));
    pesos.add(TablaPesoEdad(meses: 4, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 62.1, pesoFin: 64.29 ));
    pesos.add(TablaPesoEdad(meses: 4, genero: 'Masculino', resultado: '1DE',   pesoInicio: 64.3, pesoFin: 66.39));
    pesos.add(TablaPesoEdad(meses: 4, genero: 'Masculino', resultado: '2DE',   pesoInicio: 66.4, pesoFin: 76));

    pesos.add(TablaPesoEdad(meses: 5, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 49.8, pesoFin: 51.69));
    pesos.add(TablaPesoEdad(meses: 5, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 51.7, pesoFin: 52.69 ));
    pesos.add(TablaPesoEdad(meses: 5, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 53.7, pesoFin: 54.59 ));
    pesos.add(TablaPesoEdad(meses: 5, genero: 'Masculino', resultado: '1DE',   pesoInicio: 55.6, pesoFin: 56.99));
    pesos.add(TablaPesoEdad(meses: 5, genero: 'Masculino', resultado: '2DE',   pesoInicio: 57.0, pesoFin: 67));

    pesos.add(TablaPesoEdad(meses: 6, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 61.2, pesoFin: 63.49));
    pesos.add(TablaPesoEdad(meses: 6, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 63.5, pesoFin: 65.69 ));
    pesos.add(TablaPesoEdad(meses: 6, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 65.7, pesoFin: 67.99 ));
    pesos.add(TablaPesoEdad(meses: 6, genero: 'Masculino', resultado: '1DE',   pesoInicio: 68.0, pesoFin: 70.29));
    pesos.add(TablaPesoEdad(meses: 6, genero: 'Masculino', resultado: '2DE',   pesoInicio: 70.3, pesoFin: 80));

    pesos.add(TablaPesoEdad(meses: 7, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 62.7, pesoFin: 64.99));
    pesos.add(TablaPesoEdad(meses: 7, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 65.0, pesoFin: 67.29 ));
    pesos.add(TablaPesoEdad(meses: 7, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 67.3, pesoFin: 69.59 ));
    pesos.add(TablaPesoEdad(meses: 7, genero: 'Masculino', resultado: '1DE',   pesoInicio: 69.6, pesoFin: 71.89));
    pesos.add(TablaPesoEdad(meses: 7, genero: 'Masculino', resultado: '2DE',   pesoInicio: 71.9, pesoFin: 81));

    pesos.add(TablaPesoEdad(meses: 8, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 64.0, pesoFin: 63.39));
    pesos.add(TablaPesoEdad(meses: 8, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 66.4, pesoFin: 68.69 ));
    pesos.add(TablaPesoEdad(meses: 8, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 68.7, pesoFin: 71.49 ));
    pesos.add(TablaPesoEdad(meses: 8, genero: 'Masculino', resultado: '1DE',   pesoInicio: 71.5, pesoFin: 73.49));
    pesos.add(TablaPesoEdad(meses: 8, genero: 'Masculino', resultado: '2DE',   pesoInicio: 73.5, pesoFin: 83.5));

    pesos.add(TablaPesoEdad(meses: 9, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 65.3, pesoFin: 67.69));
    pesos.add(TablaPesoEdad(meses: 9, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 67.7, pesoFin: 70.09));
    pesos.add(TablaPesoEdad(meses: 9, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 70.1, pesoFin: 72.69 ));
    pesos.add(TablaPesoEdad(meses: 9, genero: 'Masculino', resultado: '1DE',   pesoInicio: 72.7, pesoFin: 74.99));
    pesos.add(TablaPesoEdad(meses: 9, genero: 'Masculino', resultado: '2DE',   pesoInicio: 75.0, pesoFin: 85));

    pesos.add(TablaPesoEdad(meses: 10, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 66.5, pesoFin: 68.99));
    pesos.add(TablaPesoEdad(meses: 10, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 69.0, pesoFin: 71.49 ));
    pesos.add(TablaPesoEdad(meses: 10, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 71.5, pesoFin: 73.89 ));
    pesos.add(TablaPesoEdad(meses: 10, genero: 'Masculino', resultado: '1DE',   pesoInicio: 73.9, pesoFin: 76.39));
    pesos.add(TablaPesoEdad(meses: 10, genero: 'Masculino', resultado: '2DE',   pesoInicio: 76.4, pesoFin: 86.4));

    pesos.add(TablaPesoEdad(meses: 11, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 67.7, pesoFin: 70.29));
    pesos.add(TablaPesoEdad(meses: 11, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 70.3, pesoFin: 72.79 ));
    pesos.add(TablaPesoEdad(meses: 11, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 72.8, pesoFin: 75.29 ));
    pesos.add(TablaPesoEdad(meses: 11, genero: 'Masculino', resultado: '1DE',   pesoInicio: 75.3, pesoFin: 77.79));
    pesos.add(TablaPesoEdad(meses: 11, genero: 'Masculino', resultado: '2DE',   pesoInicio: 77.8, pesoFin: 87.8));

    pesos.add(TablaPesoEdad(meses: 12, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 68.9, pesoFin: 71.39));
    pesos.add(TablaPesoEdad(meses: 12, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 71.4, pesoFin: 73.99 ));
    pesos.add(TablaPesoEdad(meses: 12, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 74.0, pesoFin: 76.59 ));
    pesos.add(TablaPesoEdad(meses: 12, genero: 'Masculino', resultado: '1DE',   pesoInicio: 76.6, pesoFin: 79.19));
    pesos.add(TablaPesoEdad(meses: 12, genero: 'Masculino', resultado: '2DE',   pesoInicio: 79.2, pesoFin: 89.2));

    pesos.add(TablaPesoEdad(meses: 13, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 13, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 13, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 13, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 13, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 14, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 71.0, pesoFin: 73.69));
    pesos.add(TablaPesoEdad(meses: 14, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 73.7, pesoFin: 76.39 ));
    pesos.add(TablaPesoEdad(meses: 14, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 76.4, pesoFin: 79.09 ));
    pesos.add(TablaPesoEdad(meses: 14, genero: 'Masculino', resultado: '1DE',   pesoInicio: 79.1, pesoFin: 81.69));
    pesos.add(TablaPesoEdad(meses: 14, genero: 'Masculino', resultado: '2DE',   pesoInicio: 81.7, pesoFin: 91.7));

    pesos.add(TablaPesoEdad(meses: 15, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 72.0, pesoFin: 74.79));
    pesos.add(TablaPesoEdad(meses: 15, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 74.8, pesoFin: 77.49 ));
    pesos.add(TablaPesoEdad(meses: 15, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 77.5, pesoFin: 80.19 ));
    pesos.add(TablaPesoEdad(meses: 15, genero: 'Masculino', resultado: '1DE',   pesoInicio: 80.2, pesoFin: 82.99));
    pesos.add(TablaPesoEdad(meses: 15, genero: 'Masculino', resultado: '2DE',   pesoInicio: 83.0, pesoFin: 93.0));

    pesos.add(TablaPesoEdad(meses: 16, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 73.0, pesoFin: 75.79));
    pesos.add(TablaPesoEdad(meses: 16, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 75.8, pesoFin: 78.59 ));
    pesos.add(TablaPesoEdad(meses: 16, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 78.6, pesoFin: 81.39 ));
    pesos.add(TablaPesoEdad(meses: 16, genero: 'Masculino', resultado: '1DE',   pesoInicio: 81.4, pesoFin: 84.19));
    pesos.add(TablaPesoEdad(meses: 16, genero: 'Masculino', resultado: '2DE',   pesoInicio: 84.2, pesoFin: 94.2));

    pesos.add(TablaPesoEdad(meses: 17, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 74.0, pesoFin: 76.79));
    pesos.add(TablaPesoEdad(meses: 17, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 76.8, pesoFin: 79.69 ));
    pesos.add(TablaPesoEdad(meses: 17, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 79.7, pesoFin: 82.49 ));
    pesos.add(TablaPesoEdad(meses: 17, genero: 'Masculino', resultado: '1DE',   pesoInicio: 82.5, pesoFin: 84.39));
    pesos.add(TablaPesoEdad(meses: 17, genero: 'Masculino', resultado: '2DE',   pesoInicio: 85.4, pesoFin: 95.4));
    //
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 18, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));
    
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 19, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 20, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 20, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 20, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 20, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 20, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 21, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 21, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 21, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 21, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 21, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 22, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 22, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 22, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 22, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 22, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 23, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 23, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 23, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 23, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 23, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 24, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 24, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 24, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 24, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 24, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 25, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 45.4, pesoFin: 47.29));
    pesos.add(TablaPesoEdad(meses: 25, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 47.3, pesoFin: 49.09 ));
    pesos.add(TablaPesoEdad(meses: 25, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 49.1, pesoFin: 50.99 ));
    pesos.add(TablaPesoEdad(meses: 25, genero: 'Masculino', resultado: '1DE',   pesoInicio: 51.0, pesoFin: 52.89));
    pesos.add(TablaPesoEdad(meses: 25, genero: 'Masculino', resultado: '2DE',   pesoInicio: 52.9, pesoFin: 62));

    pesos.add(TablaPesoEdad(meses: 26, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 49.8, pesoFin: 51.69));
    pesos.add(TablaPesoEdad(meses: 26, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 51.7, pesoFin: 52.69 ));
    pesos.add(TablaPesoEdad(meses: 26, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 53.7, pesoFin: 54.59 ));
    pesos.add(TablaPesoEdad(meses: 26, genero: 'Masculino', resultado: '1DE',   pesoInicio: 55.6, pesoFin: 56.99));
    pesos.add(TablaPesoEdad(meses: 26, genero: 'Masculino', resultado: '2DE',   pesoInicio: 57.0, pesoFin: 67));

    pesos.add(TablaPesoEdad(meses: 27, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 53.0, pesoFin: 54.99));
    pesos.add(TablaPesoEdad(meses: 27, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 55.0, pesoFin: 57.09 ));
    pesos.add(TablaPesoEdad(meses: 27, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 57.10, pesoFin: 59.09 ));
    pesos.add(TablaPesoEdad(meses: 27, genero: 'Masculino', resultado: '1DE',   pesoInicio: 59.1, pesoFin: 61.09));
    pesos.add(TablaPesoEdad(meses: 27, genero: 'Masculino', resultado: '2DE',   pesoInicio: 61.1, pesoFin: 71.1));

    pesos.add(TablaPesoEdad(meses: 28, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 55.6, pesoFin: 57.69));
    pesos.add(TablaPesoEdad(meses: 28, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 57.7, pesoFin: 58.79 ));
    pesos.add(TablaPesoEdad(meses: 28, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 59.8, pesoFin: 61.89 ));
    pesos.add(TablaPesoEdad(meses: 28, genero: 'Masculino', resultado: '1DE',   pesoInicio: 61.9, pesoFin: 63.99));
    pesos.add(TablaPesoEdad(meses: 28, genero: 'Masculino', resultado: '2DE',   pesoInicio: 64.0, pesoFin: 74));

    pesos.add(TablaPesoEdad(meses: 29, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 57.8, pesoFin: 59.89));
    pesos.add(TablaPesoEdad(meses: 29, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 59.9, pesoFin: 62.09 ));
    pesos.add(TablaPesoEdad(meses: 29, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 62.1, pesoFin: 64.29 ));
    pesos.add(TablaPesoEdad(meses: 29, genero: 'Masculino', resultado: '1DE',   pesoInicio: 64.3, pesoFin: 66.39));
    pesos.add(TablaPesoEdad(meses: 29, genero: 'Masculino', resultado: '2DE',   pesoInicio: 66.4, pesoFin: 76));

    pesos.add(TablaPesoEdad(meses: 30, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 49.8, pesoFin: 51.69));
    pesos.add(TablaPesoEdad(meses: 30, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 51.7, pesoFin: 52.69 ));
    pesos.add(TablaPesoEdad(meses: 30, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 53.7, pesoFin: 54.59 ));
    pesos.add(TablaPesoEdad(meses: 30, genero: 'Masculino', resultado: '1DE',   pesoInicio: 55.6, pesoFin: 56.99));
    pesos.add(TablaPesoEdad(meses: 30, genero: 'Masculino', resultado: '2DE',   pesoInicio: 57.0, pesoFin: 67));

    pesos.add(TablaPesoEdad(meses: 31, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 61.2, pesoFin: 63.49));
    pesos.add(TablaPesoEdad(meses: 31, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 63.5, pesoFin: 65.69 ));
    pesos.add(TablaPesoEdad(meses: 31, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 65.7, pesoFin: 67.99 ));
    pesos.add(TablaPesoEdad(meses: 31, genero: 'Masculino', resultado: '1DE',   pesoInicio: 68.0, pesoFin: 70.29));
    pesos.add(TablaPesoEdad(meses: 31, genero: 'Masculino', resultado: '2DE',   pesoInicio: 70.3, pesoFin: 80));

    pesos.add(TablaPesoEdad(meses: 32, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 62.7, pesoFin: 64.99));
    pesos.add(TablaPesoEdad(meses: 32, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 65.0, pesoFin: 67.29 ));
    pesos.add(TablaPesoEdad(meses: 32, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 67.3, pesoFin: 69.59 ));
    pesos.add(TablaPesoEdad(meses: 32, genero: 'Masculino', resultado: '1DE',   pesoInicio: 69.6, pesoFin: 71.89));
    pesos.add(TablaPesoEdad(meses: 32, genero: 'Masculino', resultado: '2DE',   pesoInicio: 71.9, pesoFin: 81));

    pesos.add(TablaPesoEdad(meses: 33, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 64.0, pesoFin: 63.39));
    pesos.add(TablaPesoEdad(meses: 33, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 66.4, pesoFin: 68.69 ));
    pesos.add(TablaPesoEdad(meses: 33, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 68.7, pesoFin: 71.49 ));
    pesos.add(TablaPesoEdad(meses: 33, genero: 'Masculino', resultado: '1DE',   pesoInicio: 71.5, pesoFin: 73.49));
    pesos.add(TablaPesoEdad(meses: 33, genero: 'Masculino', resultado: '2DE',   pesoInicio: 73.5, pesoFin: 83.5));

    pesos.add(TablaPesoEdad(meses: 34, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 65.3, pesoFin: 67.69));
    pesos.add(TablaPesoEdad(meses: 34, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 67.7, pesoFin: 70.09));
    pesos.add(TablaPesoEdad(meses: 34, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 70.1, pesoFin: 72.69 ));
    pesos.add(TablaPesoEdad(meses: 34, genero: 'Masculino', resultado: '1DE',   pesoInicio: 72.7, pesoFin: 74.99));
    pesos.add(TablaPesoEdad(meses: 34, genero: 'Masculino', resultado: '2DE',   pesoInicio: 75.0, pesoFin: 85));

    pesos.add(TablaPesoEdad(meses: 35, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 66.5, pesoFin: 68.99));
    pesos.add(TablaPesoEdad(meses: 35, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 69.0, pesoFin: 71.49 ));
    pesos.add(TablaPesoEdad(meses: 35, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 71.5, pesoFin: 73.89 ));
    pesos.add(TablaPesoEdad(meses: 35, genero: 'Masculino', resultado: '1DE',   pesoInicio: 73.9, pesoFin: 76.39));
    pesos.add(TablaPesoEdad(meses: 35, genero: 'Masculino', resultado: '2DE',   pesoInicio: 76.4, pesoFin: 86.4));

    pesos.add(TablaPesoEdad(meses: 36, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 67.7, pesoFin: 70.29));
    pesos.add(TablaPesoEdad(meses: 36, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 70.3, pesoFin: 72.79 ));
    pesos.add(TablaPesoEdad(meses: 36, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 72.8, pesoFin: 75.29 ));
    pesos.add(TablaPesoEdad(meses: 36, genero: 'Masculino', resultado: '1DE',   pesoInicio: 75.3, pesoFin: 77.79));
    pesos.add(TablaPesoEdad(meses: 36, genero: 'Masculino', resultado: '2DE',   pesoInicio: 77.8, pesoFin: 87.8));

    pesos.add(TablaPesoEdad(meses: 37, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 68.9, pesoFin: 71.39));
    pesos.add(TablaPesoEdad(meses: 37, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 71.4, pesoFin: 73.99 ));
    pesos.add(TablaPesoEdad(meses: 37, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 74.0, pesoFin: 76.59 ));
    pesos.add(TablaPesoEdad(meses: 37, genero: 'Masculino', resultado: '1DE',   pesoInicio: 76.6, pesoFin: 79.19));
    pesos.add(TablaPesoEdad(meses: 37, genero: 'Masculino', resultado: '2DE',   pesoInicio: 79.2, pesoFin: 89.2));

    pesos.add(TablaPesoEdad(meses: 38, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 38, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 38, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 38, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 38, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 39, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 71.0, pesoFin: 73.69));
    pesos.add(TablaPesoEdad(meses: 39, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 73.7, pesoFin: 76.39 ));
    pesos.add(TablaPesoEdad(meses: 39, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 76.4, pesoFin: 79.09 ));
    pesos.add(TablaPesoEdad(meses: 39, genero: 'Masculino', resultado: '1DE',   pesoInicio: 79.1, pesoFin: 81.69));
    pesos.add(TablaPesoEdad(meses: 39, genero: 'Masculino', resultado: '2DE',   pesoInicio: 81.7, pesoFin: 91.7));

    pesos.add(TablaPesoEdad(meses: 40, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 72.0, pesoFin: 74.79));
    pesos.add(TablaPesoEdad(meses: 40, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 74.8, pesoFin: 77.49 ));
    pesos.add(TablaPesoEdad(meses: 40, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 77.5, pesoFin: 80.19 ));
    pesos.add(TablaPesoEdad(meses: 40, genero: 'Masculino', resultado: '1DE',   pesoInicio: 80.2, pesoFin: 82.99));
    pesos.add(TablaPesoEdad(meses: 40, genero: 'Masculino', resultado: '2DE',   pesoInicio: 83.0, pesoFin: 93.0));

    pesos.add(TablaPesoEdad(meses: 41, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 73.0, pesoFin: 75.79));
    pesos.add(TablaPesoEdad(meses: 41, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 75.8, pesoFin: 78.59 ));
    pesos.add(TablaPesoEdad(meses: 41, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 78.6, pesoFin: 81.39 ));
    pesos.add(TablaPesoEdad(meses: 41, genero: 'Masculino', resultado: '1DE',   pesoInicio: 81.4, pesoFin: 84.19));
    pesos.add(TablaPesoEdad(meses: 41, genero: 'Masculino', resultado: '2DE',   pesoInicio: 84.2, pesoFin: 94.2));

    pesos.add(TablaPesoEdad(meses: 42, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 74.0, pesoFin: 76.79));
    pesos.add(TablaPesoEdad(meses: 42, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 76.8, pesoFin: 79.69 ));
    pesos.add(TablaPesoEdad(meses: 42, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 79.7, pesoFin: 82.49 ));
    pesos.add(TablaPesoEdad(meses: 42, genero: 'Masculino', resultado: '1DE',   pesoInicio: 82.5, pesoFin: 84.39));
    pesos.add(TablaPesoEdad(meses: 42, genero: 'Masculino', resultado: '2DE',   pesoInicio: 85.4, pesoFin: 95.4));
    //
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 43, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));
    
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 44, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 45, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 45, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 45, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 45, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 45, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 46, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 46, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 46, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 46, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 46, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 47, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 47, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 47, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 47, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 47, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 48, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 48, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 48, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 48, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 48, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 49, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 49, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 49, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 49, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 49, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 50, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 74.0, pesoFin: 76.79));
    pesos.add(TablaPesoEdad(meses: 50, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 76.8, pesoFin: 79.69 ));
    pesos.add(TablaPesoEdad(meses: 50, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 79.7, pesoFin: 82.49 ));
    pesos.add(TablaPesoEdad(meses: 50, genero: 'Masculino', resultado: '1DE',   pesoInicio: 82.5, pesoFin: 84.39));
    pesos.add(TablaPesoEdad(meses: 50, genero: 'Masculino', resultado: '2DE',   pesoInicio: 85.4, pesoFin: 95.4));
    //
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 51, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));
    
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 52, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 53, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 53, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 53, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 53, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 53, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 54, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 54, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 54, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 54, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 54, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 55, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 55, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 55, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 55, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 55, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 56, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 56, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 56, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 56, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 56, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 57, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 57, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 57, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 57, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 57, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 58, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 58, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 58, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 58, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 58, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 59, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 59, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 59, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 59, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 59, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));

    pesos.add(TablaPesoEdad(meses: 60, genero: 'Masculino', resultado: '-2DE',  pesoInicio: 70.0, pesoFin: 72.59));
    pesos.add(TablaPesoEdad(meses: 60, genero: 'Masculino', resultado: '-1DE',  pesoInicio: 72.6, pesoFin: 75.19 ));
    pesos.add(TablaPesoEdad(meses: 60, genero: 'Masculino', resultado: 'MEDIA', pesoInicio: 75.2, pesoFin: 77.79 ));
    pesos.add(TablaPesoEdad(meses: 60, genero: 'Masculino', resultado: '1DE',   pesoInicio: 77.8, pesoFin: 80.49));
    pesos.add(TablaPesoEdad(meses: 60, genero: 'Masculino', resultado: '2DE',   pesoInicio: 80.5, pesoFin: 90.5));




  }


}