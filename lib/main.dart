import 'package:flutter/material.dart';
import 'package:nutri_app/providers/providers.dart';
import 'package:nutri_app/routes/routes.dart';
import 'package:nutri_app/services/services.dart';
import 'package:provider/provider.dart';


void main() => runApp(const AppState());


class AppState extends StatelessWidget {

  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
        ChangeNotifierProvider(create: (_) => NiniosService()),
        ChangeNotifierProvider(create: (_) => GpsProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => UsuarioService()),
        ChangeNotifierProvider(create: (_) => MedicionesService()),
      ],
      child: const MyApp(),
      
    );
  }
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Nutri App',
      initialRoute: 'main',
      routes: appRoutes
    );
  }
}