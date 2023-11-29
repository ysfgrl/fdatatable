part of 'fdatatable.dart';

class FDTTitle<DType extends Object> extends StatelessWidget{

  final List<FAction> topActions;
  final Text? title;
  final Icon? icon;
  final FDTTranslation translation;
  const FDTTitle({super.key,
    required this.topActions,
    required this.translation,
    this.title,
    this.icon
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<FDTNotifier<DType>>(
      builder: (context, tableState, child2) {
        return ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            tableState.openFilter(isExpanded);
          },
          children: [
            ExpansionPanel(
              isExpanded: tableState.isOpenFilter,
              headerBuilder: (context, isExpanded) => _titleWidget(context, tableState),
              body: _filterWidget(context, tableState)
            ),
          ],
        );
      },
    );
  }

  Widget _titleWidget(BuildContext context, FDTNotifier<DType> state){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Row(
            children: [
              icon==null ? const Icon(Icons.table_chart_outlined) : icon!,
              const SizedBox(width: 5,),
              title==null ? const Text("") : title!
            ],
          ),
          Expanded(
            child: _actions(state)
          )
        ],
      ),
    );
  }
  Widget _filterWidget(BuildContext context, FDTNotifier<DType> tableState){
    // return ChangeNotifierProvider<FDTFilterNotifier<DType>>(
    //   create:(context) => tableState.filterState,
    //   builder: (context, child) {
    //     var filterState = context.read<FDTFilterNotifier<DType>>();
    //
    //     return Center(
    //       child: SizedBox(
    //         height: _filterHeight(tableState.size, filterState.filters.length + 1, tableState.inputHeight),
    //         child: DecoratedBox(
    //           decoration: BoxDecoration(
    //               border: BorderDirectional(top: BorderSide(width: 1, color: Theme.of(context).dividerColor))
    //           ),
    //           child: Padding(
    //               padding: EdgeInsets.only(left: 10, right: 10),
    //               child: SingleChildScrollView(
    //                 child: FormBuilder(
    //                   key: filterState._formKey,
    //                   child: Column(
    //                     children: [
    //                       ...tableState.columns.where((value) => value.isFilter).map((entry){
    //                         return Column(
    //                           mainAxisAlignment: MainAxisAlignment.end,
    //                           children: [
    //                             entry.filterBuild(context),
    //                           ],
    //                         );
    //                       }),
    //                       OutlinedButton(
    //                           onPressed: () =>
    //                           {
    //                             tableState.saveFilter()
    //                           },
    //                           child: Text("Save")
    //                       ),
    //                     ] ,
    //                   ),
    //                 ),
    //               )
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );

    return ChangeNotifierProvider<FDTFilterNotifier<DType>>(
      create:(context) => tableState.filterState,
      builder: (context, child) {
        var filterState = context.read<FDTFilterNotifier<DType>>();

        return SizedBox(
          height: tableState.columns.any((element) => element.isFilter) ? _filterHeight(tableState.size, filterState.filters.length + 1, tableState.inputHeight): 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
                border: BorderDirectional(top: BorderSide(width: 1, color: Theme.of(context).dividerColor))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CustomScrollView(
                slivers: [
                  FormBuilder(
                      key: filterState._formKey,
                      child:  SliverVisibility(
                        visible: tableState.columns.any((element) => element.isFilter),
                        sliver: SliverGrid(
                          delegate: SliverChildListDelegate(
                              [
                                ...tableState.columns.where((value) => value.isFilter).map((entry){
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(child: entry.filterBuild(context)),
                                    ],
                                  );
                                }),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: OutlinedButton(
                                      onPressed: () =>
                                      {
                                        tableState.saveFilter()
                                      },
                                      child: Text(translation("fdt.filterBtn"))
                                  ),
                                )

                              ]
                          ),
                          gridDelegate:  _getCrossAxisCount(tableState),
                        )

                      ),
                      )
                ],
              )
            ),
          ),
        );
      },
    );

  }

  Widget _actions(FDTNotifier<DType> tableState){

    switch(tableState.size){
      case FDTSize.sm:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: topActions.map((action) => IconButton(
              tooltip: action.toolTip,
              splashRadius: 30,
              onPressed: () => tableState.actionCallBack(FActionResponse<DType>(key: action.key)),
              icon: action.icon!
          )).toList(),
        );
      case FDTSize.md:
      case FDTSize.lg:
      case FDTSize.xl:
      case FDTSize.xxl:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: topActions.map((action) => Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child:  OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                onPressed: () => tableState.actionCallBack(FActionResponse<DType>(key: action.key)),
                child: createAction(action)
            ),
          )).toList(),
        );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: topActions.map((action) => IconButton(
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),
          splashRadius: 20,
          onPressed: () => tableState.actionCallBack(FActionResponse<DType>(key: action.key)),
          icon: createAction(action)
      )).toList(),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: topActions.map((action) => OutlinedButton(
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),
          onPressed: () => tableState.actionCallBack(FActionResponse<DType>(key: action.key)),
          child: createAction(action)
      )).toList(),
    );
  }
  double _filterHeight(FDTSize size, int filterSize, double inputHeight){
    double height = 300;
    switch(size){
      case FDTSize.sm:
        if(filterSize <= 5){
          height = filterSize*inputHeight + 20;
        }
      case FDTSize.md:
        if(filterSize <= 10){
          height = (filterSize/2).ceil()*inputHeight + 20;
        }
      case FDTSize.lg:
        if(filterSize <= 15){
          height = (filterSize/3).ceil()*inputHeight  + 20;
        }
      case FDTSize.xl:
        if(filterSize <= 20){
          height = (filterSize/4).ceil()*inputHeight + 20;
        }
      case FDTSize.xxl:
        if(filterSize <= 25){
          height = (filterSize/5).ceil()*inputHeight + 20;
        }
    }
    return height;
  }

  SliverGridDelegateWithFixedCrossAxisCount _getCrossAxisCount(FDTNotifier state){
    switch(state.size){
      case FDTSize.sm:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: state.width/state.inputHeight,
        );
      case FDTSize.md:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: (state.width/2)/state.inputHeight,
        );
      case FDTSize.lg:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: (state.width/3)/state.inputHeight,
        );
      case FDTSize.xl:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: (state.width/4)/state.inputHeight,
        );
      case FDTSize.xxl:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: (state.width/5)/state.inputHeight,
        );
    }
  }
}