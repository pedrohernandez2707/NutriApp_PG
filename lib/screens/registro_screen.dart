import 'package:flutter/material.dart';
import 'package:nutri_app/services/services.dart';
import 'package:nutri_app/widgets/widgets.dart';
import 'package:provider/provider.dart';


class RegistroScreen extends StatelessWidget {
  
  const RegistroScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final usuarioService = Provider.of<UsuarioService>(context,listen: false);

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
        
                  const Logo(title: 'Registro de Usuarios'),
        
                  usuarioService.selectedUsuario.email == ''
                  ? _Form()
                  : const SizedBox(height: 0),

                  const SizedBox(height: 10),
        
                  Switch(
                    switchUsuario: usuarioService.selectedUsuario.permisos.usuarios,
                    switchRegistro: usuarioService.selectedUsuario.permisos.registro,
                    switchVisualizacion: usuarioService.selectedUsuario.permisos.visualizacion,
                    switchGeo: usuarioService.selectedUsuario.permisos.geolocalizacion
                  ),

                  const SizedBox(height: 15),

                  CustomButton(
                    buttonHeight: 55 ,
                    buttonWith: 200,
                    texto: 'Guardar',
                    color: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 18,
                    onPress: (){
                      //print(emailCtrl.text);
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


    return SingleChildScrollView(
      child: Column(children: [
    
        SwitchListTile(
          title: Text('Usuarios'),
          value: _switchUsuario, 
          onChanged: (bool value){
            setState(() {
              _switchUsuario= value;
            });
            print('Usuarios: $value');
          }
        ),
    
        SwitchListTile(
          title: Text('Registro'),
          value: _switchRegistro,
          onChanged: (value){
            setState(() {
              _switchRegistro = value;
            });
            print('Registro: $value');
          }
        ),
    
        SwitchListTile(
          title: Text('Visualizacion'),
          value: _switchVisualizacion, 
          onChanged: (value){
            setState(() {
              _switchVisualizacion = value;
            });
            print('Visualizacion: $value');
          }
        ),
    
        SwitchListTile(
          title: Text('Geolocalizacion'),
          value: _switchGeo,
          onChanged: (value){
            setState(() {
              _switchGeo = value;
            });
            print('Geolocalizacion: $value');
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
              } else {
                return null;
              }
            },
            onChanged: (value){},
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
            onChanged: (value){},
            icon: Icons.email_outlined,
            placeholder: 'Correo Electronico',
            isPassword: false,
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),

          CustomInput(
            initialValue: usuarioService.selectedUsuario.password,
            validator: (value){
              String pattern = r'/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])([A-Za-z\d$@$!%*?&]|[^ ]){8,15}$/';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                ? null
                : 'La contraseña no cumple los requisitos minimos';
            },
            onChanged: (value){},
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: true,
            textController: passCtrl,
            keyboardType: TextInputType.text,
          ),

        ],
      ),
    );
  }
}
