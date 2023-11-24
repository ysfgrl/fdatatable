
part of '../fdatatable.dart';

enum FActionAxis{
  leftToRight,
  topToBottom,
  rightToLeft,
  bottomToTop
}

class FAction{
  final Text? text;
  final Icon? icon;
  final String key;
  final FActionAxis axis;
  final String? toolTip;
  FAction({
    this.text,
    required this.key,
    this.icon,
    this.toolTip,
    this.axis = FActionAxis.leftToRight
  });

}