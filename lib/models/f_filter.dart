

part of '../fdatatable.dart';

abstract class FDTFilterModel<FType>{
  final InputDecoration? decoration;
  final String title;
  final String key;
  late FType? value;

  FDTFilterModel({
    required this.key,
    required this.title,
    this.value,
    this.decoration
  });
  Widget build(BuildContext context, FDTNotifier state);
  Map<String, dynamic> toJson();
}


class FDTTextFilter extends FDTFilterModel<String> {
  FDTTextFilter({
    super.decoration,
    required super.key,
    required super.title,
    super.value
  });

  @override
  Widget build(BuildContext context, FDTNotifier state) {
    return FormBuilderTextField(
      name: key,
      decoration: decoration ?? InputDecoration(labelText: title),
      initialValue: value ?? "",
      onChanged: (value) {
        if (value != null) {
          state.filters[key]!.value = value;
        }
      },
    );
  }
  @override
  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}


class FDTDateFilter extends FDTFilterModel<DateTime> {
  InputType inputType;
  FDTDateFilter({
    required super.key,
    required super.title,
    super.value,
    this.inputType = InputType.date
  });

  @override
  Widget build(BuildContext context, FDTNotifier state) {
    return FormBuilderDateTimePicker(
      name: key,
      initialEntryMode: DatePickerEntryMode.calendar,
      initialValue: value ?? DateTime.now(),
      inputType: inputType,
      decoration: decoration ?? InputDecoration(
        labelText: title,
        suffixIcon: inputType == InputType.date ? Icon(Icons.date_range): Icon(Icons.timelapse_outlined)
      ),
      initialTime: const TimeOfDay(hour: 0, minute: 0,),
      onChanged: (value) {
        state.filters[key]!.value = value;
      },
    );
  }
  @override
  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value?.toIso8601String(),
  };
}

class FDTSelectFilter<FType> extends FDTFilterModel<FType> {

  final List<DropdownMenuItem<FType>> items;
  FDTSelectFilter({
    required super.key,
    required super.title,
    super.value,
    required this.items,
  });

  @override
  Widget build(BuildContext context, FDTNotifier state) {
    return FormBuilderDropdown<FType>(
      name: key,
      decoration: decoration ?? const InputDecoration(label: Text("Select")),
      initialValue: value,
      items: items,
      onChanged: (value) {
        state.filters[key]!.value = value;
      },
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}

class FDTSubmitFilter extends FDTFilterModel<String> {

  FDTSubmitFilter({
    super.key = "filter",
    super.title = "fdt.filter",
    super.value = "",
  });

  @override
  Widget build(BuildContext context, FDTNotifier state) {
    return FilledButton.icon(onPressed: () {
      state.saveFilter();
    }, icon: Icon(Icons.search_rounded),
        label: Text(title));
  }

  @override
  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}