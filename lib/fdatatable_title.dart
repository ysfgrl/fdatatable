part of 'fdatatable.dart';

class FDTTitle<DType extends Object> extends StatelessWidget{

  final List<FAction> topActions;
  final Text? title;
  final Icon? icon;
  const FDTTitle({super.key,
    required this.topActions,
    this.title,
    this.icon
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<FDTNotifier<DType>>(
      builder: (context, state, child2) {
        return ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
              state.openFilter(isExpanded);
          },
          children: [
            ExpansionPanel(
              isExpanded: state.isOpenFilter,
              headerBuilder: (context, isExpanded) => _titleWidget(context, state),
              body: _filterWidget(context, state)
            ),
          ],
        );
      },
    );
  }

  Widget _titleWidget(BuildContext context, FDTNotifier<DType> state){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Row(
            children: [
              if(icon!=null)
                icon!,
              const SizedBox(width: 5,),
              if(title!=null)
                title!
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment:MainAxisAlignment.end,
              children: topActions.map((e) => createAction(state, e),).toList(),
            ),
          )
        ],
      ),
    );
  }
  Widget _filterWidget(BuildContext context, FDTNotifier state){
    return _sizedBox(state, DecoratedBox(
        decoration: BoxDecoration(
            border: BorderDirectional(top: BorderSide(width: 1, color: Theme.of(context).dividerColor))
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                delegate: SliverChildListDelegate(
                    state.filters.entries.map((entry){
                      return Column(
                        children: [
                          Expanded(child: entry.value.build(context, state)),
                        ],
                      );
                    }).toList()
                ),
                gridDelegate:  _getCrossAxisCount(state),
              )
            ],
          ),
        )
    ));
  }

  SizedBox _sizedBox(FDTNotifier state, Widget child){
    double height = 300;
    switch(state.size){
      case FDTSize.sm:
        if(state.filters.length <= 5){
          height = state.filters.length*state.inputHeight + 20;
        }
      case FDTSize.md:
        if(state.filters.length <= 10){
          height = (state.filters.length/2).ceil()*state.inputHeight + 20;
        }
      case FDTSize.lg:
        if(state.filters.length <= 15){
          height = (state.filters.length/3).ceil()*state.inputHeight  + 20;
        }
      case FDTSize.xl:
        if(state.filters.length <= 20){
          height = (state.filters.length/4).ceil()*state.inputHeight + 20;
        }
      case FDTSize.xxl:
        if(state.filters.length <= 25){
          height = (state.filters.length/5).ceil()*state.inputHeight + 20;
        }
    }
    return SizedBox(
      height: height,
      child: child,
    );
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