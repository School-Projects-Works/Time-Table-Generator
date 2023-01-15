import 'package:aamusted_timetable_generator/Components/CustomDropDown.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/ConstantList.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {Key? key,
      required this.title,
      required this.onTap,
      this.isChecked = false,
      this.regularChecked = false,
      this.eveningChecked = false,
      this.weekendChecked = false,
      this.onRegular,
      this.onEvening,
      this.onWeekend,
      this.hasDropDown = false,
      this.startVal,
      this.endVal,
      this.onStartChanged,
      this.onEndChanged})
      : super(key: key);
  final bool isChecked;
  final String title;
  final VoidCallback onTap;
  final bool regularChecked, eveningChecked, weekendChecked;
  final VoidCallback? onRegular, onEvening, onWeekend;
  final bool hasDropDown;
  final String? startVal, endVal;
  final Function(dynamic)? onStartChanged, onEndChanged;

  @override
  Widget build(BuildContext context) {
    if (hasDropDown) {
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
                            color: secondaryColor,
                          )
                        : const Icon(
                            Icons.check_box_outline_blank,
                            color: secondaryColor,
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
              const Spacer(),
              if (isChecked)
                SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropDown(
                              items: time
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomDropDown(
                              items: time
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: onRegular,
                            child: Row(
                              children: [
                                regularChecked
                                    ? const Icon(
                                        Icons.check_box,
                                        color: primaryColor,
                                      )
                                    : const Icon(
                                        Icons.check_box_outline_blank,
                                        color: primaryColor,
                                      ),
                                const SizedBox(width: 8),
                                Text(
                                  'Regular',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: onEvening,
                            child: Row(
                              children: [
                                eveningChecked
                                    ? const Icon(
                                        Icons.check_box,
                                        color: primaryColor,
                                      )
                                    : const Icon(
                                        Icons.check_box_outline_blank,
                                        color: primaryColor,
                                      ),
                                const SizedBox(width: 8),
                                Text(
                                  'Evening',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: onWeekend,
                            child: Row(
                              children: [
                                weekendChecked
                                    ? const Icon(
                                        Icons.check_box,
                                        color: primaryColor,
                                      )
                                    : const Icon(
                                        Icons.check_box_outline_blank,
                                        color: primaryColor,
                                      ),
                                const SizedBox(width: 8),
                                Text(
                                  'Weekend',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                isChecked
                    ? const Icon(
                        Icons.check_box,
                        color: secondaryColor,
                      )
                    : const Icon(
                        Icons.check_box_outline_blank,
                        color: secondaryColor,
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
          const Spacer(),
          if (isChecked)
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onRegular,
                  child: Row(
                    children: [
                      regularChecked
                          ? const Icon(
                              Icons.check_box,
                              color: primaryColor,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: primaryColor,
                            ),
                      const SizedBox(width: 8),
                      Text(
                        'Regular',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: onEvening,
                  child: Row(
                    children: [
                      eveningChecked
                          ? const Icon(
                              Icons.check_box,
                              color: primaryColor,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: primaryColor,
                            ),
                      const SizedBox(width: 8),
                      Text(
                        'Evening',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: onWeekend,
                  child: Row(
                    children: [
                      weekendChecked
                          ? const Icon(
                              Icons.check_box,
                              color: primaryColor,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: primaryColor,
                            ),
                      const SizedBox(width: 8),
                      Text(
                        'Weekend',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      );
    }
  }
}
