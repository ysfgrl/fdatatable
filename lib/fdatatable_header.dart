
import 'package:fdatatable/fdatatable_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FDataTableHeader<DType extends Object> extends StatelessWidget{
  const FDataTableHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<FDataTableNotifier<DType>>(
      builder: (context, state, child2) {

        return Row(
          children: [
            ...state.columns.map((e) {
              return Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(e.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis
                  ),
                ),
              );
            })
          ],
        );
      },
    );

  }
}
