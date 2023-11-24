
part of 'fdatatable.dart';

class FDTForm<DType extends Object> extends StatelessWidget{

  DType? item;
  final FDTFormType formType;
  FDTForm({
    super.key,
    required this.formType,
    this.item
  });


  @override
  Widget build(BuildContext context) {
    return Consumer<FDTNotifier<DType>>(
      builder: (context, state, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withAlpha(200),
          ),
          child: Center(
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft :Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text("ftd.newitem"),
                      trailing: IconButton(
                        icon: Icon(Icons.close, color: Colors.red,),
                        onPressed: () {
                          state.closeForm();
                        },
                      ),
                    ),
                  ),
                  Divider(height: 1,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child:  _form(context, state),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _form(BuildContext context, FDTNotifier<DType> tableState){
    return ChangeNotifierProvider<FDTFormNotifier<DType>>(
      create:(context) => FDTFormNotifier<DType>(
        newItem: tableState.itemCreator()
      ),
      builder: (context, child) {
        var formState = context.read<FDTFormNotifier<DType>>();

        return SingleChildScrollView(
          child: FormBuilder(
            key: formState._formKey,
            child: Column(
              children: [
                ...tableState.columns.map((e) => e.formBuild(context)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () =>
                              tableState.actionCallBack(FActionResponse<DType>(
                                  key: "formSave",
                                  item: formState.newItem
                              )),
                          child: Text("Save")),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

  }


}