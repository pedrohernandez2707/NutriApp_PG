// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/providers/providers.dart';
import 'package:nutri_app/services/services.dart';
import 'package:provider/provider.dart';

import '../ui/input_decoration.dart';


class NinioScreen extends StatelessWidget {

  const NinioScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context);

    //DateTime date =DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

    //final midate = ninioService.selectedninio.fechaNacimiento == '' ? date : ninioService.selectedninio.fechaNacimiento;

    return ChangeNotifierProvider(
      create: (_) => NinioFormProvider(ninioService.selectedninio),
      child: _NiniosScreenBody(ninioService: ninioService),
    );
  }
}

class _NiniosScreenBody extends StatelessWidget {
  const _NiniosScreenBody({
    Key? key,
    required this.ninioService,
  }) : super(key: key);

  final NiniosService ninioService;

  @override
  Widget build(BuildContext context) {

    final ninioForm = Provider.of<NinioFormProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Mantenimiento de Niños'),
      // ),
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height:150,
                  child: Center(child: Icon(FontAwesomeIcons.children,size: 70,color: Colors.blue,),),
                  ),
                
                Positioned(
                  top: 40,
                  left: 20,
                  child:IconButton(onPressed: ()=> Navigator.of(context).pop(), 
                  icon:  Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.black)
                  )
                ),
            ],
          ),

          Center(child: Text('Datos del Niño',
          style: TextStyle(color: Colors.black,fontSize: 22, fontWeight: FontWeight.bold),),
          ),

          _NinioForm(),

          const SizedBox(height: 10),

          Center(child: Text('Datos del Tutor',
          style: TextStyle(color: Colors.black,fontSize: 22, fontWeight: FontWeight.bold),),
          ),

          _TutorForm()

          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        // ignore: sort_child_properties_last
        child: ninioService.isSaving
        ? CircularProgressIndicator(color: Colors.white,)
        : Icon(Icons.save_outlined),

        onPressed: ninioService.isSaving
        ? null
        : () async{

          if(!ninioForm.isValidForm()) return;
          
          try {
            await ninioService.saveOrCreateNinio(ninioForm.ninio);

            showDialog(
              context: context, 
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Proceso Exitoso',style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                content: Text('Registro Guardado Correctamente!'),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, 
                    child: const Text('OK')
                  )
                ],
              )
            );

          } catch (e) {
            showDialog(
              context: context, 
              builder: (BuildContext context) => AlertDialog(
                title: Text('Error al Grabar el Registro',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                content: Text(e.toString()),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, 
                    child: const Text('OK')
                  )
                ],
              )
            );
            ninioService.isSaving =false;
          }
        },
        ),
   );
  }
}

class _NinioForm extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context);

    final ninioFormProvider = Provider.of<NinioFormProvider>(context);
    final ninio = ninioFormProvider.ninio;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25)),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0,5),
                blurRadius: 10
              )
            ]
          ),
          child: Form(
            key: ninioFormProvider.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(height: 10),
                //Form CUI
                TextFormField(
                  initialValue: ninio.id,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Codigo',
                    labelText: 'CUI',
                    prefixIcon: FontAwesomeIcons.idCard
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => ninio.id = value,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El CUI es obligatorio!';
                    }
                  }
                ),

                SizedBox(height: 30,),

                //Form Nombre
                TextFormField(
                  initialValue: ninio.nombres,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Nombre del niño',
                    labelText: 'Nombres',
                    prefixIcon: Icons.abc
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) => ninio.nombres = value,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El campo es obligatorio';
                    }
                  }
                ),

                SizedBox(height: 30,),

                //Form Apellios
                TextFormField(
                  initialValue: ninio.apellidos,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Apellidos del niño',
                    labelText: 'Apellidos',
                    prefixIcon: Icons.abc
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) => ninio.apellidos = value,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El campo es obligatorio';
                    }
                  }
                ),

                SizedBox(height: 30,),
                
                //Form Date
              //   TextFormField(
              //   initialValue: ninioService.selectedninio.fechaNacimiento,
              //   // inputFormatters: [
              //   //   FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              //   // ],
              //   keyboardType: TextInputType.text,
              //    decoration: InputDecorations.authInputdecoration(
              //      hintText: 'dd/mm/YY',
              //      labelText: 'Fecha de Nacimiento',
              //      prefixIcon: Icons.date_range
              //    ),
              //   onChanged: (value) {
                  
              //     ninio.fechaNacimiento = value;
              //   },
              //   validator: (value) {
              //     if(value == null || value.isEmpty){
              //       return 'El campo es Obligatorio';
              //     }
              //   }
              // ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async{
                      DateTime? newDate = await showDatePicker(
                        context: context, 
                        initialDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
                        firstDate: DateTime(2000), 
                        lastDate: DateTime(2100), 
                      );

                      if(newDate == null) return;
                      ninioService.fecha(newDate);
                      ninio.fechaNacimiento = newDate.toString();
                    },
                    icon: Icon(Icons.date_range,size: 30,color: Colors.indigo,),
                  ),

                  Column(
                    children: [
                      // ignore: avoid_unnecessary_containers
                      Container(        
                        //color: Colors.black.withOpacity(0.1),
                        child: Text('Fecha de Nacimiento',style: TextStyle(color: Colors.grey,fontSize: 12),textAlign: TextAlign.left,)
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 10,top: 5),
                        //color: Colors.black.withOpacity(0.1),
                        child: Text(ninioService.selectedninio.fechaNacimiento,style: TextStyle(color: Colors.black,fontSize: 18),),
                      ),
                    ],
                  ),
              ],
              ),

                SizedBox(height: 30),

                DropdownButtonFormField<String>(
                  //icon: Icon(FontAwesomeIcons.genderless),
                  iconSize: 40,
                  hint: Text('Seleccione el Genero'),
                  value: ninio.genero =='' ?'Femenino' :ninio.genero,
                  items: const[
                    DropdownMenuItem(
                      value: 'Femenino',
                      child: Text('Femenino'),
                    ),
                    DropdownMenuItem(
                      value: 'Masculino',
                      child: Text('Masculino'),
                    )
                  ], 
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'El campo es obligatorio';
                    }
                    
                  },
                  onChanged: (value){
                    ninio.genero = value!;
                  },
                ),

                SizedBox(height: 30,)
              ],
            )
            ),
        ),
      ),
    );
  }
}


class _TutorForm extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context);

    final ninioFormProvider = Provider.of<NinioFormProvider>(context);
    final ninio = ninioFormProvider.ninio;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25)),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0,5),
                blurRadius: 10
              )
            ]
          ),
          child: Form(
            //key: ninioFormProvider.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(height: 10),
                //Form CUI
                TextFormField(
                  initialValue: ninio.tutor.cui,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Codigo',
                    labelText: 'CUI',
                    prefixIcon: FontAwesomeIcons.idCard
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => ninio.tutor.cui = value,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El CUI es obligatorio!';
                    } else if(value.length < 13){
                      return 'El CUI debe ser de 13 digitos';
                    }
                  }
                ),

                SizedBox(height: 30,),

                //Form Nombre
                TextFormField(
                  initialValue: ninio.tutor.nombre,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Nombre del Tutor',
                    labelText: 'Nombres',
                    prefixIcon: Icons.abc
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) => ninio.tutor.nombre = value,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El campo es obligatorio';
                    }
                  }
                ),

                SizedBox(height: 30,),

                //Form Apellios
                TextFormField(
                  initialValue: ninio.tutor.direccion,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Direccion de Tutor',
                    labelText: 'Direccion',
                    prefixIcon: Icons.abc
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) => ninio.tutor.direccion = value,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El campo es obligatorio';
                    }
                  }
                ),

                SizedBox(height: 30),

                TextFormField(
                  initialValue: ninio.tutor.telefono,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Numero de Telefono',
                    labelText: 'Telefono',
                    prefixIcon: Icons.phone_callback_outlined
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => ninio.tutor.telefono = value,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El campo es obligatorio';
                    }
                  }
                ),

                SizedBox(height: 50),
              ],
            )
            ),
        ),
      ),
    );
  }
}