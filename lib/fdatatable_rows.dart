
part of 'fdatatable.dart';

class FDTRows<DType extends Object> extends StatelessWidget{
  final List<FDTAction> rowActions;
  final FDTRowLoading<DType>? rowLoading;
  final FDTTranslation translation;
  const FDTRows({super.key,
    required this.rowActions,
    required this.translation,
    this.rowLoading,
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<FDTNotifier<DType>>(
      builder: (context, state, child) {
        if(state.state == FDTState.error){
          return Center(child: Text(translation("fdt.tableError") , textAlign: TextAlign.center));
        }
        if(state.state == FDTState.loading){
          return const Center(
            child: AnimatedOpacity(
                opacity:  1 ,
                duration: Duration(milliseconds: 300),
                child: CircularProgressIndicator()
            ),
          );
        }
        return Stack(
          fit: StackFit.loose,
          children: [
            ListView.separated(
              controller: state.rowsScrollController,
              separatorBuilder: (BuildContext context, int index) =>  Divider(height: 1,color: Theme.of(context).dividerColor),
              itemCount: state.responseModel.list.length,
              itemBuilder:(context, index) => AnimatedBuilder(
                animation: state.rowsScrollController,
                builder: (context, child){
                  return FDTRow<DType>(tableState: state, index: index, rowActions: rowActions,rowLoading: rowLoading,);
                  // switch(state.size){
                  //   case FDTSize.sm: return FDTRow(tableState: state, index: index);
                  //   case FDTSize.md: return FDTRow(tableState: state, index: index);
                  //   case FDTSize.lg: return FDTRow(tableState: state, index: index);
                  //   case FDTSize.xl: return FDTRow(tableState: state, index: index);
                  //   case FDTSize.xxl: return FDTRow(tableState: state, index: index);
                  // }
                },
              ),
            )
          ],
        );
      },
    );
  }


}