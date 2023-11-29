
part of 'fdatatable.dart';


class FDTFilterNotifier<DType extends Object> extends ChangeNotifier{

  final _formKey = GlobalKey<FormBuilderState>();

  final Map<String, dynamic> filters;
  FDTFilterNotifier({
    required this.filters
  });

  dynamic getValue(String key){
    return filters[key];
  }
  void setValue(String key, dynamic value){
    filters[key] = value;
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