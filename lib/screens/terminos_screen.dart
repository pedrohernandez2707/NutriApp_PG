import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class TerminosScreen extends StatelessWidget {
  
  const TerminosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        children: const[
          SizedBox(height: 20,),
          Center(
            child: AboutListTile(
                icon: Icon(FontAwesomeIcons.userLock,size: 50,),
                dense: false,
                child: Text('Terminos y condiciones',style: TextStyle(fontSize: 25),textAlign: TextAlign.center,),
                aboutBoxChildren: [
                  Text('No esta permitida la copia, duplicación, distribución parcial o total del contenido de este manual sin plena y previa autorización del autor, para comunicación consultar el final de esta pagina.',),
                ],
            ),
          ),
        ],
      )
   );
  }
}