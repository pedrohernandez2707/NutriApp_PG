import 'package:flutter/material.dart';


class CustomSnackBar extends SnackBar{


  CustomSnackBar({
    Key? key, 
    required String msg,
    String btnLabel = 'Ok',
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onPress
  }) : super(key: key, 
    content: Text(msg),
    action: SnackBarAction(
      label: btnLabel,
      onPressed: (){
        if(onPress !=null){
          onPress();
        }
      },
    )
  );

}