import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class AuthService extends ChangeNotifier{

  final String _baseUrl ='identitytoolkit.googleapis.com';
  final String _firebaseToken='AIzaSyDr0sAYzHkwMm0Q0lCTBLf6pbfarXevxWo';

  static String _idUserToken = '';

  String get idUserToken => _idUserToken;

  static String? _email;

  String? get email => _email;

  final storage = const FlutterSecureStorage();


  //Si se retorna algo es un error, caso contrario registro ok
  Future<String?> createUser(String email, String password) async{


    final Map<String,dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp',{
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));


    final Map<String,dynamic> decodedResp = json.decode(resp.body);

    if(decodedResp.containsKey('idToken')){
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }

  }

  Future<String?> loginUser(String email, String password) async{

    final Map<String,dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword',{
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));


    final Map<String,dynamic> decodedResp = json.decode(resp.body);

    if(decodedResp.containsKey('idToken')){
      _idUserToken = decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);
      _email = email;
      return null;
    } else {
      return decodedResp['error']['message'];
    }

  }


  Future logout() async{
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async{

    return await storage.read(key: 'token') ?? '';
  }



  Future<String> resetUser(String email) async{

    final Map<String,dynamic> authData ={
      'requestType': "PASSWORD_RESET",
      'email': email
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:sendOobCode',{
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String,dynamic> decodedResp = json.decode(resp.body);

    if(decodedResp.containsKey('email')){
      return '';
    } else {
      return decodedResp['error']['message'];
    }


  }



}