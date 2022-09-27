import 'package:flutter/material.dart';


class CustomInput extends StatelessWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?) validator;
  final void Function(String) onChanged;
  final String? initialValue;

  const CustomInput({ 
    Key? key, 
    required this.icon, 
    required this.placeholder, 
    required this.textController, 
    required this.keyboardType, 
    required this.isPassword, 
    required this.validator, 
    required this.onChanged, 
    this.initialValue }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.only(top: 5,left: 5,right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(0, 5),
                blurRadius: 5
              )
            ]
          ),

          child: TextFormField(
            style: const TextStyle(fontSize: 18),
            obscureText: isPassword,
            controller: textController,
            autocorrect: false,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              //contentPadding: EdgeInsets.only(left: 10),
              prefixIcon: Icon(icon),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: placeholder,
            ),
            onChanged: onChanged,
            validator: validator,
          ),
        );

  }
}