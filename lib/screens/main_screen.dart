// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/screens/search_delegate.dart';
import 'package:nutri_app/services/services.dart';
import 'package:provider/provider.dart';
//import 'package:nutri_app/providers/login_form_provider.dart';
//import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../widgets/boton_gordo.dart';
import '../widgets/headers.dart';


class ItemBoton {

  final IconData icon;
  final String texto;
  final Color color1;
  final Color color2;

  ItemBoton( this.icon, this.texto, this.color1, this.color2 );
}

class MainScreen extends StatelessWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){

    final gpsProvider = Provider.of<GpsProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context,listen: false);
    final usuarioProvider = Provider.of<UsuarioService>(context);
    final authProvider = Provider.of<AuthService>(context, listen: false);

    usuarioProvider.selectedUser(authProvider.email.toString());
    //TODO: Cambiar por el correo
    //usuarioProvider.selectedUser('phernandezg7@miumg.edu.gt');
    

    final items = <ItemBoton>[
      ItemBoton( FontAwesomeIcons.userLarge, 'Gestión de Usuarios', Color(0xff6989F5), Color(0xff906EF5) ),
      ItemBoton( FontAwesomeIcons.pencil, 'Registro de Datos', Color(0xff66A9F2), Color(0xff536CF6) ),
      ItemBoton( FontAwesomeIcons.eye, 'Visualización de Datos', Color(0xffF2D572), Color(0xffE06AA3) ),
      ItemBoton( FontAwesomeIcons.locationDot, 'Geolocalización', Color(0xff317183), Color(0xff46997D) ),
    ];
      
  
    List<Widget> itemMap = items.map(
      (item) => FadeInLeft(
        duration: Duration( milliseconds: 500 ),
        child: BotonGordo(
          icon: item.icon,
          texto: item.texto,
          color1: item.color1,
          color2: item.color2,
          onPress: () async{ 
            
            switch (item.texto) {
              case 'Gestión de Usuarios':
              !usuarioProvider.usuarioLogin.permisos.usuarios
              ?
                showDialog(
                  context: context, 
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Usuario sin Acceso',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                    content: Text('Usted No tiene Acceso!'),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, 
                        child: const Text('OK')
                      )
                    ],
                  )
                )

              : Navigator.pushNamed(context, 'gestion_usuario');
                
              break;

              case 'Registro de Datos':

              !usuarioProvider.usuarioLogin.permisos.registro
              ?
                showDialog(
                  context: context, 
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Usuario sin Acceso',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                    content: Text('Usted No tiene Acceso!'),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, 
                        child: const Text('OK')
                      )
                    ],
                  )
                )

              : Navigator.pushNamed(context, 'registro_datos');

              break;

              case 'Visualización de Datos':
                !usuarioProvider.usuarioLogin.permisos.visualizacion
              ?
                showDialog(
                  context: context, 
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Usuario sin Acceso',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                    content: Text('Usted No tiene Acceso!'),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, 
                        child: const Text('OK')
                      )
                    ],
                  )
                )

              : showSearch(context: context, delegate: NinioSearchDelegate());

              break;

              case 'Geolocalización':

              if(!usuarioProvider.usuarioLogin.permisos.geolocalizacion){   
                showDialog(
                  context: context, 
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Usuario sin Acceso',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                    content: Text('Usted No tiene Acceso!'),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, 
                        child: const Text('OK')
                      )
                    ],
                  )
                );

              }else{

                await gpsProvider.init();
                
                if(gpsProvider.isAllGranted){ 
                  await locationProvider.getCurrPosition();
                  await locationProvider.getMarkers(context);
                  Navigator.pushNamed(context, 'geo');
                }else{
                  Navigator.pushNamed(context, 'permission');
                }
              }
              break;
              default:
                break;
            }
          },
        ),
      )
    ).toList();


    return Scaffold(
      //appBar: AppBar(),
      //drawer: _MenuLateral(),
      // backgroundColor: Colors.red,
      body: RefreshIndicator(
        onRefresh: ()async{
          await Future.delayed(const Duration(milliseconds: 1000));
          Navigator.pushReplacementNamed(context, 'main');
        },
        child: Stack(
          children: <Widget>[
            
            Container(
              margin: EdgeInsets.only( top: 200 ),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  SizedBox( height: 80, ),
                  ...itemMap
                ],
              ),
            ),

            _Encabezado()

          ],
        ),
      )
   );
  }
}


class _Encabezado extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    //final userProvider = Provider.of<LoginFormProvider>(context,listen: false);

    return Stack(
      children: <Widget>[
        IconHeader(
          icon: FontAwesomeIcons.children, 
          titulo: 'Aplicación Móvil Para Registro y Control de Niños con Desnutricion Infantil', 
          subtitulo: 'APRODIGUA',
          color1: Color(0xff536CF6),
          color2: Color(0xff66A9F2),
          //nombreUsuario: userProvider.email,
        ),

        Positioned(
          right: 0,
          top: 45,
          child: RawMaterialButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(15.0),
            child: FaIcon( FontAwesomeIcons.arrowRightFromBracket, color: Colors.white )
          )
        )

      ],
    );
  }
}


