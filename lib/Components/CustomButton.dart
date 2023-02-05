// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.color = secondaryColor,
      this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      this.radius = 5})
      : super(key: key);
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final EdgeInsets? padding;
  final double radius;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (value) {
        setState(() {
          onHover = value;
        });
      },
      child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: onHover ? Colors.white : widget.color,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: onHover ? widget.color : Colors.white),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: GoogleFonts.nunito(
                  color: onHover ? widget.color : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          )),
    );
  }
}
