// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Styles/colors.dart';

class CustomTextFields extends StatelessWidget {
  const CustomTextFields({
    Key? key,
    this.controller,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.maxLines,
    this.hintText,
    this.radius,
    this.isCapitalized = false,
    this.isDigitOnly = false,
    this.isReadOnly = false,
    this.onTap,
    this.color = Colors.white,
  }) : super(key: key);
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final int? maxLines;
  final double? radius;
  final bool? isCapitalized;
  final bool? isDigitOnly;
  final bool? isReadOnly;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      onTap: onTap,
      validator: validator,
      inputFormatters: [
        if (isCapitalized!) UpperCaseTextFormatter(),
        if (isDigitOnly ?? false)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      textCapitalization: isCapitalized!
          ? TextCapitalization.characters
          : TextCapitalization.none,
      style: GoogleFonts.nunito(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
      onChanged: onChanged,
      onSaved: onSaved,
      maxLines: maxLines ?? 1,
      readOnly: isReadOnly ?? false,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        labelStyle: GoogleFonts.nunito(
            color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 14),
        labelText: label,
        hintText: hintText,
        focusColor: secondaryColor,
        iconColor: Colors.grey,
        hintStyle: GoogleFonts.nunito(
            color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 14),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: 18,
                color: secondaryColor,
              )
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (RegExp("[a-zA-Z,]").hasMatch(newValue.text)) {
      return TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
    } else if (!RegExp(r'^[a-zA-Z0-9_\-=@+,\.;]+$').hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
