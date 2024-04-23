part of 'fdatatable.dart';

class FDTTitle<DType extends Object> extends StatelessWidget{


  final List<FDTAction> topActions;
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
        return Column(
          children: [
            _titleWidget(context, tableState),
            if(tableState.isOpenFilter && tableState.filters.isNotEmpty)
              ...[
                _filterWidget(context, tableState),
                const Divider(),
                Visibility(
                  visible: tableState.isOpenFilter && tableState.filters.isNotEmpty,
                  child: Row(
                    mainAxisAlignment:  MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, right: 5),
                        child: OutlinedButton(
                            onPressed: () =>
                            {
                              tableState.saveFilter()
                            },
                            child: Text(translation("fdt.filterBtn"))
                        ),
                      ),
                    ],
                  ) ,
                )
              ],
          ],
        );
      },
    );
  }

  Widget _titleWidget(BuildContext context, FDTNotifier<DType> state){
    return  DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
        ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
                child: Row(
                  children: [
                    icon==null ? const Icon(Icons.table_chart_outlined) : icon!,
                    const SizedBox(width: 5,),
                    title==null ? const Text("") : title!
                  ],
                )
            ),
            if(state.filters.isNotEmpty)
              IconButton(
                  tooltip: "Filter",
                  padding: EdgeInsets.all(3),
                  constraints: BoxConstraints(),
                  onPressed: () {
                    state.openFilter(!state.isOpenFilter);
                  },
                  icon: Icon(Icons.filter_alt_outlined)
              ),
            if(topActions.isNotEmpty)
              _actions(state),
          ],
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(10),
    //   child: Row(
    //     children: [
    //       Row(
    //         children: [
    //           icon==null ? const Icon(Icons.table_chart_outlined) : icon!,
    //           const SizedBox(width: 5,),
    //           title==null ? const Text("") : title!
    //         ],
    //       ),
    //       Expanded(
    //         child: _actions(state)
    //       )
    //     ],
    //   ),
    // );
  }
  Widget _filterWidget(BuildContext context, FDTNotifier<DType> tableState){

    return SizedBox(
      height: _filterHeight(tableState, 310, 75),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: BorderDirectional(top:
            BorderSide(width: 1, color: Theme.of(context).dividerColor)
            )
        ),
        child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: CustomScrollView(
              slivers: [
                SliverVisibility(
                    visible: tableState.filters.isNotEmpty,
                    sliver: SliverGrid(
                      delegate: SliverChildListDelegate(
                          tableState.filters.map((entry){
                            return Padding(
                              padding: EdgeInsets.all(5),
                              child: entry.filterBuild(context),
                            );
                          }).toList()
                      ),
                      // gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
                      //   maxCrossAxisExtent: 300,
                      //   mainAxisSpacing: 5.0,
                      //   crossAxisSpacing: 5.0,
                      //   mainAxisExtent: 50
                      // ),
                      gridDelegate:  _getCrossAxisCount(tableState),
                    )

                )
              ],
            )
        ),
      ),
    );
  }

  Widget _actions(FDTNotifier<DType> tableState){

    switch(tableState.size){
      case FDTSize.sm:
        return FDTMenu(onSelected: (p0) => tableState.actionCallBack(FActionResponse<DType>(action: p0)), actions: topActions);
      case FDTSize.md:
      case FDTSize.lg:
      case FDTSize.xl:
      case FDTSize.xxl:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: topActions.map((action) => Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child:  IconButton(
                onPressed: () => tableState.actionCallBack(FActionResponse<DType>(action: action.action)),
                icon: action.icon,
                padding: EdgeInsets.all(3),
                constraints: BoxConstraints(),
                tooltip: action.text,
            ),
          )).toList(),
        );
    }
  }
  double _filterHeight(FDTNotifier<DType> tableState, double inputWidth, double inputHeight){
    double height = 75;
    int filterSize = tableState.filters.length;

    switch(tableState.size){
      case FDTSize.sm:
        if(filterSize <= 2){
          height = inputHeight * 1;
        }else{
          height = inputHeight * 2;
        }
      case FDTSize.md:
        if(filterSize <= 3){
          height = inputHeight * 1;
        }else {
          height = inputHeight * 2;
        }
      case FDTSize.lg:
        if(filterSize <= 4){
          height = inputHeight * 1;
        }else {
          height = inputHeight * 2;
        }
      case FDTSize.xl:
        if(filterSize <= 5){
          height = inputHeight * 1;
        }else {
          height = inputHeight * 2;
        }
      case FDTSize.xxl:
        if(filterSize <= 6){
          height = inputHeight * 1;
        }else {
          height = inputHeight * 2;
        }
    }
    return height;
  }

  SliverGridDelegateWithFixedCrossAxisCount _getCrossAxisCount(FDTNotifier state){
    switch(state.size){
      case FDTSize.sm:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          // childAspectRatio: state.width/state.inputHeight,
          mainAxisExtent: 70
        );
      case FDTSize.md:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          // childAspectRatio: (state.width/2)/state.inputHeight,
            mainAxisExtent: 70
        );
      case FDTSize.lg:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          // childAspectRatio: (state.width/3)/state.inputHeight,
            mainAxisExtent: 70
        );
      case FDTSize.xl:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          // childAspectRatio: (state.width/4)/state.inputHeight,
            mainAxisExtent: 70
        );
      case FDTSize.xxl:
        return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          // childAspectRatio: (state.width/5)/state.inputHeight,
            mainAxisExtent: 70
        );
    }
  }
}