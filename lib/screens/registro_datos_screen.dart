import 'package:flutter/material.dart';
import 'package:nutri_app/screens/screens.dart';
import 'package:nutri_app/services/services.dart';
import 'package:nutri_app/widgets/ninio_card.dart';
import 'package:provider/provider.dart';

import '../models/ninios.dart';


class RegistroDatosScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context);

    //ninioService.loadninios();

    if(ninioService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Niños Registrados'),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          await Future.delayed(const Duration(milliseconds: 1000));
          ninioService.ninios.clear();
          ninioService.loadninios();
        },
        child: ListView.builder(
          
          itemCount: ninioService.ninios.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'ninio');
              ninioService.selectedninio = ninioService.ninios[index].copy();
              ninioService.exists =true;
            },
            child: NinioCard(ninio: ninioService.ninios[index] ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          ninioService.selectedninio = Ninio(
            cui: '',
            id: '',
            nombres: '',
            fechaNacimiento: '',
            apellidos: '',
            genero: '',
            tutor: Tutor(cui: '', direccion: '', nombre: '', telefono: '')
          );
          
          Navigator.pushNamed(context, 'ninio');
          ninioService.exists =false;

        },
        child: const Icon(Icons.add),
      ),
   );
   
  }
}