// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/models/models.dart';


class UsuarioCard extends StatelessWidget {
  
  final Usuario usuario;

  const UsuarioCard({
    super.key, 
    required this.usuario});

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(bottom: 40, top: 30),
        width: double.infinity,
        height: 200,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [

            Positioned(
              top: 20,
              child: _BackgroundIcon(
                icon: FontAwesomeIcons.user,
                color: Colors.indigo
              ),
            ),

            _UsuarioDetails(
              nombre: usuario.nombre,
              color: Colors.indigo,
              correo: usuario.email,
            ),

            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: GenderTag(
            //     icon: ninio.genero == 'Femenino' ? FontAwesomeIcons.venus : FontAwesomeIcons.mars, 
            //     color: ninio.genero == 'Femenino' ? Colors.pink : Colors.blue
            //   ),
            // ),

            // if(!product.available)
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   child: NotAvailable(),
            // )
          ]
        ),
      ),
    );
  }


   BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const[
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,7),
        blurRadius: 10
      )
    ]
  );


}




class _UsuarioDetails extends StatelessWidget {

  final String nombre;
  final Color color;
  final String correo;

  const _UsuarioDetails({
    required this.nombre,
    required this.color, 
    required this.correo,
    });
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 80,
        //color: Colors.indigo,
        decoration: _buidBoxDecoration(color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(nombre, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,),
            SizedBox(height: 10,)
    ,
            Text('Email: $correo', style: TextStyle(color: Colors.white, fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
          ]
        ),
      ),
    );
  }

  BoxDecoration _buidBoxDecoration(Color color) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25))
  );
}


class _BackgroundIcon extends StatelessWidget {

  final IconData icon;
  final Color color;

  const _BackgroundIcon({
    required this.icon, 
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 70,color: color,);
  }
}
