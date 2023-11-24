
part of '../fdatatable.dart';
class FDTRequestModel{
  int page;
  int pageSize;
  Map<String, dynamic> filters;
  FDTRequestModel({
    this.page =0,
    this.pageSize = 10,
    this.filters = const {}
  });
}