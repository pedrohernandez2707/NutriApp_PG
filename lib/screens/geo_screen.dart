import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutri_app/providers/providers.dart';
import 'package:nutri_app/screens/screens.dart';
import 'package:nutri_app/widgets/widgets.dart';
import 'package:provider/provider.dart';



class GeoScreen extends StatelessWidget {


  const GeoScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final locationProvider = Provider.of<LocationProvider>(context);
    locationProvider.getCurrPosition();
    
    if (locationProvider.lastKnowLocation!.latitude == 0.0 && locationProvider.lastKnowLocation!.longitude == 0.0) return const LoadingScreen();

    
    final Set<Marker> markers = locationProvider.misMarkers;

    //locationProvider.drawMarker();

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
                  markers: markers,
                  onMapCreated: (controller) { 
                    locationProvider.onInitMap(controller);
                  },
                  onCameraMove: ( position ) => locationProvider.centerMap = position.target
                ),
              ),
              locationProvider.displayManualMarker
              ? const SizedBox()
              : FadeInDown(
                child: SafeArea(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      height: 50,
                      width:  MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: (){
                          showSearch(context: context, delegate: NinioGeoSearchDelegate());
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width *0.9,
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                          decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: const[
                            BoxShadow(color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 5))
                          ] 
                        ),
                          child: const Text('Buscar Niños', style: TextStyle(color: Colors.black87),),
                        ),
                      ),
                    ),
                ),
              ),

              const ManualMarker()
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