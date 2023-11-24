
part of 'fdatatable.dart';

class FDTRows<DType extends Object> extends StatelessWidget{

  final List<FAction> rowActions;
  const FDTRows({super.key,
    required this.rowActions
  });
  @override
  Widget build(BuildContext context) {

    return Consumer<FDTNotifier<DType>>(
      builder: (context, state, child) {
        if(state.state == FDTState.error){
          return const Center(child: Text("error.",textAlign: TextAlign.center));
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
            _buildRows(context, state),
            AnimatedPositioned(
              left: state.state == FDTState.adding ? 0 : -state.width,
              right: state.state == FDTState.adding ? 0 : state.width,
              top: 0 ,
              bottom: 0 ,
              duration: Duration(milliseconds: 500),
              child: FDTForm<DType>(formType: FDTFormType.add),
            )
          ],
        );
      },
    );
  }

  Widget _buildRows(BuildContext context, FDTNotifier<DType> state){

    return ListView.separated(
        controller: state.rowsScrollController,

        separatorBuilder: (_, __) =>  Divider(height: 1,color: Theme.of(context).dividerColor),
        itemCount: state.responseModel.list.length,
        itemBuilder:(context, index) => AnimatedBuilder(
            animation: state.rowsScrollController,
          builder: (context, child) => _buildRow(context, state, index),
        ),
    );
  }



  Widget _buildRow(BuildContext context, FDTNotifier<DType> state, int index){
    switch(state.size){
      case FDTSize.sm: return _expanded(context, state, index, 2);
      case FDTSize.md: return _expanded(context, state, index, 3);
      case FDTSize.lg: return _expanded(context, state, index, 4);
      case FDTSize.xl: return _expanded(context, state, index, 5);
      case FDTSize.xxl: return _expanded(context, state, index, 10);
    }
  }
  Widget _expanded(BuildContext context, FDTNotifier<DType> state, int index, int size){
      return ExpansionTile(
        leading: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2)),
            child: CircleAvatar(
              radius: 15,
              child: Text(((index+1) + ((state.responseModel.page-1)*state.responseModel.pageSize)).toString()),
            )
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...state.columns.getRange(0, size).takeWhile((element) => element.visible).map((column) {
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
          ...state.columns.getRange(size, state.columns.length).map((e) => ListTile(
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
              ...rowActions.map((e) => createAction<DType>(state, e))
            ],
          ),
          SizedBox(height: 10,)
        ],
      );
  }


  Future<void> showActionOverlay(BuildContext context, FDTNotifier<DType> state) async {
    final RenderBox renderBox = context.findAncestorRenderObjectOfType() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var rect = RelativeRect.fromLTRB( offset.dx , offset.dy , offset.dx, 0);

    Widget layout = Material(
      //shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      color: Colors.transparent,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...rowActions.map((e) => createAction<DType>(state, e)),
              ],
            ),
          )
        ],
      ),
    );
    await showDialog(
        context: context,
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (context) => FDataTableDialog(rect: rect, state: state, layout: layout,));
  }

}

