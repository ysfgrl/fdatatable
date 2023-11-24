
part of '../fdatatable.dart';

class FDTResponseModel<DType extends Object>{
  List<DType> list;
  int page;
  int pageSize;
  int total;
  FDTResponseModel({
    this.list=const [],
    this.page =0,
    this.pageSize=10,
    this.total=0,
  });

  FDTResponseModel.Empty(): list = [], page = 0, pageSize =10, total=0;
}