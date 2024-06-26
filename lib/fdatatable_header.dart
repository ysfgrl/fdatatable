part of 'fdatatable.dart';

class FDTHeader<DType extends Object> extends StatelessWidget{
  const FDTHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<FDTNotifier<DType>>(
      builder: (context, state, child2) {
        return _buildRow(context, state);
      },
    );

  }

  Widget _buildRow(BuildContext context, FDTNotifier<DType> state){
    switch(state.size){
      case FDTSize.sm: return _expanded(context, state,  2);
      case FDTSize.md: return _expanded(context, state,  3);
      case FDTSize.lg: return _expanded(context, state,  4);
      case FDTSize.xl: return _expanded(context, state,  5);
      case FDTSize.xxl: return _expanded(context, state, state.columns.length);
    }
  }
  Widget _expanded(BuildContext context, FDTNotifier<DType> state, int size){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 65,),
        ...state.columns.getRange(0, size).map((column) {
          if(column.columnWidth!=null){
            return SizedBox(
              width: column.columnWidth,
              child: Text(column.title, style: Theme.of(context).textTheme.titleLarge,),
            );
          }else {
            return Expanded(
                child: Text(column.title, style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,)
            );
          }
        }),
          SizedBox(width: 60,),
    ]
    );
  }

}
