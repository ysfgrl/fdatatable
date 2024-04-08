part of  'fdatatable.dart';

class FDTMenu extends StatelessWidget {
  const FDTMenu({
    super.key,
    required this.onSelected,
    required this.actions,
  } );

  final void Function(FDTActionTypes) onSelected;
  final List<FDTAction> actions;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FDTActionTypes>(
      tooltip: 'menu',
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (context) {
        return actions.map((e) => _buildAction(e)).toList();
      },
      child: const Icon(Icons.more_vert),
    );
  }

  PopupMenuEntry<FDTActionTypes> _buildAction(FDTAction action){
    return PopupMenuItem<FDTActionTypes>(
      height: 32,
      padding: EdgeInsets.only(left: 18, right: 18, bottom: 5),
      value: action.action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          action.icon,
          SizedBox(width: 10),
          Text(action.text),
        ],
      ),
    );
  }
}