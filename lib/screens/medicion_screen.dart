import 'package:flutter/material.dart';
import 'package:nutri_app/services/ninios_service.dart';
import 'package:provider/provider.dart';


class MedicionScreen extends StatelessWidget {


  const MedicionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar Medicion'),
      ),
      body: Center(
        child: Text(ninioService.selectedninio.nombres),
     ),
     floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
     floatingActionButton: IconButton(
      icon: const Icon(Icons.save),
      onPressed: (){

      },
    ),
   );
  }
}