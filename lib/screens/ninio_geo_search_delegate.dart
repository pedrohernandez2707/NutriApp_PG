import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/providers/location_provider.dart';
import 'package:nutri_app/services/services.dart';
import 'package:provider/provider.dart';

import '../models/ninios.dart';



class NinioGeoSearchDelegate extends SearchDelegate{

  @override
  
  String? get searchFieldLabel => 'Buscar Niños';

  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query ='';
        }, 
        icon: const Icon(FontAwesomeIcons.xmark)
      )
    ];
    
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          close(context, null);
        }, 
        icon: const Icon(Icons.arrow_back)
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return Center(
        child: Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.blue.withOpacity(0.5),size: 100,),
      );
    }

    final ninioService = Provider.of<NiniosService>(context, listen: false);
    ninioService.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: ninioService.suggestionStream,
      builder: (_, AsyncSnapshot<List<Ninio>> snapshot){
        if(!snapshot.hasData) {
          return Center(
          child: Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.blue.withOpacity(0.5),size: 100,),
          );
      }

        final ninios = snapshot.data;

        return ListView.builder(
          itemCount: ninios!.length,
          itemBuilder: (_,int index){
            return _SearchCard(ninio: ninios[index],);
            
          }
        );

      }
      );
  }

}


class _SearchCard extends StatelessWidget {

  final Ninio ninio;

  const _SearchCard({
    Key? key, 
    required this.ninio 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context,listen: false);
    final locationProvider = Provider.of<LocationProvider>(context);
    
    return ListTile(
      leading: ninio.genero == 'Femenino' ? const Icon(FontAwesomeIcons.childDress,color: Colors.pink,size: 30,) : const Icon(FontAwesomeIcons.child, color: Colors.blue,size: 30,),
      title: Text('${ninio.nombres} ${ninio.apellidos}'),
      subtitle: Text(ninio.fechaNacimiento),
      onTap: (){
        ninioService.selectedninio = ninio;
        locationProvider.displayManualMarker = true;
        Navigator.pop(context);
      },
    );
  }
}