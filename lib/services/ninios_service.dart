
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:nutri_app/helpers/debouncer.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nutri_app/models/ninios.dart';
import 'package:http/http.dart' as http;

import 'services.dart';

class NiniosService extends ChangeNotifier{

  NiniosService(){
    loadninios();
  }

  final String _baseUrl ='desnutriapp-default-rtdb.firebaseio.com';
  //final String _firebaseToken='AIzaSyDr0sAYzHkwMm0Q0lCTBLf6pbfarXevxWo';

  List<Ninio> ninios =[];

  final List<Ninio> niniosSearch =[];


  late Ninio selectedninio;

  bool isLoading = true;
  bool isSaving = false;
  bool exists = false;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 1000)
  );

  final StreamController<List<Ninio>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Ninio>> get suggestionStream => _suggestionStreamController.stream;

  void fecha(DateTime date){
    selectedninio.fechaNacimiento = date.toString();
    notifyListeners();
  }
  
  Future<List<Ninio>> loadninios() async{
    final authService = AuthService().idUserToken;
    
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'Niños.json',{
      'auth': authService
    });

    final resp = await http.get(url);

    final Map<String, dynamic> niniosMap =json.decode(resp.body);

    niniosMap.forEach((key, value) {
      final tempNinio = Ninio.fromMap(value);
      tempNinio.id = key;
      ninios.add(tempNinio);
    });
      
    ninios.sort((item1, item2) => item1.nombres.compareTo(item2.nombres));
   
    await Future.delayed(const Duration(milliseconds: 2000));

    isLoading = false;
    notifyListeners();
    return ninios;

  }

  Future saveOrCreateNinio(Ninio ninio) async{

    isSaving = true;
    notifyListeners();

    if(exists==false){
      //Crear
      await createNinio(ninio);
    } else {
      //actualizar
      await updateNinio(ninio);
    }

    isSaving = false;
    notifyListeners();
  }


  Future<String> updateNinio(Ninio ninio) async{

    final authService = AuthService().idUserToken;

    final url = Uri.https(_baseUrl, 'Niños/${ninio.id}.json',{
      'auth': authService
    });
    
    // ignore: unused_local_variable
    final resp = await http.put(url, body: ninio.toJson());

    //Actualizar listado de ninños
    final index = ninios.indexWhere((element) => element.id == ninio.id);
    ninios[index] = ninio;

    return ninio.id!;
  }


  Future<String> createNinio(Ninio ninio) async{

    final authService = AuthService().idUserToken;

    final url = Uri.https(_baseUrl, 'Niños.json',{
      'auth': authService,
      'name': ninio.id
    });
    final resp = await http.post(url, body: ninio.toJson());

    final decodedData = json.decode(resp.body);

    ninio.id = decodedData['name'];

    ninios.add(ninio);

    return ninio.id!;
  }


  Future<List<Ninio>> searchninios(String query) async{

    final authService = AuthService().idUserToken;
    
    //isLoading = true;
    //notifyListeners();

    final url = Uri.https(_baseUrl, 'Niños.json',{
      'auth'   : authService,
      'orderBy': '"nombres"',
      'startAt': '"$query"',
      // ignore: unnecessary_brace_in_string_interps
      'endAt'  : '"${query}\uf8ff"'
    });


    final resp = await http.get(url);

    if (resp.statusCode != 200) return[];

    final Map<String, dynamic> niniosMap = json.decode(resp.body);

    niniosSearch.clear();

    niniosMap.forEach((key, value) {
      final tempNinio = Ninio.fromMap(value);
      tempNinio.id = key;
      niniosSearch.add(tempNinio);
    });

    //isLoading = false;
    //notifyListeners();
    return niniosSearch;
  }

  void getSuggestionByQuery(String query){

    debouncer.value ='';
    debouncer.onValue =(value) async{

      final results = await searchninios(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 500), (_) { 
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 501)).then((_) => timer.cancel());

  }
  
}