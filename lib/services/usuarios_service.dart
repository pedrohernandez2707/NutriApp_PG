import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutri_app/models/models.dart';
import 'package:http/http.dart' as http;

//curl 'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=[API_KEY]' \
//-H 'Content-Type: application/json' --data-binary '{"idToken":"[FIREBASE_ID_TOKEN]"}'


class UsuarioService extends ChangeNotifier{

  final String _baseUrl ='desnutriapp-default-rtdb.firebaseio.com';
  final String _firebaseToken='AIzaSyDr0sAYzHkwMm0Q0lCTBLf6pbfarXevxWo';

  final List<Usuario> usuarios =[];

  late Usuario selectedUsuario;
  late Usuario usuarioLogin;

  bool isLoading = false;
  bool exists = false;

  UsuarioService(){
    loadUsuarios();
  }


  Future<List<Usuario>> loadUsuarios() async{
    
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'Usuarios.json',{
      'auth': _firebaseToken
    });

    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap =json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUsuario = Usuario.fromMap(value);
      tempUsuario.firebaseToken = key;
      usuarios.add(tempUsuario);
    });

    isLoading = false;
    notifyListeners();
    return usuarios;
  }


  Future<String> createUsuario(Usuario usuario) async{

    final url = Uri.https(_baseUrl, 'Usuarios.json',{
      'auth': _firebaseToken,
      'name': usuario.id
    });
    final resp = await http.post(url, body: usuario.toJson());

    final decodedData = json.decode(resp.body);

    usuario.id = decodedData['name'];

    usuarios.add(usuario);

    return usuario.id!;
    
  }


  Future<String> deleteUsuario(Usuario usuario) async{

    final url = Uri.https(_baseUrl, 'Usuarios.json',{
      'auth': _firebaseToken,
      'name': usuario.id
    });
    final resp = await http.post(url, body: usuario.toJson());

    final decodedData = json.decode(resp.body);

    usuario.id = decodedData['name'];

    usuarios.add(usuario);

    return usuario.id!;
    
  }

  void selectedUser(String email){
    usuarios.forEach((element) {
      if(element.email == email){
        usuarioLogin =element;
      }
    });

  }




}