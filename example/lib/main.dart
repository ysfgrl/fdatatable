
import 'dart:html';

import 'package:f_json_editor/f_json_editor.dart';
import 'package:fdatatable_example/Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fdatatable/fdatatable.dart';
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
  late FDTController<Model> dataTableController;
  late List<FDTBaseColumn<Model>> columns;
  late List<FDTFilter> filters;
  @override
  void initState() {
    super.initState();
    dataTableController = FDTController();
    columns = [
      FDTBaseColumn<Model>(
          title: "Name",
          cellBuilder: (item) {
            return Text(item.firstName);
          },
          columnWidth: 75,
      ),
      FDTBaseColumn<Model>(
          title: "Last Name",
          cellBuilder: (item) {
            return Text(item.lastName);
          },
      ),
      FDTBaseColumn<Model>(
        title: "E-mail",
        cellBuilder: (item) {
          return Text(item.email);
        },
        columnWidth: 100,
      ),

      FDTBaseColumn<Model>(
          title: "Full Name",
          cellBuilder: (item) {
            return Text(item.firstName + " "+ item.lastName);
          },
      ),
      FDTBaseColumn<Model>(
          title: "Active",
          cellBuilder: (item) {
            if(item.isActive){
              return Text("Active", style: TextStyle(color: Colors.green), );
            }else{
              return Text("Passive", style: TextStyle(color: Colors.red), );
            }
          },
          columnWidth: 100,
      ),
      FDTBaseColumn<Model>(
          title: "Age",
          cellBuilder: (item) {
            return Text(item.age.toString());
          },
          columnWidth: 50,
        isExpand: true,
      ),

      FDTBaseColumn<Model>(
          title: "Gender",
          cellBuilder: (item) {
            return Text(item.gender);
          },
      ),
      FDTBaseColumn<Model>(
          title: "User Type",
          cellBuilder: (item) {
            if(item.userType == 1){
              return Row(
                children: [
                  Icon(Icons.add_moderator_outlined, color: Colors.red,),
                  Text("SuperAdmin")
                ],
              );
            }
            else{
              return Row(
                children: [
                  Icon(CupertinoIcons.textformat_size, color: Colors.red,),
                  Text("Guest")
                ],
              );
            }
          },
      ),
      FDTBaseColumn<Model>(
        isExpand: true,
          title: "Detail",
          cellBuilder: (item) {
            return Text(item.detail);
          }
      ),
      FDTBaseColumn<Model>(
        title: "Date",
        isExpand: true,
        cellBuilder: (item) {
          return SizedBox(
            height: 200,
            child: FJSONEditor(
              showHeader: true,
              isEditable: false,
              jsonData: {
                "key1":"val1",
                "key2":2,
                "key3":["ff", "ff"]
              },
              actionCallback: (actionKey, jsonData) {

              },
            ),
          );
        },
        columnWidth: 250,
      ),
    ];
    filters =  [
      FDTTextFilter(
        key: "name",
        val: "defaultName",
        decoration: InputDecoration(
          labelText: "fieldName",
          contentPadding: EdgeInsets.all(1),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
        ),
      ),
      FDTIntFilter(key: "intkey", val: 1,
          decoration: InputDecoration(
            labelText: "fieldName",
            contentPadding: EdgeInsets.all(1),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
          )
      ),
      FDTCheckboxFilter(
          val: true,
          key: "aktive",
          decoration: InputDecoration(
            labelText: "fieldName",
            contentPadding: EdgeInsets.all(1),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
          )

      ),

      FDTDropDownFilter<String>(key: "drop",
          val: "admin",
          items: [
            DropdownMenuItem<String>(
              value: "admin",
              child: Text("Admin"),
            ),

            DropdownMenuItem<String>(
              value: "superadmin",
              child: Text("SuperAdmin"),
            )
          ],
          decoration: InputDecoration(
            labelText: "fieldName",
            contentPadding: EdgeInsets.all(1),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
          )
      ),
      FDTDateFilter(val: DateTime.now().toIso8601String(), key: "date", decoration: InputDecoration(
        labelText: "fieldName",
        contentPadding: EdgeInsets.all(1),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
      ))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FDataTable example app'),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: FDT<Model>(
                title: Text("User list Table"),
                fdtRequest: (requestModel) async {
                  await Future.delayed(Duration(seconds: 2));
                  print("request");
                  print(requestModel.filters);
                  return FDTResponseModel(
                      page: requestModel.page,
                      pageSize: requestModel.pageSize,
                      total: 100,
                      list: _exampleModels(requestModel.pageSize)
                  );
                },
                controller: dataTableController,
                columns: columns,
                filters: filters,
                actionCallBack: (action) {
                  switch(action.action){
                    case FDTActionTypes.delete:
                      dataTableController.removeAt(action.index);
                    case FDTActionTypes.refresh:
                      dataTableController.refreshPage();
                    case FDTActionTypes.toPage:
                      dataTableController.toPage(10);
                    case FDTActionTypes.add:
                    default:
                      break;
                  }
                },
                // fdtRowLoading: (item, rowIndex) {
                //   // return Text(rowIndex.toString()+"-)");
                //   return CircleAvatar(
                //     radius: 20,
                //     child: Text(rowIndex.toString()+"-)"),
                //   );
                // },
                topActions: const [
                  FDTAction(text: "New",  action: FDTActionTypes.add, icon: Icon(Icons.plus_one_outlined, color: Colors.blue,)),
                  FDTAction(text: "Refresh", action: FDTActionTypes.refresh, icon: Icon(Icons.refresh_outlined,)),
                  FDTAction(text: "To Page 10", action: FDTActionTypes.toPage, icon: Icon(Icons.arrow_circle_right_outlined,)),
                ],
                rowActions: const [
                  FDTAction(text: "Edit", action: FDTActionTypes.edit, icon: Icon(Icons.edit,)),
                  FDTAction(text: "Delete", action: FDTActionTypes.delete,
                      icon: Icon(Icons.delete_forever, color: Colors.red,)
                  ),
                  FDTAction(text: "İnfo", action: FDTActionTypes.info,
                      icon: Icon(Icons.info, color: Colors.red,)
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Model> _exampleModels(int count){
    return List<Model>.generate(count, (index) {
      return Model(
          id: "id" + index.toString(),
          firstName: "name"+index.toString(),
          lastName: "surname"+index.toString(),
          email: "example@gmail.com",
          age: index,
          isActive: index%2 == 0 ? true : false,
          gender: "Male",
          birthDate: DateTime.now(),
          detail: "No detail",
          userType: index%3,
      );
    },);
  }
}
