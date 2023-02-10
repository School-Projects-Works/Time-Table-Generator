// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/custom_check_box.dart';
import 'package:aamusted_timetable_generator/SateManager/hive_listener.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DaysSection extends StatelessWidget {
  const DaysSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, hive, child) {
      return Container(
          width: size.width * 0.3,
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Days',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                  'Select days on which class will take place for this targeted student group (${hive.targetedStudents}).',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 20),
              CustomCheckBox(
                title: 'Monday',
                onTap: () {
                  if (hive.getMonday == null) {
                    hive.updateMonday('Monday');
                  } else {
                    hive.updateMonday('');
                  }
                },
                isChecked: hive.getMonday != null,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Tuesday',
                onTap: () {
                  if (hive.getTuesday == null) {
                    hive.updateTuesday('Tuesday');
                  } else {
                    hive.updateTuesday('');
                  }
                },
                isChecked: hive.getTuesday != null,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Wednesday',
                onTap: () {
                  if (hive.getWednesday == null) {
                    hive.updateWednesday('Wednesday');
                  } else {
                    hive.updateWednesday('');
                  }
                },
                isChecked: hive.getWednesday != null,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Thursday',
                onTap: () {
                  if (hive.getThursday == null) {
                    hive.updateThursday('Thursday');
                  } else {
                    hive.updateThursday('');
                  }
                },
                isChecked: hive.getThursday != null,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Friday',
                onTap: () {
                  if (hive.getFriday == null) {
                    hive.updateFriday('Friday');
                  } else {
                    hive.updateFriday('');
                  }
                },
                isChecked: hive.getFriday != null,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Saturday',
                onTap: () {
                  if (hive.getSaturday == null) {
                    hive.updateSaturday('Saturday');
                  } else {
                    hive.updateSaturday('');
                  }
                },
                isChecked: hive.getSaturday != null,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Sunday',
                onTap: () {
                  if (hive.getSunday == null) {
                    hive.updateSunday('Sunday');
                  } else {
                    hive.updateSunday('');
                  }
                },
                isChecked: hive.getSunday != null,
              ),
              const SizedBox(height: 15),
            ],
          ));
    });
  }
}
