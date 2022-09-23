// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/screens/search_delegate.dart';
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

    final items = <ItemBoton>[
      ItemBoton( FontAwesomeIcons.userLarge, 'Gestion de Usuarios', Color(0xff6989F5), Color(0xff906EF5) ),
      ItemBoton( FontAwesomeIcons.pencil, 'Registro de Datos', Color(0xff66A9F2), Color(0xff536CF6) ),
      ItemBoton( FontAwesomeIcons.eye, 'Visualizacion de Datos', Color(0xffF2D572), Color(0xffE06AA3) ),
      ItemBoton( FontAwesomeIcons.locationDot, 'Geolocalizacion', Color(0xff317183), Color(0xff46997D) ),
    ];
      
  
    List<Widget> itemMap = items.map(
      (item) => FadeInLeft(
        duration: Duration( milliseconds: 250 ),
        child: BotonGordo(
          icon: item.icon,
          texto: item.texto,
          color1: item.color1,
          color2: item.color2,
          onPress: () async{ 
            
            switch (item.texto) {
              case 'Gestion de Usuarios':

                Navigator.pushNamed(context, 'gestion_usuario');
                
              break;

              case 'Registro de Datos':

                Navigator.pushNamed(context, 'registro_datos');

              break;

              case 'Visualizacion de Datos':

                //Navigator.pushNamed(context, 'visualizacion');
                showSearch(context: context, delegate: NinioSearchDelegate());

              break;

              case 'Geolocalizacion':

                await gpsProvider.init();

                gpsProvider.isAllGranted
                ? Navigator.pushNamed(context, 'geo')
                : Navigator.pushNamed(context, 'permission');
              
              break;
              default:
            }
          
          },
        ),
      )
    ).toList();


    return Scaffold(
      //appBar: AppBar(),
      //drawer: _MenuLateral(),
      // backgroundColor: Colors.red,
      body: Stack(
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
      )
   );
  }
}


class _MenuLateral extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("CODEA APP"),
              accountEmail: Text("informes@gmail.com"),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://dominio.com/imagen/recurso.jpg"),
                fit: BoxFit.cover
              )
            ),
          ),
          Ink(
            color: Colors.indigo,
            child: ListTile(
              title: Text("MENU 1", style: TextStyle(color: Colors.white),),
            ),
          ),
          ListTile(
            title: Text("MENU 2"),
            onTap: (){},
          ),
          ListTile(
            title: Text("MENU 3"),
          ),
          ListTile(
            title: Text("MENU 4"),
          )

        ],
      ) ,
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
          icon: FontAwesomeIcons.plus, 
          titulo: 'Aplicacion Movil Para Registro y Control de niños con Desnutricion', 
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

class BotonGordoTemp extends StatelessWidget {
  const BotonGordoTemp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BotonGordo(
      icon: FontAwesomeIcons.carBurst,
      texto: 'Motor Accident',
      color1: Color(0xff6989F5),
      color2: Color(0xff906EF5),
      onPress: (){ print('Click!'); },
    );
  }
}

// class PageHeader extends StatelessWidget {
//   const PageHeader({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return IconHeader(
//       icon: FontAwesomeIcons.plus,
//       subtitulo: 'Haz Solicitado',
//       titulo: 'Asistencia Médica',
//       color1: Color(0xff526BF6),
//       color2: Color(0xff67ACF2),
//     );
//   }
// }