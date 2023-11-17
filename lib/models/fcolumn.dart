
import 'package:flutter/cupertino.dart';

class BaseColumn<DType extends Object>{
  final String title;
  final Widget Function(DType item) cellBuilder;
  const BaseColumn({
    required this.title,
    required this.cellBuilder,
  });
}
