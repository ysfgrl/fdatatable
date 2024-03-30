
part of 'fdatatable.dart';


class FDTFormNotifier<DType extends Object> extends ChangeNotifier{


  DType? newItem;
  int index;
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey rebuildKey = GlobalKey();
  FDTFormNotifier({
    this.newItem,
    this.index = -1
  }){
    notifyListeners();
  }

  updateItem(DType item, int index){
    this.index = index;
    this.newItem = item;
    notifyListeners();
  }
  updateValue(){
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}