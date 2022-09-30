// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/models/ninios.dart';


class NinioCard extends StatelessWidget {
  
  final Ninio ninio;

  const NinioCard({
    super.key, 
    required this.ninio});

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
                icon: ninio.genero == 'Femenino' ? FontAwesomeIcons.childDress : FontAwesomeIcons.child,
                color: ninio.genero == 'Femenino' ? Colors.pink : Colors.blue,
              ),
            ),

            _NinioDetails(
              nombre: ninio.nombres,
              id: ninio.id.toString(),
              color: ninio.genero == 'Femenino' ? Colors.pink : Colors.blue,
              fechaNac: ninio.fechaNacimiento,
            ),

            Positioned(
              top: 0,
              right: 0,
              child: GenderTag(
                icon: ninio.genero == 'Femenino' ? FontAwesomeIcons.venus : FontAwesomeIcons.mars, 
                color: ninio.genero == 'Femenino' ? Colors.pink : Colors.blue
              ),
            ),

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

class NotAvailable extends StatelessWidget {

  const NotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomRight: Radius.circular(25))
        ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          ),
        ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class GenderTag extends StatelessWidget {

  final IconData icon;
  final Color color;

  const GenderTag({super.key, required this.icon, required this.color});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(icon,color: Colors.white,size: 30,)
        ),
      ),
    );
  }
}

class _NinioDetails extends StatelessWidget {

  final String nombre;
  final String id;
  final Color color;
  final String fechaNac;

  const _NinioDetails({
    required this.nombre,
    required this.id, 
    required this.color, 
    required this.fechaNac,
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
            overflow: TextOverflow.ellipsis,
            ),
            Text(id, style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Text('Nacimiento: $fechaNac', style: TextStyle(color: Colors.white, fontSize: 15),
            ),
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
    return Icon(icon, size: 80,color: color,);
  }
}