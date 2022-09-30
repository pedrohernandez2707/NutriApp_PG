import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutri_app/providers/providers.dart';
import 'package:provider/provider.dart';



class GeoScreen extends StatelessWidget {

  const GeoScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final locationProvider = Provider.of<LocationProvider>(context);
    locationProvider.getCurrPosition();
    

    final CameraPosition initialcamera = CameraPosition(
      //bearing: 192.8334901395799,
      target: LatLng(locationProvider.lastKnowLocation!.latitude, locationProvider.lastKnowLocation!.longitude),
      //tilt: 59.440717697143555,
      zoom: 15);

    return Scaffold(
      body: Center(
        child: locationProvider.lastKnowLocation!.longitude != 0   
        ? SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height,
                child: GoogleMap(
                  initialCameraPosition: initialcamera,
                  myLocationEnabled: true,  
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,

                  onMapCreated: (controller) { 
                    locationProvider.onInitMap(controller);
                  },
                ),
              ),
            ],
          ),
        )
        : const Text('Espere Porfavor')
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 30,
            child: IconButton(
              onPressed: (){
                final userLocation =locationProvider.lastKnowLocation;
                
                if (userLocation == null)return;

                locationProvider.moveCamera(userLocation);
              }, 
              icon: const Icon(Icons.my_location_outlined,color: Colors.black,size: 30,),
          ),
          )
        )
      ],
    ),
    );
   
  }

}