import 'package:flutter/material.dart';
class Customtextfield extends StatelessWidget {
  TextEditingController controller;
  String label;
  String hintText;
  String? Function(String?) validator;

  Customtextfield({
    required this.hintText,
    required this.label,
    required this.controller,
    required this.validator
   });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(label),
        hintText: hintText,
      ),
    );
  }
}
