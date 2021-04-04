import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputForm extends StatelessWidget {
  final String s;
  final onChange;
  final validator;
  final obscureText;
  final color;
  final keyBoard;
  final autofocus;
  final textInputAction;

  TextInputForm({
    this.s,
    this.onChange,
    this.validator,
    this.obscureText,
    this.color,
    this.keyBoard,
    this.autofocus,
    this.textInputAction,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
      child: TextFormField(
        style: TextStyle(color: color ?? Colors.white),
        keyboardType: keyBoard ?? TextInputType.text,
        validator: (value) {
          if (validator != null) {
            return validator(value);
          } else
            return null;
        },
        autofocus: autofocus ?? false,
        obscureText: obscureText ?? false,
        textInputAction: textInputAction ?? TextInputAction.next,
        decoration: InputDecoration(
          labelText: s,
          labelStyle: TextStyle(color: color ?? Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.greenAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.greenAccent),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          onChange(value);
        },
      ),
    );
  }
}
