

import 'package:fdatatable/models/fcolumn.dart';
import 'package:fdatatable/fdatatable_controller.dart';
import 'package:fdatatable/ftypes.dart';
import 'package:fdatatable/models/fpage_request.dart';
import 'package:fdatatable/models/fpage_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FDataTableNotifier<DType extends Object> extends ChangeNotifier{

  final ScrollController rowsScrollController = ScrollController();
  final List<BaseColumn<DType>> columns;
  final FDataTableController<DType> controller;
  final PageRequest<DType> pageRequest;
  final FActionCallBack<DType> actionCallBack;
  FPageResponse<DType> fPageResponse = FPageResponse.Empty();
  FTableState state = FTableState.loading;
  Object? _error;
  FDataTableNotifier({
    required this.controller,
    required this.pageRequest,
    required this.columns,
    required this.actionCallBack
  }){
    _init();
  }

  int getColumSize() => columns.length;

  double _width = 0;
  double get width => _width;
  set maxWidth(double width){
    _width = width;
  }


  void setPageSize(int pageSize){
    fPageResponse.pageSize = pageSize;
    _getPage(FPageRequest(
        page: fPageResponse.page,
        pageSize: fPageResponse.pageSize)
    );
  }
  void _init(){
    _getPage(FPageRequest(
        page: fPageResponse.page+1,
        pageSize: fPageResponse.pageSize)
    );
  }

  void nextPage(){
    _getPage(FPageRequest(
        page: fPageResponse.page+1,
        pageSize: fPageResponse.pageSize),
    );
  }

  void previousPage(){
    _getPage(FPageRequest(
        page: fPageResponse.page-1,
        pageSize: fPageResponse.pageSize));
  }


  void _getPage(FPageRequest fPageRequest) async{
    state = FTableState.loading;
    notifyListeners();
    _error = null;
    try{
      fPageResponse = await pageRequest(fPageRequest);
      state = FTableState.building;
      notifyListeners();
    }  catch (err, stack) {
      debugPrint(stack.toString());
      state = FTableState.error;
      _error = err;
      notifyListeners();
    }
  }

}