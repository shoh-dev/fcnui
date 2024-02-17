//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

abstract class IFormModel extends Equatable {
  ///This will form the key in the form value Map
  final String name;

  const IFormModel({
    required this.name,
  });
}

class FormModel {
  /// Used for [FormBuilder] to control form
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// Used for [SaveButton] to enable/disable button
  final ValueNotifier<bool> isValidFormNotifier = ValueNotifier(false);

  /// Returns true if form is valid
  bool get isValid => formKey.currentState?.isValid ?? false;

  /// Callback for onChanged event
  ///
  /// Triggered when any field in form is changed
  void Function()? onChanged;

  /// Returns single value from form
  dynamic getValue(String name) => formKey.currentState?.fields[name]?.value;

  /// Returns all values from form
  Map<String, dynamic> getValues() => formKey.currentState?.value ?? {};

  /// Set single value to form
  void patchValue(Map<String, dynamic> value, {bool isSave = true}) {
    formKey.currentState?.patchValue(value);
    if (isSave) save();
  }

  /// Set all values to form
  void save() => formKey.currentState?.save();

  /// Reset form to initial state
  void reset() => formKey.currentState?.reset();

  /// Validate form
  void validate(
          {bool focusOnInvalid = true,
          bool autoScrollWhenFocusOnInvalid = false}) =>
      formKey.currentState?.validate(
          autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
          focusOnInvalid: focusOnInvalid);

  /// Save and validate form
  void saveAndValidate(
          {bool focusOnInvalid = true,
          bool autoScrollWhenFocusOnInvalid = false}) =>
      formKey.currentState?.saveAndValidate(
          autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
          focusOnInvalid: focusOnInvalid);

  /// Invalidate field
  ///
  /// Show error message on field if it's invalid
  void invalidateField(String name, String message) =>
      formKey.currentState?.fields[name]
          ?.invalidate(message, shouldFocus: false);
}

class DefaultForm extends StatelessWidget {
  final FormModel vm;
  final Widget child;
  final bool clearValueOnUnregister;

  /// If true, the form will save and validate on every change
  ///
  /// Used to auto validate on form change
  ///
  /// If using [SaveButton] trigger [autoValidate] field true.
  final bool saveAndValidateOnChange;
  const DefaultForm(
      {super.key,
      required this.vm,
      required this.child,
      this.saveAndValidateOnChange = false,
      this.clearValueOnUnregister = false});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      clearValueOnUnregister: clearValueOnUnregister,
      key: vm.formKey,
      onChanged: () {
        if (saveAndValidateOnChange) {
          vm.formKey.currentState?.save();
        }
        vm.isValidFormNotifier.value = vm.isValid;
        vm.onChanged?.call();
      },
      child: child,
    );
  }
}
