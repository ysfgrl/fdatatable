
part of 'fdatatable.dart';

class FDTForm<DType extends Object> extends StatelessWidget{
  final FDTNotifier<DType> tableState;
  final FDTTranslation translation;
  const FDTForm({super.key,
    required this.tableState,
    required this.translation
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      color: Colors.transparent,
      elevation: 0,
      child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha(200),
      ),
      child: Center(
        child: Container(
          width: _formWidth(tableState.size),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft :Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: tableState.formState.index == -1 ? Text(translation("fdt.formAddTitle")) : Text(translation("fdt.formEditTitle")),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red,),
                    onPressed: () {
                      tableState.closeForm();
                       Navigator.pop(context);
                    },
                  ),
                ),
              ),
              const Divider(height: 1,),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child:  _form(context, tableState),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _form(BuildContext context, FDTNotifier<DType> tableState){
    return ChangeNotifierProvider<FDTFormNotifier<DType>>.value(
      value: tableState.formState,
      builder: (context, child) {
        var formState = context.read<FDTFormNotifier<DType>>();
        if(formState.newItem == null){
          return SingleChildScrollView(
            child: FormBuilder(
              key: formState._formKey,
              child: const Column(
                children: [
                  Text("Item not Selected")
                ],
              )),
          );
        }
        return SingleChildScrollView(
          child: FormBuilder(
            key: formState._formKey,
            child: Column(
              children: [
                ...tableState.columns.where((element) => !element.visibleOnly).map((e) => e.formBuild(context)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            if(formState._formKey.currentState!=null){
                              if(formState._formKey.currentState!.validate()){
                                tableState.actionCallBack(FActionResponse<DType>(
                                    action: FDTActionTypes.save,
                                    item: formState.newItem
                                ));
                                return;
                              }
                            }
                          },
                          child: Text(translation("fdt.formSaveBtn"))),
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


  double _formWidth(FDTSize size){
    double width = 400;
    switch(size){
      case FDTSize.sm:
          width = 400;
      case FDTSize.md:
          width = 600;
      case FDTSize.lg:
          width = 800;
      case FDTSize.xl:
          width = 800;
      case FDTSize.xxl:
          width = 800;

    }
    return width;
  }

}