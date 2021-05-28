import 'package:covid_help/constants.dart';

import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) validator;
  final bool isNumberField;
  final int maxline;
  final bool isPasswordField;
  final String value;
  final bool autofocus;
  final bool enable;

  CustomInput(
      {this.hintText,
      this.value,
      this.enable,
      this.autofocus,
      this.validator,
      this.onChanged,
      this.isPasswordField,
      this.isNumberField,
      this.maxline});

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField ?? false;
    bool _isNumberField = isNumberField ?? false;
    bool _autofocus = autofocus ?? false;
    bool _isEnable = enable ?? true;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(12.0)),
      child: TextFormField(
        enabled: _isEnable,
        initialValue: value ?? '',
        keyboardType:
            _isNumberField ? TextInputType.number : TextInputType.text,
        obscureText: _isPasswordField,
        onChanged: onChanged,
        maxLines: maxline ?? 1,
        validator: validator,
        autofocus: _autofocus,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText ?? "Hint Text...",
            contentPadding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            )),
        style: Constants.regularDarkText,
      ),
    );
  }
}
