import 'package:flutter/material.dart';
import 'package:nutri_app/widgets/widgets.dart';


class RegistroScreen extends StatelessWidget {
  
  const RegistroScreen({super.key});


  @override
  Widget build(BuildContext context) {
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
              children: const[

                Logo(title: 'Registro de Usuarios'),

                _Form(),

                Labels(),

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
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 25),

      child: Column(
        children: [

          CustomInput(
            validator: (value){return'';},
            onChanged: (value){},
            icon: Icons.person,
            placeholder: 'Nombres y Apellidos',
            isPassword: false,
            textController: nameCtrl,
            keyboardType: TextInputType.text,
          ),

          CustomInput(
            validator: (value){return'';},
            onChanged: (value){},
            icon: Icons.email_outlined,
            placeholder: 'Correo Electronico',
            isPassword: false,
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),

          CustomInput(
            validator: (value){return'';},
            onChanged: (value){},
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: true,
            textController: passCtrl,
            keyboardType: TextInputType.text,
          ),
            
          CustomButton(
            buttonHeight: 55 ,
            buttonWith: 200,
            texto: 'Crear Cuenta',
            color: Colors.blue,
            textColor: Colors.white,
            fontSize: 18,
            onPress: (){
              //print(emailCtrl.text);
            },
            )
          
        ],
      ),
    );
  }
}
