import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/providers/providers.dart';
import 'package:nutri_app/services/mediciones_service.dart';
import 'package:nutri_app/services/ninios_service.dart';
import 'package:provider/provider.dart';
import '../ui/ui.dart';



class MedicionScreen extends StatelessWidget {

  const MedicionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context, listen: false);
    final medicionService = Provider.of<MedicionesService>(context);

    return ChangeNotifierProvider(
      create: (_) => MedicionFormProvider(medicionService.selectedMedicion),
      child: MedicionScreenBody(medicionesService: medicionService, niniosService: ninioService,),
    );
  }
}


class MedicionScreenBody extends StatelessWidget {
  const MedicionScreenBody({
    Key? key, 
    required this.medicionesService,
    required this.niniosService}) : super(key: key);

  final MedicionesService medicionesService;
  final NiniosService niniosService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(niniosService.selectedninio.nombres),
        backgroundColor: niniosService.selectedninio.genero == 'Femenino'
        ? Colors.pink[300]
        : Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 15,),

            const Center(child: Text('Medicion',
            style: TextStyle(color: Colors.black,fontSize: 22, fontWeight: FontWeight.bold))
            ),

            const SizedBox(height: 30,),

            _MedicionForm()

          ]) ,
        ),
     floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
     floatingActionButton: FloatingActionButton(
      backgroundColor: niniosService.selectedninio.genero == 'Femenino'
        ? Colors.pink[300]
        : Colors.blue,
      child: const Icon(Icons.save),
      onPressed: ()async{

        FocusScope.of(context).unfocus();

        try {

          medicionesService.llenarTallas();
          medicionesService.llenarPesos();

          medicionesService.selectedMedicion.edadMeses = calcularEdadMeses(niniosService.selectedninio.fechaNacimiento, medicionesService.selectedMedicion.fechaMedicion);

          final msgTalla = medicionesService.buscarTalla(medicionesService.selectedMedicion.edadMeses , niniosService.selectedninio.genero, medicionesService.selectedMedicion.tallaCm);
          
          medicionesService.medicionNotasTalla = msgTalla;

          final msgPeso = medicionesService.buscarPeso(medicionesService.selectedMedicion.edadMeses , niniosService.selectedninio.genero, medicionesService.selectedMedicion.pesoKg);
          medicionesService.medicionNotasPeso = msgPeso;
          
          await medicionesService.saveOrCreateMedicion(medicionesService.selectedMedicion);

          showDialog(
              context: context, 
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Registro Guardado Correctamente!',style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                content: Text('Peso: ${medicionesService.selectedMedicion.notasPeso} \n\nTalla: ${medicionesService.selectedMedicion.notasTalla}'),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
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
        }
      },
    ),
   );
  }


  int calcularEdadMeses(String fechaNacimiento, String fechaMedicion) {

    final birthday = DateTime.parse(fechaNacimiento);
    final date2 = DateTime.parse(fechaMedicion);
    
    final difference = date2.difference(birthday).inDays;
    
    final meses = difference/30;

    return meses.toInt();
  }

}


class _MedicionForm extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context);
    final medicionService = Provider.of<MedicionesService>(context);

    final medicionFormProvider = Provider.of<MedicionFormProvider>(context);
    final medicion = medicionFormProvider.medicion;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: const BoxDecoration(
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
            key: medicionFormProvider.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const SizedBox(height: 10),
                //Form CUI
                TextFormField(
                  initialValue: medicion.cuiNinio,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: '',
                    labelText: 'CUI',
                    prefixIcon: FontAwesomeIcons.idCard
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => medicion.cuiNinio = value,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El CUI es obligatorio';
                    }
                  },
                  enabled: false,
                ),

                const SizedBox(height: 30,),

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
                      medicionService.fecha(newDate);
                      //ninio.fechaNacimiento = newDate.toString();
                    },
                    icon: const Icon(Icons.date_range,size: 30,color: Colors.indigo,),
                  ),

                  Column(
                    children: [
                      const Text('Fecha de Medicion',style: TextStyle(color: Colors.grey,fontSize: 12),textAlign: TextAlign.left,),

                      Container(
                        padding: const EdgeInsets.only(left: 10,top: 5),
                        //color: Colors.black.withOpacity(0.1),
                        child: Text(medicionService.selectedMedicion.fechaMedicion, style: const TextStyle(color: Colors.black,fontSize: 18),),
                      ),
                    ],
                  ),
              ],
              ),

               const SizedBox(height: 30,),

                //Form Nombre
                TextFormField(
                  initialValue: medicionService.selectedMedicion.pesoKg.toString(),
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Peso',
                    labelText: 'Peso en Kg',
                    prefixIcon: Icons.line_weight
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                  if(double.tryParse(value) == null){
                  medicion.pesoKg = 0;
                  } else {
                    medicion.pesoKg = double.parse(value);
                  }
                  },
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El campo es obligatorio';
                    }
                  }
                ),

                const SizedBox(height: 30,),

                //Form Apellios
                TextFormField(
                  initialValue: medicionService.selectedMedicion.tallaCm.toString(),
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Talla en Cm',
                    labelText: 'Talla',
                    prefixIcon: Icons.height
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                  if(double.tryParse(value) == null){
                  medicion.tallaCm = 0;
                  } else {
                    medicion.tallaCm = double.parse(value);
                  }
                  },
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'El campo es obligatorio';
                    }
                  }
                ),
            
                const SizedBox(height: 30,),

                TextFormField(
                  initialValue: medicionService.selectedMedicion.notasPeso,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Notas Peso', 
                    labelText: 'Notas Peso', 
                    prefixIcon: FontAwesomeIcons.noteSticky),
                    keyboardType: TextInputType.text,
                    maxLines: 10,
                    minLines: 1,
                    onChanged: (value) => medicion.notasPeso = value,
                ),

                const SizedBox(height: 30,),

                TextFormField(
                  initialValue: medicionService.selectedMedicion.notasTalla,
                  decoration: InputDecorations.authInputdecoration(
                    hintText: 'Notas Talla', 
                    labelText: 'Notas Talla', 
                    prefixIcon: FontAwesomeIcons.noteSticky
                  ),
                  onChanged: (value) => medicion.notasTalla = value,
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                  minLines: 1,
                ),
                const SizedBox(height: 30,)
              ],
            )
          ),
        ),
      ),
    );
  }
}