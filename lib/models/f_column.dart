
part of '../fdatatable.dart';

abstract class FDTBaseColumn<DType extends Object, VType>{
  final String title;
  final FDTCellBuild<DType>? cellBuilder;
  final bool visible;
  final String key;
  final InputDecoration? decoration;
  final Setter<DType, VType> setter;
  final Getter<DType, VType> getter;
  final double? columnWidth;
  final bool readOnly;
  FDTBaseColumn({
    required this.title,
    required this.key,
    required this.setter,
    required this.getter,
    this.cellBuilder,
    this.decoration,
    this.columnWidth,
    this.readOnly = false,
    this.visible = true
  });
  Widget formBuild(BuildContext context);
}

class FDTTextColumn<DType extends Object> extends FDTBaseColumn<DType, String>{

  final int min;
  final int max;
  final TextInputType? inputType;
  FDTTextColumn({
    required super.title,
    required super.key,
    required super.getter,
    required super.setter,
    required this.min,
    required this.max,
    super.readOnly,
    super.decoration,
    super.visible,
    super.columnWidth,
    super.cellBuilder,
    this.inputType
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderTextField(
          name: key,
          readOnly: readOnly,
          initialValue: getter(formState.newItem),
          decoration: decoration ?? InputDecoration(labelText: title),
          keyboardType: inputType,
          autovalidateMode: AutovalidateMode.always,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.maxLength(max),
            FormBuilderValidators.minLength(min),
            if(inputType == TextInputType.emailAddress) FormBuilderValidators.email(),
          ]),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem, value!);
              }
            }
          },
        );
      },
    );
  }
}
class FDTIntColumn<DType extends Object> extends FDTBaseColumn<DType, int>{

  final int min;
  final int max;
  FDTIntColumn({
    required super.title,
    required super.key,
    required super.getter,
    required super.setter,
    super.decoration,
    super.readOnly,
    super.visible,
    super.columnWidth,
    super.cellBuilder,
    required this.min,
    required this.max
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderTextField(
          name: key,
          autovalidateMode: AutovalidateMode.always,
          keyboardType: TextInputType.number,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
            FormBuilderValidators.max(max),
            FormBuilderValidators.min(min)
          ]),
          initialValue: getter(formState.newItem).toString(),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem, int.parse(value!));
              }
            }
          },
        );
      },
    );
  }
}


class FDTSliderColumn<DType extends Object> extends FDTBaseColumn<DType, double>{

  final double min;
  final double max;
  FDTSliderColumn({
    required super.title,
    required super.key,
    required super.getter,
    required super.setter,
    super.readOnly,
    super.decoration,
    super.visible,
    super.columnWidth,
    super.cellBuilder,
    required this.min,
    required this.max
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderSlider(
          name: key,
          autovalidateMode: AutovalidateMode.always,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.max(max),
            FormBuilderValidators.min(min)
          ]),
          min: min,
          max: max,
          initialValue: getter(formState.newItem),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem, value!);
              }
            }
          },
        );
      },
    );
  }
}


class FDTCheckboxColumn<DType extends Object> extends FDTBaseColumn<DType, bool>{

  final bool? required;
  FDTCheckboxColumn({
    required super.title,
    required super.key,
    required super.getter,
    required super.setter,
    super.readOnly,
    super.decoration,
    super.visible,
    super.columnWidth,
    super.cellBuilder,
    required this.required,
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderCheckbox(
          name: key,
          title: RichText(
            text: TextSpan(text: title),
          ),
          autovalidateMode: AutovalidateMode.always,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
          initialValue: getter(formState.newItem),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem, value!);
              }
            }
          },
        );
      },
    );
  }
}

class FDTLargeTextColumn<DType extends Object> extends FDTBaseColumn<DType, String>{

  final int minLines;
  final int maxLines;
  final int maxLength;

  FDTLargeTextColumn({
    required super.title,
    required super.key,
    required super.getter,
    required super.setter,
    super.decoration,
    super.readOnly,
    super.visible,
    super.columnWidth,
    super.cellBuilder,
    required this.minLines,
    required this.maxLines,
    required this.maxLength
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderTextField(
          name: key,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          initialValue: getter(formState.newItem),
          autovalidateMode: AutovalidateMode.always,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.maxLength(maxLength),
            FormBuilderValidators.minLength(1)
          ]),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem, value!);
              }
            }
          },
        );
      },
    );
  }
}

class FDTDropDownColumn<DType extends Object, VType> extends FDTBaseColumn<DType, VType>{

  final List<DropdownMenuItem<VType>> items;

  FDTDropDownColumn({
    required super.title,
    required super.key,
    required super.getter,
    required super.setter,
    super.decoration,
    super.readOnly,
    super.visible,
    super.columnWidth,
    super.cellBuilder,
    required this.items,
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderDropdown<VType>(
          name: key,
          items: items,
          initialValue: getter(formState.newItem),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem, value!);
              }
            }
          },
        );
      },
    );
  }
}

class FDTRadioGroupColumn<DType extends Object, VType> extends FDTBaseColumn<DType, VType>{

  final List<FormBuilderFieldOption<VType>> items;

  FDTRadioGroupColumn({
    required super.title,
    required super.key,
    required super.getter,
    required super.setter,
    super.decoration,
    super.readOnly,
    super.visible,
    super.columnWidth,
    super.cellBuilder,
    required this.items,
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderRadioGroup<VType>(
          name: key,
          options: items,
          initialValue: getter(formState.newItem),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem, value!);
              }
            }
          },
          controlAffinity: ControlAffinity.trailing,
        );
      },
    );
  }
}

class FDTDateColumn<DType extends Object> extends FDTBaseColumn<DType, DateTime>{

  InputType inputType;

  FDTDateColumn({
    required super.title,
    required super.key,
    required super.getter,
    required super.setter,
    super.decoration,
    super.readOnly,
    super.visible,
    super.columnWidth,
    super.cellBuilder,
    this.inputType  = InputType.date,
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderDateTimePicker(
          name: key,
          initialValue: getter(formState.newItem),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
          inputType: inputType,
          decoration: decoration ?? InputDecoration(
              labelText: title,
              suffixIcon: inputType == InputType.date ? Icon(Icons.date_range): Icon(Icons.timelapse_outlined)
          ),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem, value!);
              }
            }
          },
        );
      },
    );
  }
}
