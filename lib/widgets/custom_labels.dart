import 'package:flutter/material.dart';


class Labels extends StatelessWidget {
  const Labels({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, 'terminos');
          },
          child: const Text('Terminos y Condiciones',
          style: TextStyle(color: Colors.blue, fontSize: 17,fontWeight: FontWeight.bold)
      ),
        ),
        const SizedBox(height: 10,),

        const Text('UMG 2022',
            style: TextStyle(color: Colors.black54, fontSize: 15,fontWeight: FontWeight.bold)
        ),

      ],
      
    );
  }
}