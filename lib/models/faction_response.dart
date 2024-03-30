
part of '../fdatatable.dart';

class FActionResponse<DType extends Object>{
  final DType? item;
  final FDTActionTypes action;
  final int index;
  FActionResponse({
    required this.action,
    this.item,
    this.index = -1,
  });
}
