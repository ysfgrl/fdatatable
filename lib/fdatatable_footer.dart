

import 'package:fdatatable/constant.dart';
import 'package:fdatatable/fdatatable_notifier.dart';
import 'package:fdatatable/ftypes.dart';
import 'package:fdatatable/models/faction.dart';
import 'package:fdatatable/models/faction_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FDataTableFooter<DType extends Object> extends StatelessWidget{

  final List<FAction> bottomActions;
  final FTranslation translation;
  const FDataTableFooter({super.key,
    required this.bottomActions,
    required this.translation
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FDataTableNotifier<DType>>(
      builder: (context, state, child) {
        Widget child = Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: bottomActions.map((e) => createAction(state, e),).toList(),
                ),
              ),
              Row(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(translation("f.pageSize")),
                      const SizedBox(width: 10),
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 70, maxHeight: 30),
                          child: DropdownButtonFormField<int>(
                            value: 10,
                            decoration: const InputDecoration(
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 8),
                                border: OutlineInputBorder()),
                            style: const TextStyle(fontSize: 14),
                            onChanged:(value) => state.setPageSize(value!),
                            items: const [
                              DropdownMenuItem(value: 10,child: Text("10"),),
                              DropdownMenuItem(value: 20,child: Text("20"),),
                              DropdownMenuItem(value: 50,child: Text("50"),),
                              DropdownMenuItem(value: 100,child: Text("100"),),
                            ],
                          )
                      )
                    ],
                  ),
                  SizedBox(width: 10,),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(translation("f.page")),
                          Text(state.fPageResponse.page.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text(translation("f.total")),
                          Text(state.fPageResponse.total.toString()),
                        ],
                      )
                    ],
                  ),
                  SizedBox(width: 5,),
                  IconButton(
                    tooltip: translation("f.previous"),
                    splashRadius: 20,
                    icon: Icon(Icons.keyboard_arrow_left_rounded,),
                    onPressed:() => state.previousPage(),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: translation("f.next"),
                    splashRadius: 20,
                    icon: Icon(Icons.keyboard_arrow_right_rounded,),
                    onPressed: () => state.nextPage(),
                  )
                ],
              )
            ],
          ),
        );
        return child;
      },
    );
  }

}