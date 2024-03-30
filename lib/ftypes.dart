

part of 'fdatatable.dart';

typedef FDTRequest<DType extends Object> = FutureOr<FDTResponseModel<DType>> Function(FDTRequestModel requestModel);

typedef FActionCallBack<DType extends Object> = void Function(FActionResponse<DType> action);
typedef FDTTranslation = String Function(String key);
typedef FDTRowLoading = Widget Function(int rowIndex);

typedef FDTItemCreator<DType extends Object> = DType Function();

typedef FDTCellBuild<DType extends Object> = Widget Function(DType item);

typedef Getter<DType extends Object, VType> = VType Function(DType item);
typedef Setter<DType extends Object, VType> = FutureOr<bool> Function(DType item, VType value);

String defaultTranslation(String key){
  switch(key){
    case "fdt.pageSize": return  "Page Size";
    case "fdt.pageNumber": return "Page Number";
    case "fdt.totalItems": return "Total Items";
    case "fdt.nextPage": return "Next Page";
    case "fdt.previousPage": return "Previous Page";
    case "fdt.formEditTitle": return "Edit Item";
    case "fdt.formAddTitle": return "Add Item";
    case "fdt.formSaveBtn": return "Save";
    case "fdt.formResetBtn": return "Reset";
    case "fdt.filterBtn": return "Filter";
    case "fdt.tableError": return "Error";
  }
  return key;
}

enum FDTState{
  loading,
  noData,
  error,
  building,
  form,
}


enum FDTFormType{
  edit,
  add,
}

enum FDTSize{
  sm,
  md,
  lg,
  xl,
  xxl
}

enum FDTActionTypes{
  delete,
  remove,
  add,
  edit,
  refresh,
  newForm,
  next,
  previous,
  toPage,
  info,
  detail,
  save,
  userAction,
  userAction2,
}