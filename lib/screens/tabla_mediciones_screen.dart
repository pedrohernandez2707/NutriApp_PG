import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/models/models.dart';
import 'package:nutri_app/screens/screens.dart';

import 'package:nutri_app/services/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class TablaMedicionesScreen extends StatelessWidget {

  //List<Medicion> mediciones = <Medicion>[];

  
  const TablaMedicionesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context, listen: false);
    final medicionService = Provider.of<MedicionesService>(context);
    //medicionService.loadMediciones(ninioService.selectedninio.cui);

    final Color? color; 
    color = ninioService.selectedninio.genero == 'Femenino' 
    ? Colors.pink[300]
    : Colors.blue;

    const TextStyle style = TextStyle(color: Colors.white);

    late MedicionDataSource medicionDataSource;

    if(medicionService.isLoading) return const LoadingScreen();

    medicionDataSource = MedicionDataSource(medicionData: medicionService.medicionesLita);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(ninioService.selectedninio.nombres),
      ),
        body: 
          SfDataGrid(
            horizontalScrollPhysics: const BouncingScrollPhysics(),
            rowsPerPage: 10,
            selectionMode: SelectionMode.single,
            source: medicionDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'fechaMedicion',
                  label: Container(
                    color: color,
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Fecha',
                        style: style,
                      ))),
              GridColumn(
                  columnName: 'edadMeses',
                  label: Container(
                    color: color,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('EdadMeses',style: style,))),
              GridColumn(
                  columnName: 'pesoKg',
                  label: Container(
                    color: color,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'PesoKg',
                        overflow: TextOverflow.ellipsis,
                        style: style,
                      ))),
              GridColumn(
                  columnName: 'tallaCm',
                  label: Container(
                    color: color,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('TallaCm',style: style,))),
            ],
            onCellTap: (DataGridCellDetails details){
              medicionService.selectedMedicion = medicionService.medicionesLita[details.rowColumnIndex.rowIndex - 1];
              medicionService.exists = true;
              Navigator.pushNamed(context, 'medicion');
            },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
              child: const Icon(FontAwesomeIcons.penToSquare,),
              onPressed: (){
                medicionService.selectedMedicion = Medicion(
                  cuiNinio: ninioService.selectedninio.cui, 
                  edadMeses: 0, 
                  fechaMedicion: '', 
                  notasPeso: '', 
                  notasTalla: '', 
                  pesoKg: 0, 
                  tallaCm: 0);
                medicionService.exists = false;
                Navigator.pushNamed(context, 'medicion');
              },
            ),
   );
  }
}

class MedicionDataSource extends DataGridSource{
  /// Creates the employee data source class with required details.
  MedicionDataSource({required List<Medicion> medicionData}) {
    _medicionData = medicionData
      .map<DataGridRow>((e) => DataGridRow(cells: [
        DataGridCell<String>(columnName: 'fechaMedicion', value: e.fechaMedicion),
        DataGridCell<String>(columnName: 'edadMeses', value: e.edadMeses.toString()),
        DataGridCell<double>(columnName: 'pesoKg', value: e.pesoKg),
        DataGridCell<double>(columnName: 'tallaCm', value: e.tallaCm),
      ]))
      .toList();
  }

  List<DataGridRow> _medicionData = [];

  @override
  List<DataGridRow> get rows => _medicionData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}