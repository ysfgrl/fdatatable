

import 'package:fdatatable/constant.dart';
import 'package:fdatatable/fdatatable_notifier.dart';
import 'package:fdatatable/models/faction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FDataTableTitle<DType extends Object> extends StatelessWidget{

  final List<FAction> topActions;
  final Text? title;
  final Icon? icon;
  const FDataTableTitle({super.key,
    required this.topActions,
    this.title,
    this.icon
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<FDataTableNotifier<DType>>(
      builder: (context, state, child2) {
        Widget child = Padding(
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
        return child;
      },
    );
  }
}