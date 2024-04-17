
part of 'fdatatable.dart';

class FDTRow<DType extends Object> extends StatefulWidget {
  final FDTNotifier<DType> tableState;
  final int index;
  final List<FDTAction> rowActions;
  final FDTRowLoading<DType>? rowLoading;
  final bool expandableRow;
  const FDTRow({
    super.key,
    required this.tableState,
    required this.index,
    required this.rowActions,
    required this.expandableRow,
    this.rowLoading
  });
  @override
  State<FDTRow<DType>> createState() => _FDTRowState<DType>();

}

class _FDTRowState<DType extends Object> extends State<FDTRow<DType>> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTitle(context),
        if(widget.expandableRow)
        _buildBody(context)
      ],
    );
  }

  Widget _buildTitle(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          if(widget.rowLoading!=null)
            widget.rowLoading!(
                widget.tableState.responseModel.list[widget.index],
                (widget.index+1)*widget.tableState.responseModel.page
            ),
          SizedBox(width: 5,),
          Expanded(
            child: SizedBox(height: 20,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...widget.tableState.columns.where((element) => !element.isExpand).map((column) {
                    return Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: SizedBox(
                          width: column.columnWidth,
                          child: column.cellBuilder(widget.tableState.responseModel.list[widget.index])
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          if(widget.expandableRow)
          IconButton(
              onPressed: () {
                _isExpanded = !_isExpanded;
                if (_animation.status != AnimationStatus.completed) {
                  _controller.forward();
                } else {
                  _controller.animateBack(0, duration: Duration(seconds: 1));
                }
                setState(() {

                });
              },
              padding: EdgeInsets.all(3),
              constraints: BoxConstraints(),
              icon: _isExpanded ? Icon(Icons.keyboard_arrow_down_rounded) : Icon(Icons.keyboard_arrow_right_outlined)
          ),
          Visibility(
            visible: widget.rowActions.isNotEmpty,
            child: FDTMenu(
                onSelected: (e) => widget.tableState.actionCallBack(FActionResponse(action: e, item: widget.tableState.responseModel.list[widget.index])),
                actions: widget.rowActions
            ),
          ),
          SizedBox(width: 5,)
        ],
      ),
    );
  }

  AnimatedWidget _buildBody(BuildContext context){
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      child: Column(
        children: [
          Divider(),
          ...widget.tableState.columns.map((e) => ListTile(
            leading: Text(e.title, style: TextStyle(fontWeight: FontWeight.bold),),
            minLeadingWidth: 100,
            title: e.cellBuilder(widget.tableState.responseModel.list[widget.index]),
          )),
        ],
      ),
    );
  }
}