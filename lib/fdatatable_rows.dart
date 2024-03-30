
part of 'fdatatable.dart';

class FDTRows<DType extends Object> extends StatelessWidget{
  final List<FAction> rowActions;
  final FDTRowLoading? rowLoading;
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
        if (state.state == FDTState.form){
          SchedulerBinding.instance.addPostFrameCallback((_) => FDTDialog.showFTDDialog(state.tableKey.currentContext!, FDTForm<DType>(tableState: state, translation: translation,)));
          state.state = FDTState.building;
        }
        return Stack(
          fit: StackFit.loose,
          children: [
            _buildRows(state),
            // AnimatedPositioned(
            //   left: state.state == FDTState.adding ? 0 : -state.width,
            //   right: state.state == FDTState.adding ? 0 : state.width,
            //   top: 0 ,
            //   bottom: 0 ,
            //   duration: Duration(milliseconds: 500),
            //   child: FDTForm<DType>(key: state.formState.rebuildKey,),
            // )
          ],
        );
      },
    );
  }

  Widget _buildRows(FDTNotifier<DType> state){
    return ListView.separated(
        controller: state.rowsScrollController,
        separatorBuilder: (BuildContext context, int index) =>  Divider(height: 1,color: Theme.of(context).dividerColor),
        itemCount: state.responseModel.list.length,
        itemBuilder:(context, index) => AnimatedBuilder(
            animation: state.rowsScrollController,
          builder: (context, child){
            switch(state.size){
              case FDTSize.sm: return _buildRow(state, index, 2);
              case FDTSize.md: return _buildRow(state, index, 3);
              case FDTSize.lg: return _buildRow(state, index, 4);
              case FDTSize.xl: return _buildRow(state, index, 5);
              case FDTSize.xxl: return _buildRow(state, index, state.columns.length);
            }
          },
        ),
    );
  }

  Widget _buildRow(FDTNotifier<DType> state, int index, int size){
      return ExpansionTile(
        leading: rowLoading != null ? rowLoading!((index+1) + ((state.responseModel.page-1)*state.responseModel.pageSize)) : null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...state.columns.getRange(0, size).where((element) => element.visible).map((column) {
              if(column.columnWidth != null){
                return SizedBox(
                  width: column.columnWidth!,
                  child: column.cellBuilder != null
                      ? column.cellBuilder!(state.responseModel.list[index])
                      : Text(column.getter(state.responseModel.list[index]).toString()),
                );
              }else{
                return Expanded(
                  child: column.cellBuilder != null
                      ? column.cellBuilder!(state.responseModel.list[index])
                      : Text(column.getter(state.responseModel.list[index]).toString()),
                );
              }

            }),
          ],
        ),
        children: [
          Divider(height: 1,),
          SizedBox(height: 5,),
          ...state.columns.where((element) => element.visible).map((e) => ListTile(
            leading: Text(e.title, style: TextStyle(fontWeight: FontWeight.bold),),
            minLeadingWidth: 100,
            title: e.cellBuilder != null
                ? e.cellBuilder!(state.responseModel.list[index])
                : Text(e.getter(state.responseModel.list[index]).toString()),
          )),
          Divider(height: 1,),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...rowActions.map((e) => Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    onPressed: () => state.actionCallBack(FActionResponse<DType>(action: e.action, index: index)),
                    child: createAction(e)
                ),
              ))
            ],
          ),
          SizedBox(height: 10,)
        ],
      );
  }

}

