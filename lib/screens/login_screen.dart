import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/services/auth_service.dart';
import 'package:nutri_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

     final loginForm = Provider.of<LoginFormProvider>(context);
       
      return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(title: 'Inicio de Sesión',),
                const Icon(FontAwesomeIcons.children, color: Colors.blue, size: 60,),
                Form(
                  key: loginForm.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: const _Form(),
                ),
                //SizedBox(height: -10,),
                const SizedBox(
                  height: 70,
                  child: Image(image: AssetImage('assets/logoUMG.png'))
                ),
            
                const Labels()
              ],
            ),
          ),
        ),
      )
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

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(

      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 25),

      child: Column(
        children: [
          
          CustomInput(
            validator: (value){

              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                ? null
                :'Ingrese un correo valido';
            },
            onChanged: (value) {

               loginForm.email = value;
               //print(loginForm.email);
            },
            icon: Icons.email_outlined,
            placeholder: 'Correo Electronico',
            isPassword: false,
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 10,),

          CustomInput(
            validator: (value){

              if (value != null && value.length >= 8) {
                return null;
              } else {
                return 'La contraseña debe ser mas larga';
              }
            },
            onChanged: (value) {  
              loginForm.password = value;
              //print(loginForm.password);
            },
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: true,
            textController: passCtrl,
            keyboardType: TextInputType.text,
          ),

          const SizedBox(height: 20,),
            
          CustomButton(
            buttonHeight: 55 ,
            buttonWith: 200,
            texto: 'Ingresar',
            color: Colors.blue,
            textColor: Colors.white,
            fontSize: 18,
            onPress: loginForm.isLoading? null : () async{

              FocusScope.of(context).unfocus();

              if(!loginForm.isValidForm()) return;

              loginForm.isLoading = true;
              final authProvider = Provider.of<AuthService>(context,listen: false);

              String? respLogin = await authProvider.loginUser(loginForm.email, loginForm.password);
              
              if (respLogin == null) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, 'main');
                loginForm.isLoading = false;
                
              } else{
                String msg;
                switch (respLogin) {
                  case 'EMAIL_NOT_FOUND':
                    msg = 'La cuenta no existe, verifique su direccion de correo';
                    break;

                  case 'INVALID_PASSWORD':
                    msg = 'La contraseña no incorrecta';
                    break;

                    case 'TOO_MANY_ATTEMPTS_TRY_LATER : Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.':
                    msg = 'Demasiados Intentos, la cuenta ha sido deshabilitada temporalmente, verifique sus credenciales';
                    break;

                  default:
                    msg = respLogin;
                    break;
                }

                showDialog(
                    context: context, 
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Error al Iniciar Sesion',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      content: Text(msg),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, 
                          child: const Text('OK')
                        )
                      ],
                    )
                  );
                  loginForm.isLoading =false;
              }

              
            },
            )
          
        ],
      ),
    );
  }
}
