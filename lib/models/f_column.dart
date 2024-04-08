
part of '../fdatatable.dart';

class FDTBaseColumn<DType extends Object>{
  final String title;
  final FDTCellBuild<DType> cellBuilder;
  final bool isExpand;
  final double? columnWidth;
  final double inputHeight;
  FDTBaseColumn({
    required this.title,
    required this.cellBuilder,
    this.columnWidth,
    this.inputHeight = 50,
    this.isExpand = false
  });
}
