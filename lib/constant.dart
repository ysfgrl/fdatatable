
import 'package:fdatatable/fdatatable_notifier.dart';
import 'package:fdatatable/models/faction.dart';
import 'package:fdatatable/models/faction_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget createAction<DType extends Object>(FDataTableNotifier<DType> state, FAction action){

  Widget child;
  if(action.icon != null && action.text != null) {
    if(action.axis == FActionAxis.leftToRight){
      child = Row(
        children: [
          action.icon!,
          const SizedBox(width: 5,),
          action.text!
        ],
      );
    }else if(action.axis == FActionAxis.rightToLeft){
      child = Row(
        children: [
          action.text!,
          const SizedBox(width: 5,),
          action.icon!
        ],
      );
    }else if(action.axis == FActionAxis.topToBottom){
      child = Column(
        children: [
          action.icon!,
          const SizedBox(height: 5,),
          action.text!
        ],
      );
    }else{
      child = Column(
        children: [
          action.text!,
          const SizedBox(height: 5,),
          action.icon!
        ],
      );
    }

  }else if(action.icon != null){
    child=action.icon!;
  }else if(action.text != null){
    child = action.text!;
  }else{
    child = Text("");
  }
  if(action.toolTip != null){
    child = Tooltip(
      message: "tooltip",
      child: child,
    );
  }
  return OutlinedButton(
      style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
      onPressed: () => state.actionCallBack(FActionResponse(key: action.key)),
      child: child
  );

}


class FDataTableDialog<DType extends Object> extends StatelessWidget {
  final RelativeRect rect;
  final FDataTableNotifier<DType> state;
  final Widget layout;
  const FDataTableDialog({
    required this.rect,
    required this.state,
    required this.layout});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
            top: rect.top,
            right: rect.right,
            left: rect.left,
            child:  layout
        ),
      ],
    );
  }
}
