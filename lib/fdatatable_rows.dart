

import 'dart:async';

import 'package:fdatatable/constant.dart';
import 'package:fdatatable/fdatatable_notifier.dart';
import 'package:fdatatable/ftypes.dart';
import 'package:fdatatable/models/faction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FDataTableRows<DType extends Object> extends StatelessWidget{

  final List<FAction> rowActions;
  const FDataTableRows({super.key,
    required this.rowActions
  });
  @override
  Widget build(BuildContext context) {

    return Consumer<FDataTableNotifier<DType>>(
      builder: (context, state, child) {
        if(state.state == FTableState.error){
          return const Center(child: Text("error.",textAlign: TextAlign.center));
        }
        if(state.state == FTableState.loading){
          return const Center(
            child: AnimatedOpacity(
                opacity:  1 ,
                duration: Duration(milliseconds: 300),
                child: CircularProgressIndicator()
            ),
          );
        }
        return _buildRows(context, state);
      },
    );
  }

  Widget _buildRows(BuildContext context, FDataTableNotifier<DType> state){

    return ListView.separated(
        controller: state.rowsScrollController,
        separatorBuilder: (_, __) =>  Divider(height: 1,color: Theme.of(context).dividerColor),
        itemCount: state.fPageResponse.list.length,
        itemBuilder:(context, index) => AnimatedBuilder(
            animation: state.rowsScrollController,
          builder: (context, child) => _buildRow(context, state, index),
        ),
    );
  }

  Widget _buildRow(BuildContext context, FDataTableNotifier<DType> state, int index){
    Widget row = Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ...state.columns.map((column) => Expanded(
            flex: 1,
            child: column.cellBuilder(state.fPageResponse.list[index]),
          )),
        ],
      ),
    );

    row = Stack(
      children: [
        row,
        Positioned(
          right: 10,
          top: 0,
          child: Container(
              decoration:  BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black54)],
                  borderRadius: BorderRadius.all(Radius.circular(4))
              ),
            child: IconButton(
                onPressed: () {
                  showActionOverlay(context,state);
                },
                icon: Icon(Icons.format_list_numbered_rtl)
            ),
          ),
        )
      ],

    );
    return row;
  }



  Future<void> showActionOverlay(BuildContext context, FDataTableNotifier<DType> state) async {
    final RenderBox renderBox = context.findAncestorRenderObjectOfType() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var rect = RelativeRect.fromLTRB( offset.dx , offset.dy , offset.dx, 0);

    Widget layout = Material(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(10),
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

