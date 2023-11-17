

import 'dart:async';

import 'package:fdatatable/models/faction_response.dart';
import 'package:fdatatable/models/fpage_request.dart';
import 'package:fdatatable/models/fpage_response.dart';

typedef PageRequest<DType extends Object> = FutureOr<FPageResponse<DType>> Function(FPageRequest pageRequest);
typedef FActionCallBack<DType extends Object> = void Function(FActionResponse<DType> action);
typedef FTranslation = String Function(String key);

String defaultTranslation(String key){
  return key;
}

enum FTableState{
  loading,
  noData,
  error,
  building
}