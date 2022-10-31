import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutri_app/services/services.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';


class GraficaScreen extends StatelessWidget {
  const GraficaScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final ninioService = Provider.of<NiniosService>(context, listen: false);
    //medicionService.loadMediciones(ninioService.selectedninio.cui);

    final Color? color; 
    color = ninioService.selectedninio.genero == 'Femenino' 
    ? Colors.pink[300]
    : Colors.blue;

    final urlPeso = ninioService.selectedninio.genero == 'Femenino'
    ? 'assets/NiñasPesoEdad.png'
    : 'assets/NiñosPesoEdad.png';

    final urlTalla = ninioService.selectedninio.genero == 'Femenino'
    ? 'assets/NiñasTallaEdad.png'
    : 'assets/NiñosTallaEdad.png';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25,),

            Text('Peso para la Edad', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),

            SizedBox(
              width: size.width,
              height: 350,
              child: PinchZoom(
                    child: Image(
                      image: AssetImage(urlPeso),
                      fit: BoxFit.contain,
                    ),
                    maxScale: 2.5,
                  ),
            ),

            SizedBox(height: 25,),


            Text('Talla para la Edad', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),


            SizedBox(
              width: size.width,
              height: 350,
              child: PinchZoom(
                    child: Image(
                      image: AssetImage(urlTalla),
                      fit: BoxFit.contain,
                    ),
                    maxScale: 2.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

}