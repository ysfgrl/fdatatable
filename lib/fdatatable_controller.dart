


part of 'fdatatable.dart';

class FDTController<DType extends Object>{


  late final FDTNotifier<DType> _state;

  Future<void> nextPage() => _state.nextPage();
  Future<void> previousPage() => _state.previousPage();
  void newItem() => _state.newItem();


  void dispose() {
    _state.dispose();
  }


}