import 'package:flutter/material.dart';


class GestionUsuariosScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        
      ),
      body: Center(
        child: Text('GestionUsuariosScreen'),
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: (){
         Navigator.pushReplacementNamed(context, 'registro');
       },
       child: Icon(Icons.add),
     ),
   );
  }
}