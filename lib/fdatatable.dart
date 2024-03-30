library fdatatable;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';



export 'package:flutter_form_builder/src/fields/form_builder_date_time_picker.dart';
export 'package:flutter_form_builder/src/form_builder_field_option.dart';

part 'constant.dart';
part 'ftypes.dart';
part 'models/f_action.dart';
part 'models/f_column.dart';
part 'models/faction_response.dart';
part 'models/fpage_request.dart';
part 'models/fpage_response.dart';
part 'fdatatable_controller.dart';
part 'fdatatable_notifier.dart';
part 'fdatatable_rows.dart';
part 'fdatatable_header.dart';
part 'fdatatable_title.dart';
part 'fdatatable_footer.dart';
part 'fdatatable_form.dart';
part 'fdatatable_form_notifier.dart';
part 'fdatatable_filter_notifier.dart';


class FDT<DType extends Object> extends StatelessWidget {
  final FDTController<DType>? controller;
  final FDTRequest<DType> fdtRequest;
  final FDTRowLoading? fdtRowLoading;
  final FActionCallBack<DType> actionCallBack;
  final FDTTranslation translation;

  final List<FDTBaseColumn<DType,dynamic >> columns;
  final List<FAction> topActions;
  final List<FAction> rowActions;
  final Text? title;
  final Icon? icon;
  final int firstPage;
  final int pageSize;
  const FDT({
    super.key,
    required this.fdtRequest,
    required this.columns,
    required this.actionCallBack,
    this.controller,
    this.fdtRowLoading,
    this.title,
    this.icon,
    this.topActions = const [],
    this.rowActions = const [],
    this.translation = defaultTranslation,
    this.firstPage = 1,
    this.pageSize = 10
  });

  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FDTNotifier<DType>>(
      create: (context) => FDTNotifier(
        controller: controller,
        fdtRequest: fdtRequest,
        actionCallBack: actionCallBack,
        columns: columns,
        requestModel: FDTRequestModel(
          page: firstPage,
          pageSize: pageSize,
          filters: {for (var v in columns.where((value) => value.isFilter)) v.key: null}
        ),
        filterState: FDTFilterNotifier<DType>(
          filters: {for (var v in columns.where((value) => value.isFilter)) v.key: null}
        ),
        formState: FDTFormNotifier<DType>()
      ),
      builder: (context, child) {
        var state = context.read<FDTNotifier<DType>>();
        return  Material(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              side: BorderSide(color: Color(0xffDADCE0))
          ),
          elevation: 10,
          child: LayoutBuilder(
            builder: (context, constraints) {
              state.setWidth(constraints.maxWidth);
              return Column(
                key: state.tableKey,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(30),
                    ),
                    child: FDTTitle<DType>(
                      topActions: topActions,
                      title: title,
                      icon: icon,
                      translation: translation,
                    ),
                  ),
                  // const Divider(height: 1),
                  // DecoratedBox(
                  //   decoration: BoxDecoration(
                  //
                  //       // boxShadow: const <BoxShadow>[
                  //       //   BoxShadow(
                  //       //     blurRadius: 10.0,
                  //       //     spreadRadius: -10.0,
                  //       //     offset: Offset(0.0, 10.0),
                  //       //   )
                  //       // ],
                  //
                  //       color: Theme.of(context).primaryColor.withAlpha(10),
                  //   ),
                  //
                  //   child: FDTHeader<DType>(),
                  // ),

                  Divider(height: 1,),

                  Expanded(
                    child: Material(
                      child: DecoratedBox(
                        decoration: BoxDecoration(

                        ),

                        child: FDTRows<DType>(
                          rowActions: rowActions,
                          translation: translation,
                          rowLoading: fdtRowLoading,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(30),
                    ),
                    child: FDTFooter<DType>(
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

