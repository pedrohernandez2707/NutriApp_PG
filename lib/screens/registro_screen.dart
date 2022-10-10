import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/services/services.dart';
import 'package:nutri_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';


class RegistroScreen extends StatelessWidget {
  
  const RegistroScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final usuarioService = Provider.of<UsuarioService>(context,listen: false);
    // ignore: unused_local_variable
    final loginForm = Provider.of<LoginFormProvider>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Permisos'),
      ),
      backgroundColor: const Color(0xffF2F2F2),
      body: 
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              //height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  usuarioService.selectedUsuario.email == ''
                  ?  const Logo(title: 'Registro de Usuarios')
                  :  const Logo(title: 'Permisos Por Usuario'),

                  const SizedBox(height: 30,),
        
                  usuarioService.selectedUsuario.email == ''
                  ? Form(
                    key: usuarioService.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: const _Form()
                  )
                  : const SizedBox(height: 0),

                  const SizedBox(height: 10),
        
                  Switch(
                    switchUsuario: usuarioService.selectedUsuario.permisos.usuarios,
                    switchRegistro: usuarioService.selectedUsuario.permisos.registro,
                    switchVisualizacion: usuarioService.selectedUsuario.permisos.visualizacion,
                    switchGeo: usuarioService.selectedUsuario.permisos.geolocalizacion
                  ),

                  const SizedBox(height: 30),

                  CustomButton(
                    buttonHeight: 55 ,
                    buttonWith: 200,
                    texto: 'Guardar',
                    color: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 18,
                    onPress: ()async{
                      
                      FocusScope.of(context).unfocus();
                      try {
                        await usuarioService.saveOrCreateUsuario(usuarioService.selectedUsuario);
                        await authService.createUser(usuarioService.selectedUsuario.email, usuarioService.selectedUsuario.password);
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Proceso Exitoso',style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                            content: const Text('Registro Guardado Correctamente!'),
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
                            title: const Text('Error al Guardar',style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
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
                  //Labels(),
                ],
              ),
            ),
          ),
   );
  }
}

// ignore: must_be_immutable
class Switch extends StatefulWidget {

  bool switchUsuario;
  bool switchRegistro;
  bool switchVisualizacion;
  bool switchGeo;

  Switch({super.key, 
  required this.switchUsuario, 
  required this.switchRegistro, 
  required this.switchGeo, 
  required this.switchVisualizacion});

  @override
  // ignore: no_logic_in_create_state
  State<Switch> createState() => _SwitchState(
    switchUsuario,
    switchRegistro,
    switchGeo,
    switchVisualizacion,
  );
}

class _SwitchState extends State<Switch> {
  bool _switchUsuario;
  bool _switchRegistro;
  bool _switchVisualizacion;
  bool _switchGeo;

  _SwitchState(this._switchUsuario, this._switchRegistro, this._switchGeo, this._switchVisualizacion);

  @override
  Widget build(BuildContext context) {

    final usuarioService = Provider.of<UsuarioService>(context,listen: false);
    const TextStyle text = TextStyle(fontSize: 19, fontWeight: FontWeight.w600);
    const Color color = Colors.black;

    return SingleChildScrollView(
      child: Column(children: [
    
        SwitchListTile(
          title: Row(children: const[
            Icon(FontAwesomeIcons.userLarge, color: color,),
            SizedBox(width: 15),
            Text('Usuarios',style: text,), 
            ],),
          //subtitle: Icon(FontAwesomeIcons.userLarge),
          value: _switchUsuario, 
          onChanged: (bool value){
            setState(() {
              _switchUsuario= value;
            });
            usuarioService.selectedUsuario.permisos.usuarios = value;
            //print('Usuarios: ${usuarioService.selectedUsuario.permisos.usuarios}');
          }
        ),
    
        SwitchListTile(
          title: Row(
            children: const[
              Icon(FontAwesomeIcons.pencil, color: color,),
              SizedBox(width: 15),
              Text('Registro',style: text,),
            ],
          ),
          
          value: _switchRegistro,
          onChanged: (value){
            setState(() {
              _switchRegistro = value;
            });
            usuarioService.selectedUsuario.permisos.registro = value;
            //print('Registro: ${usuarioService.selectedUsuario.permisos.registro}');
          }
        ),
    
        SwitchListTile(
          title: Row(
            children: const[
              Icon(FontAwesomeIcons.eye, color: color,),
              SizedBox(width: 15,),
              Text('Visualizacion',style: text,),         
            ],
          ),
          
          value: _switchVisualizacion, 
          onChanged: (value){
            setState(() {
              _switchVisualizacion = value;
            });
            usuarioService.selectedUsuario.permisos.visualizacion = value;
            //print('Visualizacion: ${usuarioService.selectedUsuario.permisos.visualizacion}');
          }
        ),
    
        SwitchListTile(
          title: Row(
            children: const[
              Icon(FontAwesomeIcons.locationDot, color: color,),
              SizedBox(width: 15,),
              Text('Geolocalizacion', style: text,), 
            ],
          ),
          value: _switchGeo,
          onChanged: (value){
            setState(() {
              _switchGeo = value;
            });
            usuarioService.selectedUsuario.permisos.geolocalizacion = value;
            //print('Geolocalizacion: ${usuarioService.selectedUsuario.permisos.geolocalizacion}');
          }
        ),
      ],),
    );
  }
}



class _Form extends StatefulWidget {

  const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final usuarioService = Provider.of<UsuarioService>(context,listen: false);

    return Container(

      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 25),

      child: Column(
        children: [

          CustomInput(
            initialValue: usuarioService.selectedUsuario.nombre,
            validator: (value){
              if (value == null || value == '') {
                return 'El nombre es Obligatorio';
              }
            },
            onChanged: (value){
              usuarioService.selectedUsuario.nombre = value;
            },
            icon: Icons.person,
            placeholder: 'Nombres y Apellidos',
            isPassword: false,
            textController: nameCtrl,
            keyboardType: TextInputType.text,
          ),

          CustomInput(
            initialValue: usuarioService.selectedUsuario.email,
            validator: (value){
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                ? null
                : 'Ingrese un correo valido';
            },
            onChanged: (value){
              usuarioService.selectedUsuario.email = value;
            },
            icon: Icons.email_outlined,
            placeholder: 'Correo Electronico',
            isPassword: false,
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),

          CustomInput(
            initialValue: usuarioService.selectedUsuario.password,
            validator: (value){
              String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                ? ''
                : 'La contraseña no cumple los requisitos minimos';
            },
            onChanged: (value){
              usuarioService.selectedUsuario.password = value;
            },
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: false,
            textController: passCtrl,
            keyboardType: TextInputType.text,
          ),

        ],
      ),
    );
  }
}
