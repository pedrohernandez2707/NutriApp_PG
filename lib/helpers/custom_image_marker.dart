import 'package:flutter/material.dart';
//import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart' show BitmapDescriptor;

Future<BitmapDescriptor> getassetImage() async{
  

  return BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(
      devicePixelRatio: 2.5,
    ), 
    'assets/marker1.png'
  );

  

}