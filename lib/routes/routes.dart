import 'package:flutter/material.dart';
import 'package:nutri_app/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'login':           ( _ ) => const LoginScreen(),
  'main':            ( _ ) => const MainScreen(),
  'gestion_usuario': ( _ ) => const GestionUsuariosScreen(),
  'geo':             ( _ ) => const GeoScreen(),
  'permission':      ( _ ) => const GeoPermissionScreen(),
  'registro':        ( _ ) => const RegistroScreen(),
  'visualizacion':   ( _ ) => const VisualizacionSearchScreen(),
  'loading':         ( _ ) => const LoadingScreen(),
  'terminos':        ( _ ) => const TerminosScreen(),
  'registro_datos':  ( _ ) => const RegistroDatosScreen(),
  'ninio':           ( _ ) => const NinioScreen(),
  'tabla':           ( _ ) => const TablaMedicionesScreen(),
  'medicion':        ( _ ) => const MedicionScreen()
};