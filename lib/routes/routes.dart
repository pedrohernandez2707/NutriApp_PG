import 'package:flutter/material.dart';
import 'package:nutri_app/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'login':           ( _ ) => LoginScreen(),
  'main':            ( _ ) => const MainScreen(),
  'gestion_usuario': ( _ ) => GestionUsuariosScreen(),
  'geo':             ( _ ) => GeoScreen(),
  'permission':      ( _ ) => GeoPermissionScreen(),
  'registro':        ( _ ) => RegistroScreen(),
  'visualizacion':   ( _ ) => VisualizacionSearchScreen(),
  'loading':         ( _ ) => LoadingScreen(),
  'terminos':        ( _ ) => TerminosScreen(),
  'registro_datos':  ( _ ) => RegistroDatosScreen(),
  'ninio':           ( _ ) => NinioScreen(),
  'tabla':           ( _ ) => TablaMedicionesScreen(),
  'medicion':        ( _ ) => MedicionScreen()
};