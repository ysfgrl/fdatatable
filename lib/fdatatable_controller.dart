


part of 'fdatatable.dart';

class FDTController<DType extends Object>{
  late final FDTNotifier<DType> _state;
  Future<void> nextPage() => _state.nextPage();
  Future<void> toPage(int page) => _state.toPage(page);
  Future<void> previousPage() => _state.previousPage();
  Future<void> refreshPage() => _state.refreshPage();
  DType removeAt(int index) => _state.removeAt(index);
  void addItem(DType item) => _state.addItem(item);
  void dispose() {
    _state.dispose();
  }

}