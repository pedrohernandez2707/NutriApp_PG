import 'package:flutter/material.dart';
import 'package:nutri_app/models/ninios.dart';


class NinioFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> tutorFormKey = GlobalKey<FormState>();

  Ninio ninio;

  NinioFormProvider(this.ninio);

   updatedate(DateTime date){

     ninio.fechaNacimiento = date.toString();
     notifyListeners();
   }


  bool isValidForm(){
    
    return formKey.currentState?.validate() ?? false;

  }

   bool isValidTutorForm(){
    
    return tutorFormKey.currentState?.validate() ?? false;

  }

}