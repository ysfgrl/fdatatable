
part of 'fdatatable.dart';


class FDTFormNotifier<DType extends Object> extends ChangeNotifier{


  DType newItem;
  final _formKey = GlobalKey<FormBuilderState>();
  FDTFormNotifier({
    required this.newItem
  });

  updateValue(){
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}