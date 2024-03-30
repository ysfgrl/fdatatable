
part of '../fdatatable.dart';

enum FActionAxis{
  leftToRight,
  topToBottom,
  rightToLeft,
  bottomToTop
}

class FAction{
  final FDTActionTypes action;
  final Text? text;
  final Icon? icon;
  final FActionAxis axis;
  final String? toolTip;
  FAction({
    this.text,
    required this.action,
    this.icon,
    this.toolTip,
    this.axis = FActionAxis.leftToRight
  });
}


