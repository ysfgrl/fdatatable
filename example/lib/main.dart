
import 'package:fdatatable_example/UserModel.dart';
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
  late FDTController<UserModel> dataTableController;
  late List<FDTBaseColumn<UserModel, dynamic>> columns;
  @override
  void initState() {
    super.initState();
    dataTableController = FDTController();
    columns = [
      FDTTextColumn<UserModel>(
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
      FDTTextColumn<UserModel>(
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
      FDTTextColumn<UserModel>(
        key: "email",
        title: "E-mail",
        inputType: TextInputType.emailAddress,
        getter: (item) => item.email,
        setter: (item, value) {
          item.email = value;
          return true;
        },
        max: 50,
        min: 5,
        visible: true,
      ),
      FDTDateColumn<UserModel>(
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
      FDTLargeTextColumn<UserModel>(
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
      FDTCheckboxColumn<UserModel>(
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
      FDTIntColumn<UserModel>(
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
      FDTDropDownColumn<UserModel, String>(
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
      FDTRadioGroupColumn<UserModel, int>(
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
      FDTLargeTextColumn<UserModel>(
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: FDT<UserModel>(
                fdtRequest: (requestModel) async {
                  await Future.delayed(Duration(seconds: 2));
                  print("first request");
                  print(requestModel.filters);
                  return FDTResponseModel(
                      page: requestModel.page,
                      pageSize: requestModel.pageSize,
                      total: 100,
                      list: _exapleModels(requestModel.pageSize)
                  );
                },
                controller: dataTableController,
                columns: columns,
                actionCallBack: (action) {
                  switch(action.key){
                    case "delete":
                      dataTableController.removeAt(action.index);
                    case "refresh":
                      dataTableController.refreshPage();
                    case "edit":
                      dataTableController.editItem(action.index!);
                    case "toPage":
                      dataTableController.toPage(10);
                    case "addTest":
                      dataTableController.addItem(UserModel(
                          firstName: "Test Name",
                          lastName: "Test surname surname sefasef sur",
                          email: "test email",
                          age: 1,
                          isActive: false,
                          gender: "Male",
                          id: "testid",
                          birthDate: DateTime.now(),
                          detail: "test detail",
                          userType: 2
                      ));
                    case "add":
                      dataTableController.newItem(UserModel(
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
                    case "formSave":
                      print(action.item!.firstName);
                      print(action.item!.lastName);
                      print(action.item!.email);
                      print(action.item!.gender);
                      print(action.item!.birthDate);
                  }
                },
                topActions: [
                  FAction(text: Text("New"), toolTip: "Add", key: "add",
                      icon: Icon(Icons.plus_one_outlined, size: 20, color: Colors.blue,)),
                  FAction(text: Text("Refresh"), key: "refresh", icon: Icon(Icons.refresh_outlined, size: 20,)),
                  FAction(text: Text("To Page 10"), key: "toPage", icon: Icon(Icons.arrow_circle_right_outlined, size: 20,)),
                  FAction(text: Text("Add Test"), key: "addTest", icon: Icon(Icons.add, size: 20,)),
                ],
                rowActions: [
                  FAction(toolTip: "Edit", key: "edit", icon: Icon(Icons.edit, size: 20,)),
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

  List<UserModel> _exapleModels(int count){
    return List<UserModel>.generate(count, (index) {
      return UserModel(
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
