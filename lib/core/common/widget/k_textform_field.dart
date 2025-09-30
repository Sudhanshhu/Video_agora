import 'package:flutter/material.dart';

import 'cmn_text.dart';

enum InputType { text, decimal, number, email, password, multiline, dateTime }

class KTextFormField extends StatelessWidget {
  const KTextFormField({
    super.key,
    this.validator,
    this.controller,
    this.filled = false,
    this.fillColour,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
    this.inputType = InputType.text,
    this.prefixIconData,
    this.prefixWidget,
    this.minLines = 1,
    this.maxLines = 1,
    this.isEditable = true,
    this.isUnderLine = false,
    this.onChanged,
    this.givePadding = true,
    this.isEnable = true,
    this.autofocus = false,
    this.onTap,
    this.disabledFillColor = Colors.black12,
    this.focusNode,
    this.mandatory = false,
    this.onFieldSubmitted,
    this.autoSelect = false,
    this.isPassword = false,
    this.initialValue,
  });

  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool filled;
  final Color? fillColour;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? hintText;
  final String? initialValue;
  final TextStyle? hintStyle;
  final InputType? inputType;
  final IconData? prefixIconData;
  final Widget? prefixWidget;
  final int? minLines;
  final int? maxLines;
  final bool isEditable;
  final bool isUnderLine;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool givePadding;
  final bool isEnable;
  final bool autofocus;
  final VoidCallback? onTap;
  final Color disabledFillColor;
  final FocusNode? focusNode;
  final bool mandatory;
  final double curve = 6.0;
  final bool? autoSelect;
  final bool isPassword;

  TextInputType get keyboardType {
    switch (inputType) {
      case InputType.number:
        return TextInputType.number;
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  getValidatorsInCaseValidatorIsNull() {
    if (mandatory) {
      switch (inputType ?? InputType.text) {
        case InputType.email:
          return (value) => stringValidator(value, minLength: 5);
        case InputType.number:
          return numValidator;
        case InputType.text:
          return stringValidator;
        case InputType.password:
          return stringValidator;
        case InputType.multiline:
          return stringValidator;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(givePadding ? 8.0 : 0.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 45,
          maxHeight: maxLines == null ? 65 : (65 + (maxLines! * 30.0)),
          maxWidth: 450,
        ),
        child: TextFormField(
          initialValue: initialValue,
          onFieldSubmitted: onFieldSubmitted,
          cursorHeight: 20,
          focusNode: focusNode,
          autofocus: autofocus,
          onTap: () {
            if (onTap != null) onTap!();
            if ((autoSelect ?? false) && controller != null) {
              controller!.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller!.text.length,
              );
            }
          },
          enabled: isEnable,
          onChanged: onChanged,
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          validator: validator ?? getValidatorsInCaseValidatorIsNull(),
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: prefixWidget ??
                (prefixIconData != null ? Icon(prefixIconData!) : null),
            hintText: hintText,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                KText(
                  hintText ?? "",
                ),
                if (mandatory)
                  const KText(
                    " *",
                    fontSize: 18,
                    textColor: Colors.red,
                  ),
              ],
            ),
            enabledBorder: isUnderLine
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                      width: 0.5,
                    ),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(curve),
                    borderSide: const BorderSide(
                      color: Colors.teal,
                      width: 0.5,
                    ),
                  ),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(curve),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}

typedef ValidatorFunction<T> = String? Function(T value);

String? commonValidator<T>({
  required String value,
  required List<ValidatorFunction<T>> rules,
  required T Function(String value) parser,
}) {
  try {
    T parsedValue = parser(value);
    for (var rule in rules) {
      String? result = rule(parsedValue);
      if (result != null) {
        return result;
      }
    }
  } catch (e) {
    return "Invalid input.";
  }
  return null;
}

String? stringValidator(
  String? value, {
  bool isMandatory = true,
  int minLength = 3,
  int maxLength = 100,
}) {
  if (value == null || value.isEmpty) {
    return "Value cannot be null.";
  }
  return commonValidator<String>(
    value: value,
    rules: [
      (v) => v.isEmpty ? "Cannot be empty." : null,
      (v) => v.length < minLength
          ? "Minimum $minLength characters required."
          : null,
    ],
    parser: (value) => value,
  );
}

String? numValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Value cannot be empty.";
  }
  return commonValidator<num>(
    value: value,
    rules: [
      (v) => v < 0 ? "Value must be non-negative." : null,
      // (v) => v > 100 ? "Value cannot exceed 100." : null,
    ],
    parser: (value) => num.parse(value),
  );
}
