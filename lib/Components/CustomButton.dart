import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.text,
       this.color=secondaryColor, this.padding= const EdgeInsets.symmetric(horizontal: 20,vertical: 12)})
      : super(key: key);
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final EdgeInsets? padding;

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
            color: onHover?Colors.white:widget.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: onHover ?widget.color :  Colors.white),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  offset: const Offset(0, 5),
                  blurRadius: 10)
            ]),
        child: Center(
          child: Text(
            widget.text,
            style: GoogleFonts.roboto(
                color: onHover ? widget.color : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),

        )
      ),
    );
  }
}
