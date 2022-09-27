import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_app/models/models.dart';
import 'package:nutri_app/services/ninios_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class TablaMedicionesScreen extends StatelessWidget {

  List<Employee> employees = <Employee>[];

  
  TablaMedicionesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ninioService = Provider.of<NiniosService>(context, listen: false);

    final Color? color; 
    color = ninioService.selectedninio.genero == 'Femenino' 
    ? Colors.pink[300]
    : Colors.blue;

    final TextStyle style = TextStyle(color: Colors.white);

    late EmployeeDataSource employeeDataSource;

    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employeeData: employees);

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
            source: employeeDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'id',
                  label: Container(
                    color: color,
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Fecha',
                        style: style,
                      ))),
              GridColumn(
                  columnName: 'name',
                  label: Container(
                    color: color,
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('EdadMeses',style: style,))),
              GridColumn(
                  columnName: 'designation',
                  label: Container(
                    color: color,
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        'PesoKg',
                        overflow: TextOverflow.ellipsis,
                        style: style,
                      ))),
              GridColumn(
                  columnName: 'salary',
                  label: Container(
                    color: color,
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('TallaCm',style: style,))),
            ],
            onCellTap: (DataGridCellDetails details){
              //TODO: NAVEGAR A EDICION_MEDICION.
              print(employees[details.rowColumnIndex.rowIndex - 1].name);
            },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            floatingActionButton: IconButton(
              icon: const Icon(FontAwesomeIcons.faceAngry),
              onPressed: (){
                //TODO: INGRESAR NUEVA MEDICION EN BLANCO
              },
            ),
   );
  }


  List<Employee> getEmployeeData() {
    return [
      Employee(10001, 'Pedro', 'Project Lead', 20000),
      Employee(10002, 'Kathryn', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 15000),
      Employee(10004, 'Michael', 'Designer', 15000),
      Employee(10005, 'Martin', 'Developer', 15000),
      Employee(10006, 'Newberry', 'Developer', 15000),
      Employee(10007, 'Balnc', 'Developer', 15000),
      Employee(10008, 'Perry', 'Developer', 15000),
      Employee(10009, 'Gable', 'Developer', 15000),
      Employee(10010, 'Grimes', 'Developer', 15000),
      Employee(100011, 'Pedro', 'Project Lead', 20000),
      Employee(100012, 'Kathryn', 'Manager', 30000),
      Employee(100013, 'Lara', 'Developer', 15000),
      Employee(100014, 'Michael', 'Designer', 15000),
      Employee(100015, 'Martin', 'Developer', 15000),
      Employee(100016, 'Newberry', 'Developer', 15000),
      Employee(100017, 'Balnc', 'Developer', 15000),
      Employee(100018, 'Perry', 'Developer', 15000),
      Employee(100019, 'Gable', 'Developer', 15000),
      Employee(100020, 'Grimes', 'Developer', 15000),
    ];
  }
}

class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}


class EmployeeDataSource extends DataGridSource{
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}