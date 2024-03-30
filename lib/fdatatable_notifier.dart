
part of 'fdatatable.dart';

class FDTNotifier<DType extends Object> extends ChangeNotifier{
  final tableKey = GlobalKey();
  final ScrollController rowsScrollController = ScrollController();
  final List<FDTBaseColumn<DType, dynamic>> columns;
  final FDTController<DType> controller;
  final FDTRequest<DType> fdtRequest;
  final FDTRequestModel requestModel;
  final FActionCallBack<DType> actionCallBack;

  FDTResponseModel<DType> responseModel = FDTResponseModel.Empty();
  FDTState state = FDTState.loading;
  Object? _error;

  FDTFilterNotifier<DType> filterState;
  FDTFormNotifier<DType> formState;

  FDTNotifier({
    required this.fdtRequest,
    required this.columns,
    required this.actionCallBack,
    required this.requestModel,
    required FDTController<DType>? controller,
    required this.filterState,
    required this.formState
  }): this.controller = controller ?? FDTController() {
    _init();
  }

  int getColumSize() => columns.length;

  double inputHeight = 50;

  double width = 0;
  FDTSize size = FDTSize.sm;
  void setWidth(double width){
    this.width = width;
    if(width >=1400){
      size = FDTSize.xxl;
    }else if(width >= 1200){
      size = FDTSize.xl;
    }else if(width >= 992){
      size = FDTSize.lg;
    }else if(width >= 768){
      size = FDTSize.md;
    } else if(width >= 576){
      size = FDTSize.sm;
    }else{
      size = FDTSize.sm;
    }
  }


  void saveFilter(){
    requestModel.filters = filterState.filters.map((key, value) => MapEntry(key, value));
    _getPage();
    isOpenFilter = false;
  }

  bool isOpenFilter = false;
  void openFilter(bool isOpen){
    isOpenFilter = isOpen;
    state = FDTState.building;
    notifyListeners();
  }

  Future<void> setPageSize(int pageSize){
    responseModel.pageSize = pageSize;
    requestModel.pageSize = pageSize;
    return _getPage();
  }
  void _init(){
    _getPage();
    controller._state = this;
  }

  Future<void> nextPage(){
    requestModel.page = responseModel.page+1;
    return _getPage();
  }

  Future<void> previousPage(){
    requestModel.page = responseModel.page-1;
    return _getPage();
  }
  Future<void> refreshPage(){
    return _getPage();
  }
  Future<void> toPage(int page){
    requestModel.page = page;
    return _getPage();
  }

  void newItem(DType newItem){
    isOpenFilter = false;
    formState.updateItem(newItem, -1);
    state = FDTState.form;
    notifyListeners();
  }

  void editItem(int index) async{
    isOpenFilter = false;
    formState.updateItem(responseModel.list[index], index);
    state = FDTState.form;
    notifyListeners();
  }

  DType removeAt(int index){
    DType removed = responseModel.list.removeAt(index);
    notifyListeners();
    return removed;
  }
  void addItem(DType item){
    responseModel.list.add(item);
    notifyListeners();
  }

  void closeForm(){
    state = FDTState.building;
    notifyListeners();
  }


  Future<void> _getPage() async{
    state = FDTState.loading;
    notifyListeners();
    _error = null;
    try{
      responseModel = await fdtRequest(requestModel);
      state = FDTState.building;
      notifyListeners();
    }  catch (err, stack) {
      debugPrint(stack.toString());
      state = FDTState.error;
      _error = err;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    rowsScrollController.dispose();
    super.dispose();
  }


}