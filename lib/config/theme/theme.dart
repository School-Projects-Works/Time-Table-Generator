import 'package:flutter/material.dart';

const primaryColor = Color(0xFF295D56);
const secondaryColor = Color(0xFF724C19);

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: Colors.grey.shade100,
  ),
);

final ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  // cardColor: Colors.grey.shade800,
  // dialogTheme: DialogTheme(
  //   backgroundColor: Colors.grey.shade800,
  // ),
  // cardTheme: CardTheme(
  //   color: Colors.grey.shade800,
  // ),
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade800,
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: Colors.grey.shade500,
  ),
);

TextStyle getTextStyle({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextDecoration? decoration,
  double? height,
}) =>
    TextStyle(
      fontFamily: 'Roboto',
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
