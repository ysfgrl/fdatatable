
part of '../fdatatable.dart';

class FActionResponse<DType extends Object>{
  final DType? item;
  final String key;
  final int? index;
  FActionResponse({
    required this.key,
    this.item,
    this.index,
  });
}
