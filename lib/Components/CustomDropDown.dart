// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Styles/colors.dart';


class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {Key? key,
      this.value,
      required this.items,
      this.validator,
      this.hintText,
      this.onChanged,
      this.radius,
      required this.color,
      this.onSaved,
      this.label})
      : super(key: key);

  final dynamic value;
  final List<DropdownMenuItem> items;
  final String? Function(dynamic)? validator;
  final String? hintText;
  final String? label;
  final Function(dynamic)? onChanged;
  final Function(dynamic)? onSaved;
  final double? radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
      borderRadius: BorderRadius.circular(5),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: const BorderSide(
            color: Colors.black45,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: const BorderSide(
            color: Colors.black45,
            width: 1,
          ),
        ),
        fillColor: color,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        prefixIconColor: secondaryColor,
        suffixIconColor: secondaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        labelStyle: GoogleFonts.nunito(
            color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 14),
        labelText: label,
        hintText: hintText,
        focusColor: secondaryColor,
        iconColor: Colors.grey,
        hintStyle: GoogleFonts.nunito(
            color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      onChanged: onChanged,
      onSaved: onSaved,
      dropdownColor: Colors.white,
      items: items,
      validator: validator,
      value: value,
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: primaryColor,
      ),
    ));
  }
}
