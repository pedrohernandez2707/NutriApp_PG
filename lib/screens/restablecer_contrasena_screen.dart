import 'package:flutter/material.dart';
import 'package:nutri_app/services/auth_service.dart';
import 'package:nutri_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class RestablecerContrasenaScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

     final loginForm = Provider.of<LoginFormProvider>(context);
       
      return Scaffold(
        appBar: AppBar(),
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(title: 'Restablecer Contraseña',),
                Form(
                  key: loginForm.resetFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: _Form(),
                ),
                //SizedBox(height: -10,),
                const SizedBox(
                  height: 70,
                  child: Image(image: AssetImage('assets/logoUMG.png'))
                ),
              ],
            ),
          ),
        ),
      )
   );
  }
}



class _Form extends StatefulWidget {

  //const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();

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

               loginForm.emailReset = value;
               
            },
            icon: Icons.email_outlined,
            placeholder: 'Correo Electronico',
            isPassword: false,
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),     

          const SizedBox(height: 20,),
            
          CustomButton(
            buttonHeight: 55 ,
            buttonWith: 200,
            texto: 'Restablecer',
            color: Colors.blue,
            textColor: Colors.white,
            fontSize: 18,
            onPress: loginForm.isLoading? null : () async{

              FocusScope.of(context).unfocus();

              if(!loginForm.isValidResetForm()) return;

              loginForm.isLoading = true;
              final authProvider = Provider.of<AuthService>(context,listen: false);

              String respLogin = await authProvider.resetUser(loginForm.emailReset);
              
              if (respLogin == '') {
                
                loginForm.isLoading = false;

                showDialog(
                  context: context, 
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirmacion',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                    content: const Text('Se envio un correo electronico para restablecer su contraseña'),
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
                
              } else{
                String msg;
                switch (respLogin) {
                  case 'EMAIL_NOT_FOUND':
                    msg = 'La cuenta no existe, verifique su direccion de correo electronico';
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
                  loginForm.isLoading = false;
              }
            },
            ),
        ],
      ),
    );
  }
}
