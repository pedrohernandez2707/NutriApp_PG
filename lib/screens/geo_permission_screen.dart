import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/providers/providers.dart';
import 'package:provider/provider.dart';


class GeoPermissionScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final gpsProvider = Provider.of<GpsProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: !gpsProvider.isGpsEnabled
         ? const _EnableGpsAccess()
         : const _AccessButton()
     ),
   );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final gpsProvider = Provider.of<GpsProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso al GPS', style: TextStyle(fontSize: 22),),
        SizedBox(height: 20,),
        MaterialButton(
          padding: EdgeInsets.all(10),
          color: Colors.black,
          shape: const StadiumBorder(),
          onPressed: (){
            gpsProvider.askGpsAccess();
            gpsProvider.isAllGranted
            ? Navigator.popAndPushNamed(context, 'geo')
            : null;
          },
          child: const Text('Solicitar Acceso', style: TextStyle(fontSize: 26,color: Colors.white),)
        )
      ]
    );
  }
}


class _EnableGpsAccess extends StatelessWidget {
  const _EnableGpsAccess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.location_off, color: Colors.red,size: 125,),
          Text('Debe de Habilitar el Gps', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),),
        ],
      ),
    );
  }
}