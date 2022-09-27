import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/screens/screens.dart';
import 'package:nutri_app/services/services.dart';
import 'package:nutri_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';


class GestionUsuariosScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final usuarioService = Provider.of<UsuarioService>(context);

    //ninioService.loadninios();

    if(usuarioService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Usuarios'),
      ),
      body: ListView.builder(
          itemCount: usuarioService.usuarios.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              usuarioService.selectedUsuario = usuarioService.usuarios[index].copy();
              usuarioService.exists =true;
              Navigator.pushNamed(context, 'registro');
            },
            child: UsuarioCard(usuario: usuarioService.usuarios[index] ),
          )
        ),
     floatingActionButton: FloatingActionButton(
       onPressed: (){
        usuarioService.selectedUsuario = Usuario(
            nombre: '',
            email: '',
            password: '',
            firebaseToken: '',
            permisos: Permisos(geolocalizacion: false, visualizacion: false, registro: false, usuarios: false)
          );
         Navigator.pushReplacementNamed(context, 'registro');
       },
       child: const Icon(FontAwesomeIcons.userPlus),
     ),
   );
  }
}


