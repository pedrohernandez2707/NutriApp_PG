import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nutri_app/models/marcadores.dart';
import 'package:nutri_app/providers/location_provider.dart';
import 'package:nutri_app/services/ninios_service.dart';
import 'package:provider/provider.dart';

import '../ui/ui.dart';


class ManualMarker extends StatelessWidget {
  const ManualMarker({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final locationProvider = Provider.of<LocationProvider>(context);
    final ninioService = Provider.of<NiniosService>(context,listen: false);

    final size = MediaQuery.of(context).size;

    return locationProvider.displayManualMarker
    
    ? SizedBox(
      width: size.width,
      height: size.height, 
      child: Stack(
        children: [

          const Positioned(
            top: 70,
            left: 20,
            child: _BtnBack()
          ),

          Center(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: BounceInDown(
                from: 100,
                child: const Icon(Icons.location_on_rounded, size: 75,)
                ),
            ),
          ),

          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              child: MaterialButton(
                minWidth: size.width-120,
                onPressed: (){

                 if (locationProvider.centerMap == null) return;

                 try {
                    Marcadores marker = Marcadores(
                      cui: ninioService.selectedninio.cui, 
                      lat: locationProvider.centerMap!.latitude, 
                      lng: locationProvider.centerMap!.longitude);

                  locationProvider.saveOrCreateMarcador(marker, context);

                  final snack = CustomSnackBar(msg: 'Proceso Exitoso!');
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                  locationProvider.displayManualMarker = false;

                 } catch (e) {
                  final snack = CustomSnackBar(msg: 'Hubo un Error: ${e.toString()}');
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                 }
                  //print(locationProvider.centerMap);
                },
                color: Colors.black,
                height: 50,
                shape: const StadiumBorder(),
                child: const Text('Confirmar Ubicacion', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
              ),
            )
          )

        ],
      ),
    )
    : const SizedBox();
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: CircleAvatar(
        maxRadius: 35,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,),
          onPressed: (){
            final locationProvider = Provider.of<LocationProvider>(context, listen: false);
            locationProvider.displayManualMarker = false;
          },
        ),

      ),
    );
  }
}