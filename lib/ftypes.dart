

part of 'fdatatable.dart';

typedef FDTRequest<DType extends Object> = FutureOr<FDTResponseModel<DType>> Function(FDTRequestModel requestModel);
typedef FActionCallBack<DType extends Object> = void Function(FActionResponse<DType> action);
typedef FTranslation = String Function(String key);

typedef FDTItemCreator<DType extends Object> = DType Function();

typedef FDTCellBuild<DType extends Object> = Widget Function(DType item);

typedef Getter<DType extends Object, VType> = VType Function(DType item);
typedef Setter<DType extends Object, VType> = FutureOr<bool> Function(DType item, VType value);

String defaultTranslation(String key){
  return key;
}

enum FDTState{
  loading,
  noData,
  error,
  building,
  adding,
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
