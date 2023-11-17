
import 'package:fdatatable/models/faction.dart';
import 'package:fdatatable/models/fpage_response.dart';
import 'package:flutter/material.dart';
import 'package:fdatatable/fdatatable.dart';
import 'package:fdatatable/fdatatable_controller.dart';
import 'package:fdatatable/models/fcolumn.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FDataTableController<Model> dataTableController;
  @override
  void initState() {
    super.initState();
    dataTableController = FDataTableController();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: FDataTable<Model>(
                title: Text("Example DataTable"),
                icon: Icon(Icons.table_chart_outlined),
                controller: dataTableController,
                columns: [
                  BaseColumn(
                    title: "title1",
                    cellBuilder: (item) {
                      return Text(item.name);
                    },
                  ),
                  BaseColumn(
                    title: "Surname",
                    cellBuilder: (item) {
                      return Text(item.surname);
                    },
                  ),
                  BaseColumn(
                    title: "Full Name",
                    cellBuilder: (item) {
                      return Text(item.name + item.surname+ item.surname, overflow: TextOverflow.ellipsis,);
                    },
                  ),
                  BaseColumn(
                    title: "Age",
                    cellBuilder: (item) => Text(item.age.toString()),
                  )
                ],
                pageRequest:(pageRequest) async {
                  await Future.delayed(Duration(seconds: 2));
                  print("first request");
                  return FPageResponse(
                      page: pageRequest.page,
                      pageSize: pageRequest.pageSize,
                      total: 100,
                      list: _exapleModels()
                  );
                },
                actionCallBack: (action) {
                  print(action.key);
                  print(action.index);
                  print(action.item!.name);
                },
                topActions: [
                  FAction(text: Text("New"), key: "add", icon: Icon(Icons.plus_one_outlined, size: 20,)),
                  FAction(text: Text("Refresh"), key: "add", icon: Icon(Icons.refresh_outlined, size: 20,)),
                  FAction(text: Text("Export"), key: "add", icon: Icon(Icons.import_export, size: 20,))
                ],
                bottomActions: [
                  FAction(toolTip: "Refresh", key: "add", icon: Icon(Icons.refresh, size: 20,))
                ],
                rowActions: [
                  FAction(toolTip: "Edit", key: "add", icon: Icon(Icons.edit, size: 20,)),
                  FAction(toolTip: "Delete", key: "delete",
                      icon: Icon(Icons.delete_forever, color: Colors.red, size: 20,)
                  ),
                  FAction(toolTip: "İnfo", key: "info",
                      icon: Icon(Icons.info, color: Colors.red, size: 20,)
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Model> _exapleModels(){
    return List<Model>.generate(20, (index) {
      return Model(name: "name"+index.toString(), surname: "surname"+index.toString(), age: index);
    },);
  }
}

class Model{
  final String name;
  final String surname;
  final int age;
  Model({required this.name, required this.surname, required this.age});
}
