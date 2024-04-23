
part of '../fdatatable.dart';



abstract class FDTFilter<FType extends Object>{
  final String key;
  late FType? val;
  final InputDecoration decoration;
  final TextStyle? textStyle;
  FDTFilter({
    required this.key,
    this.val,
    this.decoration = const InputDecoration(),
    this.textStyle
  });
  Widget filterBuild(BuildContext context);
}

class FDTTextFilter extends FDTFilter<String>{
  FDTTextFilter({
    required super.key,
    super.val,
    super.textStyle,
    super.decoration
  });
  @override
  Widget filterBuild(BuildContext context) {
    return  TextFormField(
      initialValue: val,
      onChanged: (value) {
        val = value;
      },
      autocorrect: false,
      style: textStyle,
      decoration: decoration,
    );
  }
}
class FDTIntFilter extends FDTFilter<int>{

  final int min;
  final int max;
  FDTIntFilter({
    required super.key,
    super.val,
    super.textStyle,
    super.decoration,
    this.min = 0,
    this.max = 100,
  });

  @override
  Widget filterBuild(BuildContext context) {
    return TextFormField(
      initialValue: val?.toString(),
      onChanged: (value) {
        val = int.parse(value);
      },
      autocorrect: false,
      style: textStyle,
      decoration: decoration,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }
}

class CheckboxFormField extends StatefulWidget {

  final bool val;
  final String inputKey;
  final InputDecoration decoration;
  final ValueChanged<bool> onChanged;
  const CheckboxFormField({
    super.key,
    required this.val,
    required this.inputKey,
    required this.decoration,
    required this.onChanged,
  });
  @override
  State<StatefulWidget> createState() => _CheckboxFormField();
}



class _CheckboxFormField extends State<CheckboxFormField>{
  late bool val;
  @override
  void initState() {
    super.initState();
    val = widget.val;
  }
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: widget.decoration,
      child: CheckboxListTile(
          value: val,
          title: Text(widget.inputKey,),
          onChanged: (value) {
            if(value == null) return;
            val = value;
            setState(() {

            });
            widget.onChanged(val);
          }
      ),
    );
  }
}

class FDTCheckboxFilter extends FDTFilter<bool>{

  FDTCheckboxFilter({
    super.val,
    required super.key,
    super.decoration,
  });

  @override
  Widget filterBuild(BuildContext context) {
    return CheckboxFormField(
      decoration: decoration,
        val: val==null ? false : val!,
        inputKey: key,
        onChanged: (value) => val = value
    );
  }
}

class DropDownFormField<VType extends Object> extends StatefulWidget {

  final VType? val;
  late List<DropdownMenuItem<VType>> items;
  final InputDecoration decoration;
  final ValueChanged<VType?> onChanged;
  final FDTDropDownItemBuild<VType>? itemBuilder;
  final FDTDropDownSetItems<VType> setItems;
  DropDownFormField({
    super.key,
    required this.val,
    required this.items,
    required this.decoration,
    required this.onChanged,
    required this.setItems,
    this.itemBuilder
  });
  @override
  State<StatefulWidget> createState() => _DropDownFormField<VType>();
}



class _DropDownFormField<VType extends Object> extends State<DropDownFormField<VType>>{
  late VType? val;
  late List<DropdownMenuItem<VType>> items;
  @override
  void initState(){
    super.initState();
    val = widget.val;
    items = widget.items;
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    if(items.isEmpty && widget.itemBuilder != null){
      items = await widget.itemBuilder!();
      widget.setItems(items);
      setState(() {

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<VType>(
      value: val,
      items: items,
      onChanged: (value) {
        val = value;
        widget.onChanged(val);
      },
      decoration: widget.decoration,
    );
  }
}



class FDTDropDownFilter<VType extends Object> extends FDTFilter<VType>{
  late List<DropdownMenuItem<VType>> items;
  final FDTDropDownItemBuild<VType>? itemBuilder;
  FDTDropDownFilter({
    required super.key,
    super.val,
    super.textStyle,
    super.decoration,
    this.items = const [],
    this.itemBuilder,
  }): assert(items.isNotEmpty || itemBuilder != null);
  
  @override
  Widget filterBuild(BuildContext context) {
    return DropDownFormField<VType>(
        val: val,
        items: items,
        onChanged: (value) => val = value,
        decoration: decoration,
        itemBuilder: itemBuilder,
        setItems: (items) => this.items = items,
    );
  }
}



class DateTimeFormField extends StatefulWidget {
  final DateTime val;
  final InputDecoration decoration;
  final ValueChanged<DateTime> onChanged;
  const DateTimeFormField({
    super.key,
    required this.val,
    required this.decoration,
    required this.onChanged,
  });
  @override
  State<StatefulWidget> createState() => _DateTimeFormField();
}



class _DateTimeFormField extends State<DateTimeFormField>{
  late DateTime val;
  @override
  void initState() {
    super.initState();
    val = widget.val;
  }
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      onChanged: (value) {
        if(value == null ) return;
        val = value;
        widget.onChanged(val);
        setState(() {

        });
      },
      mode: DateTimeFieldPickerMode.date,
      value: val,
      decoration: widget.decoration,
    );
  }
}


class FDTDateFilter extends FDTFilter<String>{
  final FDTDateToStr dateToStr;
  final FDTStrToDate strToDate;
  FDTDateFilter({
    super.val,
    required super.key,
    super.textStyle,
    super.decoration,
    this.strToDate = strToDateConst,
    this.dateToStr = dateToStrConst,
  });

  @override
  Widget filterBuild(BuildContext context) {
    return DateTimeFormField(
      onChanged: (value) {
        val = dateToStr(value);
      },
      decoration: decoration,
      val: val == null ? DateTime.now() : strToDate(val!),
    );
  }
}



// TODO daterange, Sliderrange, json, file