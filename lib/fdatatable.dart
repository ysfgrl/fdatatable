library fdatatable;

import 'dart:async';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/intl_standalone.dart'
// if (dart.library.html) 'package:intl/intl_browser.dart';

part 'constant.dart';
part 'ftypes.dart';
part 'models/f_action.dart';
part 'models/f_column.dart';
part 'models/f_filter.dart';
part 'models/faction_response.dart';
part 'models/fpage_request.dart';
part 'models/fpage_response.dart';
part 'fdatatable_controller.dart';
part 'fdatatable_notifier.dart';
part 'fdatatable_rows.dart';
part 'fdatatable_row.dart';
part 'fdatatable_header.dart';
part 'fdatatable_title.dart';
part 'fdatatable_footer.dart';
part 'fdatatable_menu.dart';


class FDT<DType extends Object> extends StatelessWidget {
  final FDTController<DType>? controller;
  final FDTRequest<DType> fdtRequest;
  final FDTRowLoading? fdtRowLoading;
  final FActionCallBack<DType> actionCallBack;
  final FDTTranslation translation;
  final List<FDTBaseColumn<DType>> columns;
  final List<FDTFilter<Object>> filters;
  final List<FDTAction> topActions;
  final List<FDTAction> rowActions;
  final Text? title;
  final Icon? icon;
  final int firstPage;
  final int pageSize;
  final bool showHeader;
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
    this.filters = const [],
    this.translation = defaultTranslation,
    this.firstPage = 1,
    this.pageSize = 10,
    this.showHeader = true,
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
          filters: {for (var v in filters) v.key: v.val},
        ),
        filters: filters
      ),
      builder: (context, child) {
        var state = context.read<FDTNotifier<DType>>();
        return  Card(
          child: LayoutBuilder(
            builder: (context, constraints) {
              state.setWidth(constraints.maxWidth);
              return Column(
                key: state.tableKey,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(30),),
                    child: FDTTitle<DType>(
                      topActions: topActions,
                      title: title,
                      icon: icon,
                      translation: translation,
                    ),
                  ),
                  Divider(height: 1, color: Theme.of(context).dividerColor,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: FDTRows<DType>(
                        rowActions: rowActions,
                        translation: translation,
                        rowLoading: fdtRowLoading,
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

