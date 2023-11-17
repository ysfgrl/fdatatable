library fdatatable;

import 'package:fdatatable/models/faction.dart';
import 'package:fdatatable/models/fcolumn.dart';
import 'package:fdatatable/fdatatable_controller.dart';
import 'package:fdatatable/fdatatable_footer.dart';
import 'package:fdatatable/fdatatable_header.dart';
import 'package:fdatatable/fdatatable_notifier.dart';
import 'package:fdatatable/fdatatable_rows.dart';
import 'package:fdatatable/fdatatable_title.dart';
import 'package:fdatatable/ftypes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FDataTable<DType extends Object> extends StatelessWidget {
  final FDataTableController<DType> controller;
  final PageRequest<DType> pageRequest;
  final FActionCallBack<DType> actionCallBack;
  final FTranslation translation;

  final List<BaseColumn<DType>> columns;
  final List<FAction> topActions;
  final List<FAction> bottomActions;
  final List<FAction> rowActions;
  final Text? title;
  final Icon? icon;

  const FDataTable({
    super.key,
    required this.controller,
    required this.pageRequest,
    required this.columns,
    required this.actionCallBack,
    this.title,
    this.icon,
    this.topActions = const [],
    this.bottomActions = const [],
    this.rowActions = const [],
    this.translation = defaultTranslation
  });

  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FDataTableNotifier<DType>>(
      create: (context) => FDataTableNotifier(
        controller: controller,
        pageRequest: pageRequest,
        actionCallBack: actionCallBack,
        columns: columns,
      ),
      builder: (context, child) {
        var state = context.read<FDataTableNotifier<DType>>();
        return  Material(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              side: BorderSide(color: Color(0xffDADCE0))
          ),
          elevation: 10,
          child: LayoutBuilder(
            builder: (context, constraints) {
              state.maxWidth = constraints.maxWidth;
              return Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(30),
                    ),
                    child: FDataTableTitle<DType>(
                      topActions: topActions,
                      title: title,
                      icon: icon,
                    ),
                  ),
                  const Divider(height: 1),
                  DecoratedBox(
                    decoration: BoxDecoration(

                        // boxShadow: const <BoxShadow>[
                        //   BoxShadow(
                        //     blurRadius: 10.0,
                        //     spreadRadius: -10.0,
                        //     offset: Offset(0.0, 10.0),
                        //   )
                        // ],
                        color: Theme.of(context).primaryColor.withAlpha(10),
                    ),

                    child: FDataTableHeader<DType>(),
                  ),
                  Divider(height: 1,),

                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(

                      ),
                      child: FDataTableRows<DType>(
                        rowActions: rowActions,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(30),
                    ),
                    child: FDataTableFooter<DType>(
                      bottomActions: bottomActions,
                      translation: translation,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}