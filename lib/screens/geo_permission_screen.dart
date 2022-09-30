import 'package:flutter/material.dart';
import 'package:nutri_app/providers/providers.dart';
import 'package:provider/provider.dart';


class GeoPermissionScreen extends StatelessWidget {

  const GeoPermissionScreen({super.key});

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
        const SizedBox(height: 20,),
        MaterialButton(
          padding: const EdgeInsets.all(10),
          color: Colors.black,
          shape: const StadiumBorder(),
          onPressed: ()async{
            await gpsProvider.askGpsAccess();
            if(gpsProvider.isAllGranted)
            {
              // ignore: use_build_context_synchronously
              Navigator.popAndPushNamed(context, 'geo');
            }else{
              null;
            }
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