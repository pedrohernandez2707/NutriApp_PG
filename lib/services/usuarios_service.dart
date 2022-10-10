import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutri_app/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:nutri_app/services/auth_service.dart';


//curl 'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=[API_KEY]' \
//-H 'Content-Type: application/json' --data-binary '{"idToken":"[FIREBASE_ID_TOKEN]"}'


class UsuarioService extends ChangeNotifier{

   GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final String _baseUrl ='desnutriapp-default-rtdb.firebaseio.com';
  //final String _firebaseToken='AIzaSyDr0sAYzHkwMm0Q0lCTBLf6pbfarXevxWo';

  final List<Usuario> usuarios =[];

  late Usuario selectedUsuario;
  late Usuario usuarioLogin;

  bool isLoading = false;
  bool exists = false;

  UsuarioService(){
    loadUsuarios();
  }


  Future<List<Usuario>> loadUsuarios() async{

    final authService = AuthService().idUserToken;
    
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'Usuarios.json',{
      //'auth': _firebaseToken
      'auth': authService
    });

    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap =json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUsuario = Usuario.fromMap(value);
      tempUsuario.id = key;
      usuarios.add(tempUsuario);
    });

    isLoading = false;
    notifyListeners();
    return usuarios;
  }


  Future<String> createUsuario(Usuario usuario) async{

    final authService = AuthService().idUserToken;

    final url = Uri.https(_baseUrl, 'Usuarios.json',{
      'auth': authService,
      'name': usuario.id
    });
    
    final resp = await http.post(url, body: usuario.toJson());

    final decodedData = json.decode(resp.body);

    usuario.id = decodedData['name'];

    usuarios.add(usuario);

    return usuario.id!;
    
  }


  Future<String> deleteUsuario(Usuario usuario) async{

    final authService = AuthService().idUserToken;

    final url = Uri.https(_baseUrl, 'Usuarios.json',{
      'auth': authService,
      'name': usuario.id
    });
    final resp = await http.post(url, body: usuario.toJson());

    final decodedData = json.decode(resp.body);

    usuario.id = decodedData['name'];

    usuarios.add(usuario);

    return usuario.id!;
    
  }

  void selectedUser(String email){
    // ignore: avoid_function_literals_in_foreach_calls
    usuarios.forEach((element) {
      if(element.email == email){
        usuarioLogin = element;
      }
    });

  }


  Future saveOrCreateUsuario(Usuario usuario) async{

    isLoading = true;
    notifyListeners();

    if(exists == false){
      //Crear
      await createUser(usuario);
    } else {
      //actualizar
      await updateUser(usuario);
    }

    isLoading = false;
    notifyListeners();
  }


  Future<String> updateUser(Usuario usuario) async{

    final authService = AuthService().idUserToken;

    final url = Uri.https(_baseUrl, 'Usuarios/${usuario.id}.json',{
      'auth': authService
    });
    
    // ignore: unused_local_variable
    final resp = await http.put(url, body: usuario.toJson());

    //Actualizar listado de ninños
    final index = usuarios.indexWhere((element) => element.id == usuario.id);
    usuarios[index] = usuario;

    return usuario.id!;
  }


  Future<String> createUser(Usuario usuario) async{

    final authService = AuthService().idUserToken;

    final url = Uri.https(_baseUrl, 'Usuarios.json',{
      'auth': authService
    });
    final resp = await http.post(url, body: usuario.toJson());

    final decodedData = json.decode(resp.body);

    usuario.id = decodedData['name'];

    usuarios.add(usuario);

    return usuario.id!;
  }


}