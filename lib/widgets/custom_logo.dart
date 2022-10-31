import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

 final String title;
  
  const Logo({ Key? key, required this.title }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(

      child: Container(

        padding: const EdgeInsets.only(top: 40),
        width: 300,

        child: Column(

          children: [

            const Image(image: AssetImage('assets/APRODIGUA.jpg')),

            const SizedBox(height: 20,),

            Text(title, style: const TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),)
  
          ],
        ),

        
      ),
    );
  }
}
