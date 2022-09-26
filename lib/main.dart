import 'package:flutter/material.dart';
import 'package:nutri_app/providers/gps_provider.dart';
import 'package:nutri_app/providers/login_form_provider.dart';
import 'package:nutri_app/providers/providers.dart';
import 'package:nutri_app/routes/routes.dart';
import 'package:nutri_app/services/services.dart';
import 'package:provider/provider.dart';


void main() => runApp(AppState());


class AppState extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
        ChangeNotifierProvider(create: (_) => NiniosService()),
        ChangeNotifierProvider(create: (_) => GpsProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MyApp(),
      
    );
  }
}

class MyApp extends StatelessWidget {
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