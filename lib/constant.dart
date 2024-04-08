part of 'fdatatable.dart';

// Widget createAction<DType extends Object>(FDTAction action){
//
//   Widget child;
//   if(action.icon != null && action.text != null) {
//     if(action.axis == FActionAxis.leftToRight){
//       child = Row(
//         children: [
//           action.icon!,
//           const SizedBox(width: 5,),
//           action.text!
//         ],
//       );
//     }else if(action.axis == FActionAxis.rightToLeft){
//       child = Row(
//         children: [
//           action.text!,
//           const SizedBox(width: 5,),
//           action.icon!
//         ],
//       );
//     }else if(action.axis == FActionAxis.topToBottom){
//       child = Column(
//         children: [
//           action.icon!,
//           const SizedBox(height: 5,),
//           action.text!
//         ],
//       );
//     }else{
//       child = Column(
//         children: [
//           action.text!,
//           const SizedBox(height: 5,),
//           action.icon!
//         ],
//       );
//     }
//
//   }else if(action.icon != null){
//     child=action.icon!;
//   }else if(action.text != null){
//     child = action.text!;
//   }else{
//     child = Text("");
//   }
//   if(action.toolTip != null){
//     child = Tooltip(
//       message: action.toolTip,
//       child: child,
//     );
//   }
//   return child;
//
// }


class FDTDialog extends StatelessWidget {
  final double? width;
  final double? height;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final Widget layout;
  const FDTDialog({super.key,
    required this.layout,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.height,
  });

  static Future<void> showFTDDialog(BuildContext context, Widget layout) async{
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;
    // var rect = RelativeRect.fromLTRB(offset.dx , offset.dy , offset.dx, 0);

    await showGeneralDialog(
        barrierColor: Colors.transparent,
        transitionBuilder: (context, a1, a2, widget) {
          return Center(
            child: FDTDialog(
              layout: widget,
              top: offset.dy,
              left: offset.dx-size.width*(1-a1.value),
              width: size.width,
              height: size.height,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500), // DURATION FOR ANIMATION
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return layout;
        });

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
            top: top,
            right: right,
            left: left,
            bottom: bottom,
            width: width,
            height: height,
            child: layout
        ),
      ],
    );
  }
}