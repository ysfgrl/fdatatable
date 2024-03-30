
import 'package:fdatatable_example/Model.dart';
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
  late List<FDTBaseColumn<Model, dynamic>> columns;
  @override
  void initState() {
    super.initState();
    dataTableController = FDTController();
    columns = [
      FDTTextColumn<Model>(
          key: "firstName",
          title: "Name",
          getter: (item) => item.firstName,
          setter: (item, value) {
            item.firstName = value;
            return true;
          },
          max: 50,
          min: 5,
          visible: true,
          columnWidth: 75,
      ),
      FDTTextColumn<Model>(
          key: "lastName",
          title: "Last Name",
          getter: (item) => item.lastName,
          setter: (item, value) {
            item.lastName = value;
            return true;
          },
          max: 50,
          min: 5,
          visible: true,
          columnWidth: 100,
      ),
      FDTTextColumn<Model>(
        key: "email",
        title: "E-mail",
        inputType: TextInputType.emailAddress,
        getter: (item) => item.email,
        setter: (item, value) {
          item.email = value;
          return true;
        },
        cellBuilder: (item) {
          return Text("full name");
        },
        max: 50,
        min: 5,
        visible: true,
      ),
      FDTDateColumn<Model>(
          key: "birthDate",
          title: "Date",
          inputType: InputType.date,
          getter: (item) => item.birthDate,
          setter: (item, value) {
            item.birthDate = value;
            return true;
          },
          visible: true,
          columnWidth: 250,
      ),
      FDTLargeTextColumn<Model>(
          key: "fullName",
          title: "Full Name",
          getter: (item) => item.firstName + item.lastName,
          setter: (item, value) {
            return true;
          },
          minLines: 3,
          maxLines: 10,
          maxLength: 500,
          visible: true
      ),
      FDTCheckboxColumn<Model>(
          key: "isActive",
          title: "Active",
          getter: (item) => item.isActive,
          setter: (item, value) {
            item.isActive = value;
            return true;
          },
          cellBuilder: (item) {
            if(item.isActive){
              return Text("Active", style: TextStyle(color: Colors.green), );
            }else{
              return Text("Passive", style: TextStyle(color: Colors.red), );
            }
          },
          required: true,
          columnWidth: 100,
      ),
      FDTIntColumn<Model>(
          key: "age",
          title: "Age",
          getter: (item) => item.age,
          setter: (item, value) {
            item.age = value;
            return true;
          },
          min: 0,
          max: 50,
          columnWidth: 50,
      ),
      FDTDropDownColumn<Model, String>(
          items: const [
            DropdownMenuItem<String>(
              value: "Male",
              child: Text("Male"),
            ),
            DropdownMenuItem<String>(
              value: "FaMale",
              child: Text("FaMale"),
            )
          ],
          key: "gender",
          title: "Gender",
          getter: (item) => item.gender,
          setter: (item, value) {
            item.gender = value;
            return true;
          },
      ),
      FDTRadioGroupColumn<Model, int>(
          items: const [
            FormBuilderFieldOption<int>(
              value: 1,
              child: Text("Super Admin"),
            ),
            FormBuilderFieldOption<int>(
              value: 2,
              child: Text("Admin"),
            ),
            FormBuilderFieldOption<int>(
              value: 3,
              child: Text("Guest"),
            )
          ],
          key: "userType",
          title: "User Type",
          getter: (item) => item.userType,
          visible: false,
          setter: (item, value) {
            item.userType = value;
            return true;
          },
      ),
      FDTLargeTextColumn<Model>(
          key: "detail",
          title: "Detail",
          getter: (item) => item.detail,
          setter: (item, value) {
            item.detail = value;
            return true;
          },
          minLines: 3,
          maxLines: 10,
          maxLength: 500
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FDataTable example app'),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(2),
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
                actionCallBack: (action) {
                  switch(action.action){
                    case FDTActionTypes.remove:
                    case FDTActionTypes.delete:
                      dataTableController.removeAt(action.index);
                    case FDTActionTypes.refresh:
                      dataTableController.refreshPage();
                    case FDTActionTypes.edit:
                      dataTableController.editItem(action.index!);
                    case FDTActionTypes.toPage:
                      dataTableController.toPage(10);
                    case FDTActionTypes.add:
                      dataTableController.newItem(Model(
                          firstName: "",
                          lastName: "",
                          email: "",
                          age: 1,
                          isActive: false,
                          gender: "Male",
                          id: "testid",
                          birthDate: DateTime.now(),
                          detail: "",
                          userType: 2
                      ));
                    case FDTActionTypes.save:
                      print(action.item!.firstName);
                      print(action.item!.lastName);
                      print(action.item!.email);
                      print(action.item!.gender);
                      print(action.item!.birthDate);

                    case FDTActionTypes.newForm:
                    case FDTActionTypes.next:
                    case FDTActionTypes.previous:
                    case FDTActionTypes.info:
                    case FDTActionTypes.detail:
                    case FDTActionTypes.userAction:
                    case FDTActionTypes.userAction2:
                      print("not found action");
                  }
                },
                fdtRowLoading: (rowIndex) {
                  return Text(rowIndex.toString()+"-)");
                },
                topActions: [

                  FAction(text: Text("New"), toolTip: "Add", action: FDTActionTypes.add, icon: Icon(Icons.plus_one_outlined, size: 20, color: Colors.blue,)),
                  FAction(text: Text("Refresh"), action: FDTActionTypes.refresh, icon: Icon(Icons.refresh_outlined, size: 20,)),
                  FAction(text: Text("To Page 10"), action: FDTActionTypes.toPage, icon: Icon(Icons.arrow_circle_right_outlined, size: 20,)),
                ],
                rowActions: [
                  FAction(toolTip: "Edit", action: FDTActionTypes.edit, icon: Icon(Icons.edit, size: 20,)),
                  FAction(toolTip: "Delete", action: FDTActionTypes.delete,
                      icon: Icon(Icons.delete_forever, color: Colors.red, size: 20,)
                  ),
                  FAction(toolTip: "İnfo", action: FDTActionTypes.info,
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
          userType: 1,
      );
    },);
  }
}
