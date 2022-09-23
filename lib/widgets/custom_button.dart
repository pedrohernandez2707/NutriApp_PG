import 'package:flutter/material.dart';



class CustomButton extends StatelessWidget {

  final Color color;
  final double buttonWith;
  final double buttonHeight;
  final String texto;
  final void Function()? onPress;
  final Color textColor;
  final double fontSize;

  const CustomButton({ 
    Key? key, 
    required this.color, 
    required this.buttonWith, 
    required this.buttonHeight,
    required this.onPress, 
    required this.texto, 
    required this.textColor, 
    required this.fontSize }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    MaterialButton(
      onPressed: onPress,
      color: color,
      shape: const StadiumBorder(),
      child: SizedBox(
        width: buttonWith,
        height: buttonHeight,
        child: Center(
          child: Text(texto,style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: fontSize),),
        )
      ),
  );
  }
}