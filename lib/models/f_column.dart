
part of '../fdatatable.dart';

abstract class FDTBaseColumn<DType extends Object, VType>{
  final String title;
  final FDTCellBuild<DType>? cellBuilder;

  final String key;
  final InputDecoration? decoration;
  final Setter<DType, VType> setter;
  final Getter<DType, VType> getter;
  final double? columnWidth;
  final double inputHeight;
  final bool visible;
  final bool readOnly;
  final bool isFilter;
  final bool visibleOnly;
  FDTBaseColumn({
    required this.title,
    required this.key,
    required this.setter,
    required this.getter,
    this.cellBuilder,
    this.decoration,
    this.columnWidth,
    this.inputHeight = 50,
    this.readOnly = false,
    this.visible = true,
    this.isFilter = false,
    this.visibleOnly = false
  });
  Widget formBuild(BuildContext context);
  Widget filterBuild(BuildContext context);
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
    super.isFilter,
    super.columnWidth,
    super.inputHeight,
    super.cellBuilder,
    this.inputType,
    super.visibleOnly,
  });

  @override
  Widget filterBuild(BuildContext context) {

    return Consumer<FDTFilterNotifier<DType>>(
      builder: (context, filterState, child) {
        return FormBuilderTextField(
          name: key,
          decoration: decoration ?? InputDecoration(labelText: title),
          initialValue: filterState.getValue(key),
          keyboardType: inputType,
          onChanged: (value) {
            if(filterState._formKey.currentState!=null){
              if(filterState._formKey.currentState!.fields[key]!.validate()){
                //formState.newItem![key] = value!;
                filterState.setValue(key, value);
              }
            }
          },
        );
      },
    );
  }
  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderTextField(
          name: key,
          readOnly: readOnly,
          initialValue: getter(formState.newItem!),
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
                setter(formState.newItem!, value!);
                formState.updateValue();
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
    super.isFilter,
    super.columnWidth,
    super.inputHeight,
    super.cellBuilder,
    required this.min,
    required this.max,
    super.visibleOnly,
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
          initialValue: getter(formState.newItem!).toString(),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem!, int.parse(value!));
                formState.updateValue();
              }
            }
          },
        );
      },
    );
  }
  @override
  Widget filterBuild(BuildContext context) {
    return Consumer<FDTFilterNotifier<DType>>(
      builder: (context, filterState, child) {
        return FormBuilderTextField(
          name: key,
          decoration: decoration ?? InputDecoration(labelText: title),
          keyboardType: TextInputType.number,
          initialValue: filterState.getValue(key),
          onChanged: (value) {
            if(filterState._formKey.currentState!=null){
              if(filterState._formKey.currentState!.fields[key]!.validate()){
                filterState.setValue(key, value);
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
    super.isFilter,
    super.columnWidth,
    super.inputHeight,
    super.cellBuilder,
    required this.min,
    required this.max,
    super.visibleOnly,
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
          initialValue: getter(formState.newItem!) ?? min,
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem!, value!);
                formState.updateValue();
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget filterBuild(BuildContext context) {
    return Consumer<FDTFilterNotifier<DType>>(
      builder: (context, filterState, child) {
        return FormBuilderSlider(
          name: key,
          min: min,
          max: max,
          initialValue: filterState.getValue(key) ?? min,
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(filterState._formKey.currentState!=null){
              if(filterState._formKey.currentState!.fields[key]!.validate()){
                filterState.setValue(key, value);
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
    super.isFilter,
    super.columnWidth,
    super.inputHeight,
    super.cellBuilder,
    required this.required,
    super.visibleOnly,
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
          initialValue: getter(formState.newItem!),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem!, value!);
                formState.updateValue();
              }
            }
          },
        );
      },
    );
  }
  @override
  Widget filterBuild(BuildContext context) {
    return Consumer<FDTFilterNotifier<DType>>(
      builder: (context, filterState, child) {
        return FormBuilderCheckbox(
          name: key,
          title: RichText(
            text: TextSpan(text: title),
          ),
          initialValue: filterState.getValue(key),
          decoration: decoration ?? InputDecoration(labelText: title,contentPadding: EdgeInsets.all(1)),
          onChanged: (value) {
            if(filterState._formKey.currentState!=null){
              if(filterState._formKey.currentState!.fields[key]!.validate()){
                filterState.setValue(key, value);
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
    super.isFilter,
    super.columnWidth,
    super.inputHeight,
    super.cellBuilder,
    required this.minLines,
    required this.maxLines,
    required this.maxLength,
    super.visibleOnly,
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
          initialValue: getter(formState.newItem!),
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
                setter(formState.newItem!, value!);
                formState.updateValue();
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget filterBuild(BuildContext context) {
    return Consumer<FDTFilterNotifier<DType>>(
      builder: (context, filterState, child) {
        return FormBuilderTextField(
          name: key,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          initialValue: filterState.getValue(key),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(filterState._formKey.currentState!=null){
              if(filterState._formKey.currentState!.fields[key]!.validate()){
                filterState.setValue(key, value);
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
    super.isFilter,
    super.columnWidth,
    super.inputHeight,
    super.cellBuilder,
    required this.items,
    super.visibleOnly,
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderDropdown<VType>(
          name: key,
          items: items,
          initialValue: getter(formState.newItem!),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem!, value!);
                formState.updateValue();
              }
            }
          },
        );
      },
    );
  }
  @override
  Widget filterBuild(BuildContext context) {
    return Consumer<FDTFilterNotifier<DType>>(
      builder: (context, filterState, child) {
        return FormBuilderDropdown<VType>(
          name: key,
          items: items,
          initialValue: filterState.getValue(key),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(filterState._formKey.currentState!=null){
              if(filterState._formKey.currentState!.fields[key]!.validate()){
                filterState.setValue(key, value);
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
    super.isFilter,
    super.columnWidth,
    super.cellBuilder,
    required this.items,
    super.visibleOnly,
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderRadioGroup<VType>(
          name: key,
          options: items,
          initialValue: getter(formState.newItem!),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(formState._formKey.currentState!=null){
              if(formState._formKey.currentState!.fields[key]!.validate()){
                setter(formState.newItem!, value!);
                formState.updateValue();
              }
            }
          },
          controlAffinity: ControlAffinity.trailing,
        );
      },
    );
  }

  @override
  Widget filterBuild(BuildContext context) {
    return Consumer<FDTFilterNotifier<DType>>(
      builder: (context, filterState, child) {
        return FormBuilderRadioGroup<VType>(
          name: key,
          options: items,
          initialValue: filterState.getValue(key),
          decoration: decoration ?? InputDecoration(labelText: title),
          onChanged: (value) {
            if(filterState._formKey.currentState!=null){
              if(filterState._formKey.currentState!.fields[key]!.validate()){
                filterState.setValue(key, value);
              }
            }
          },
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
    super.isFilter,
    super.columnWidth,
    super.cellBuilder,
    super.visibleOnly,
    this.inputType  = InputType.date,
  });

  @override
  Widget formBuild(BuildContext context) {
    return Consumer<FDTFormNotifier<DType>>(
      builder: (context, formState, child) {
        return FormBuilderDateTimePicker(
          name: key,
          initialValue: getter(formState.newItem!),
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
                setter(formState.newItem!, value!);
                formState.updateValue();
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget filterBuild(BuildContext context) {
    return Consumer<FDTFilterNotifier<DType>>(
      builder: (context, filterState, child) {
        return FormBuilderDateTimePicker(
          name: key,
          initialValue: filterState.getValue(key),
          inputType: inputType,
          decoration: decoration ?? InputDecoration(
              labelText: title,
              suffixIcon: inputType == InputType.date ? Icon(Icons.date_range): Icon(Icons.timelapse_outlined)
          ),
          onChanged: (value) {
            if(filterState._formKey.currentState!=null){
              if(filterState._formKey.currentState!.fields[key]!.validate()){
                filterState.setValue(key, value);

              }
            }
          },
        );
      },
    );
  }
}

// TODO daterange, Sliderrange, password, json, file