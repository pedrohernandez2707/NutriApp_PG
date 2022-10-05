

import 'package:flutter/cupertino.dart';
import 'package:nutri_app/models/models.dart';

class MedicionFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Medicion medicion;

  MedicionFormProvider(this.medicion);

  set medicionNotasPeso(String value){
    medicion.notasPeso = value;
    notifyListeners();
  }

  set medicionNotasTalla(String value){
    medicion.notasTalla = value;
    notifyListeners();
  }

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }




}