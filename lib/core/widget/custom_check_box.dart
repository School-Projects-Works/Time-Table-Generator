import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/constants/constant_data.dart';
import 'custom_drop_down.dart';


class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {Key? key,
      required this.title,
      required this.onTap,
      this.isChecked = false,
      this.startVal,
      this.endVal,
      this.onStartChanged,
      this.alwaysChecked = false,
      this.onEndChanged,
      this.hasTime = false})
      : super(key: key);
  final bool isChecked;
  final String title;
  final VoidCallback onTap;
  final bool hasTime, alwaysChecked;
  final String? startVal, endVal;
  final Function(dynamic)? onStartChanged, onEndChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  isChecked
                      ? const Icon(
                          Icons.check_box,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.black54,
                        ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (hasTime) const SizedBox(width: 150),
            if (hasTime && (isChecked || alwaysChecked))
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropDown(
                            items: listOfTime
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: GoogleFonts.nunito(
                                            color: Colors.black54),
                                      ),
                                    ))
                                .toList(),
                            color: Colors.white,
                            value: startVal,
                            onChanged: onStartChanged,
                            hintText: 'Select Start',
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: CustomDropDown(
                            items: listOfTime
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: GoogleFonts.nunito(
                                            color: Colors.black54),
                                      ),
                                    ))
                                .toList(),
                            color: Colors.white,
                            value: endVal,
                            onChanged: onEndChanged,
                            hintText: 'Select End',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
