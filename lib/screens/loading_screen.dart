import 'package:flutter/material.dart';


class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Niños'),
      ),
      body: const Center(
        
        child: CircularProgressIndicator(
          color: Colors.amber,
        )
      ),
      
    );
  }
}