
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
  @override
  void initState() {
    super.initState();
    dataTableController = FDTController();
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
              child: FDT<Model>(
                firstPage: 2,
                pageSize: 20,
                itemCreator: () {
                  return Model(
                      name: "sddf",
                      email: "",
                      surname: "",
                      age: 1,
                      isActive: false,
                    price: 0.5,
                    gender: "Male",
                    date: DateTime.now()
                  );
                },
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
                title: Text("Example DataTable"),
                icon: Icon(Icons.table_chart_outlined),
                controller: dataTableController,
                columns: [
                  FDTTextColumn(
                    key: "name",
                    title: "Name",
                    getter: (item) => item.name,
                    setter: (item, value) {
                        item.name = value;
                        return true;
                    },
                    max: 50,
                    min: 5,
                    visible: true,
                    columnWidth: 75,
                    readOnly: true
                  ),
                  FDTTextColumn(
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
                    visible: true
                  ),
                  FDTDateColumn(
                    key: "date",
                    title: "Date",
                    inputType: InputType.date,
                    getter: (item) => item.date,
                    setter: (item, value) {
                        item.date = value;
                        return true;
                    },
                    visible: true,
                    columnWidth: 200
                  ),
                  FDTTextColumn(
                    key: "surname",
                    title: "Surname",
                    getter: (item) => item.surname,
                    setter: (item, value) {
                      item.surname = value;
                      return true;
                    },
                    max: 50,
                    min: 5,
                    visible: true
                  ),
                  FDTLargeTextColumn(
                    key: "fullaname",
                    title: "Full Name",
                    getter: (item) => item.name + item.surname,
                    setter: (item, value) {
                      return true;
                    },
                    minLines: 3,
                    maxLines: 10,
                    maxLength: 500
                  ),
                  FDTCheckboxColumn(
                    key: "isActive",
                    title: "Active",
                    getter: (item) => item.isActive,
                    setter: (item, value) {
                      item.isActive = value;
                      return true;
                    },
                    required: true,
                    columnWidth: 100
                  ),
                  FDTIntColumn(
                    key: "age",
                    title: "Age",
                    getter: (item) => item.age,
                    setter: (item, value) {
                      item.age = value;
                      return true;
                    },
                    min: 0,
                    max: 50,
                    columnWidth: 50
                  ),
                  FDTSliderColumn(
                    key: "price",
                    title: "Price",
                    min: 0.0,
                    max: 5.0,
                    getter: (item) => item.price,
                    setter: (item, value) {
                      item.price = value;
                      return true;
                    },
                  ),
                  FDTDropDownColumn<Model, String>(
                    items: [
                      DropdownMenuItem<String>(
                        value: "Male",
                        child: Text("Male"),
                      ),
                      DropdownMenuItem<String>(
                        value: "FaMale",
                        child: Text("FaMale"),
                      )
                    ],
                    key: "Gender",
                    title: "Gender",
                    getter: (item) => item.gender,
                    setter: (item, value) {
                      item.gender = value;
                      return true;
                    },
                  ),
                  FDTRadioGroupColumn<Model, String>(
                    items: [
                      FormBuilderFieldOption<String>(
                        value: "Male",
                        child: Text("Male"),
                      ),
                      FormBuilderFieldOption<String>(
                        value: "FaMale",
                        child: Text("FaMale"),
                      )
                    ],
                    key: "Gender",
                    title: "Gender",
                    getter: (item) => item.gender,
                    setter: (item, value) {
                      item.gender = value;
                      return true;
                    },
                  ),
                ],
                actionCallBack: (action) {
                  print(action.key);
                  if(action.key == "formSave"){
                    print(action.item!.name);
                    print(action.item!.isActive);
                    print(action.item!.age);
                    print(action.item!.price);
                    print(action.item!.gender);
                  }
                  if(action.key == "add"){
                    dataTableController.newItem();
                  }
                },
                topActions: [
                  FAction(text: Text("New"), key: "add", icon: Icon(Icons.plus_one_outlined, size: 20,)),
                  // FAction(text: Text("Refresh"), key: "add", icon: Icon(Icons.refresh_outlined, size: 20,)),
                  // FAction(text: Text("Export"), key: "add", icon: Icon(Icons.import_export, size: 20,))
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
                filters: [
                  FDTTextFilter(key: "Keyword1", title: "Search",),
                  FDTTextFilter(key: "Keyword2", title: "Search", value: "..."),
                  // FDTTextFilter(key: "Keyword3", title: "Search", value: "..."),
                  FDTSelectFilter<String>(key: "slect", title: "Select", value: "2", items: [
                    DropdownMenuItem(
                      child: Text("item1"),
                      value: "1"
                    ),
                    DropdownMenuItem(
                      child: Text("item2"),
                      value: "2"
                    )
                  ]),
                  // FDTSelectFilter<int>(key: "slect2", title: "Select", items: [
                  //   DropdownMenuItem(
                  //     child: Text("1"),
                  //     value: 1
                  //   ),
                  //   DropdownMenuItem(
                  //     child: Text("2"),
                  //     value: 2
                  //   )
                  // ]),
                  // FDTDateFilter(key: "key1", title: "title", value: DateTime.parse("2013-01-01"), inputType: InputType.date),
                  // FDTDateFilter(key: "key2", title: "title", value: DateTime.parse("2013-01-01 05:05"), inputType: InputType.time),
                  FDTSubmitFilter()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Model> _exapleModels(int count){
    return List<Model>.generate(count, (index) {
      return Model(
          name: "name"+index.toString(),
          surname: "surname"+index.toString(),
          email: "example@gmail.com",
          age: index,
          isActive: true,
        price: 0.3,
        gender: "Male",
        date: DateTime.now()
      );
    },);
  }
}

class Model{
   DateTime date;
   String email;
   String name;
   String surname;
   int age;
   bool isActive;
   double price;
   String gender;
  Model({required this.name,
    required this.date,
    required this.email,
    required this.surname,
    required this.age,
    required this.isActive,
    required this.price,
    required this.gender
  });
}
