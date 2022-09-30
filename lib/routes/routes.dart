import 'package:flutter/material.dart';
import 'package:nutri_app/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'login':           ( _ ) => const LoginScreen(),
  'main':            ( _ ) => const MainScreen(),
  'gestion_usuario': ( _ ) => const GestionUsuariosScreen(),
  'geo':             ( _ ) => const GeoScreen(),
  'permission':      ( _ ) => const GeoPermissionScreen(),
  'registro':        ( _ ) => const RegistroScreen(),
  'visualizacion':   ( _ ) => VisualizacionSearchScreen(),
  'loading':         ( _ ) => const LoadingScreen(),
  'terminos':        ( _ ) => TerminosScreen(),
  'registro_datos':  ( _ ) => RegistroDatosScreen(),
  'ninio':           ( _ ) => NinioScreen(),
  'tabla':           ( _ ) => const TablaMedicionesScreen(),
  'medicion':        ( _ ) => const MedicionScreen()
};