import 'package:aamusted_timetable_generator/Components/CustomCheckBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../SateManager/ConfigDataFlow.dart';

class DaysSection extends StatelessWidget {
  const DaysSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<ConfigDataFlow>(builder: (context, data, child) {
      return Container(
          width: size.width * 0.45,
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
                  'Select days on which class will take place and provide the category of students who will have class on these days.',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 20),
              CustomCheckBox(
                title: 'Monday',
                onTap: () {
                  if (data.getMonday.day == null) {
                    data.updateMonday('Monday');
                  } else {
                    data.updateMonday('');
                  }
                },
                isChecked: data.getMonday.day != null,
                onRegular: () {
                  if (data.getMonday.isRegular == null ||
                      data.getMonday.isRegular == false) {
                    data.updateMondayType('+Regular');
                  } else {
                    data.updateMondayType('-Regular');
                  }
                },
                regularChecked: data.getMonday.isRegular != null &&
                    data.getMonday.isRegular!,
                onEvening: () {
                  if (data.getMonday.isEvening == null ||
                      data.getMonday.isEvening == false) {
                    data.updateMondayType('+Evening');
                  } else {
                    data.updateMondayType('-Evening');
                  }
                },
                eveningChecked: data.getMonday.isEvening != null &&
                    data.getMonday.isEvening!,
                onWeekend: () {
                  if (data.getMonday.isWeekend == null ||
                      data.getMonday.isWeekend == false) {
                    data.updateMondayType('+Weekend');
                  } else {
                    data.updateMondayType('-Weekend');
                  }
                },
                weekendChecked: data.getMonday.isWeekend != null &&
                    data.getMonday.isWeekend!,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Tuesday',
                onTap: () {
                  if (data.getTuesday.day == null) {
                    data.updateTuesday('Tuesday');
                  } else {
                    data.updateTuesday('');
                  }
                },
                isChecked: data.getTuesday.day != null,
                onRegular: () {
                  if (data.getTuesday.isRegular == null ||
                      data.getTuesday.isRegular == false) {
                    data.updateTuesdayType('+Regular');
                  } else {
                    data.updateTuesdayType('-Regular');
                  }
                },
                regularChecked: data.getTuesday.isRegular != null &&
                    data.getTuesday.isRegular!,
                onEvening: () {
                  if (data.getTuesday.isEvening == null ||
                      data.getTuesday.isEvening == false) {
                    data.updateTuesdayType('+Evening');
                  } else {
                    data.updateTuesdayType('-Evening');
                  }
                },
                eveningChecked: data.getTuesday.isEvening != null &&
                    data.getTuesday.isEvening!,
                onWeekend: () {
                  if (data.getTuesday.isWeekend == null ||
                      data.getTuesday.isWeekend == false) {
                    data.updateTuesdayType('+Weekend');
                  } else {
                    data.updateTuesdayType('-Weekend');
                  }
                },
                weekendChecked: data.getTuesday.isWeekend != null &&
                    data.getTuesday.isWeekend!,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Wednesday',
                onTap: () {
                  if (data.getWednesday.day == null) {
                    data.updateWednesday('Wednesday');
                  } else {
                    data.updateWednesday('');
                  }
                },
                isChecked: data.getWednesday.day != null,
                onRegular: () {
                  if (data.getWednesday.isRegular == null ||
                      data.getWednesday.isRegular == false) {
                    data.updateWednesdayType('+Regular');
                  } else {
                    data.updateWednesdayType('-Regular');
                  }
                },
                regularChecked: data.getWednesday.isRegular != null &&
                    data.getWednesday.isRegular!,
                onEvening: () {
                  if (data.getWednesday.isEvening == null ||
                      data.getWednesday.isEvening == false) {
                    data.updateWednesdayType('+Evening');
                  } else {
                    data.updateWednesdayType('-Evening');
                  }
                },
                eveningChecked: data.getWednesday.isEvening != null &&
                    data.getWednesday.isEvening!,
                onWeekend: () {
                  if (data.getWednesday.isWeekend == null ||
                      data.getWednesday.isWeekend == false) {
                    data.updateWednesdayType('+Weekend');
                  } else {
                    data.updateWednesdayType('-Weekend');
                  }
                },
                weekendChecked: data.getWednesday.isWeekend != null &&
                    data.getWednesday.isWeekend!,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Thursday',
                onTap: () {
                  if (data.getThursday.day == null) {
                    data.updateThursday('Thursday');
                  } else {
                    data.updateThursday('');
                  }
                },
                isChecked: data.getThursday.day != null,
                onRegular: () {
                  if (data.getThursday.isRegular == null ||
                      data.getThursday.isRegular == false) {
                    data.updateThursdayType('+Regular');
                  } else {
                    data.updateThursdayType('-Regular');
                  }
                },
                regularChecked: data.getThursday.isRegular != null &&
                    data.getThursday.isRegular!,
                onEvening: () {
                  if (data.getThursday.isEvening == null ||
                      data.getThursday.isEvening == false) {
                    data.updateThursdayType('+Evening');
                  } else {
                    data.updateThursdayType('-Evening');
                  }
                },
                eveningChecked: data.getThursday.isEvening != null &&
                    data.getThursday.isEvening!,
                onWeekend: () {
                  if (data.getThursday.isWeekend == null ||
                      data.getThursday.isWeekend == false) {
                    data.updateThursdayType('+Weekend');
                  } else {
                    data.updateThursdayType('-Weekend');
                  }
                },
                weekendChecked: data.getThursday.isWeekend != null &&
                    data.getThursday.isWeekend!,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Friday',
                onTap: () {
                  if (data.getFriday.day == null) {
                    data.updateFriday('Friday');
                  } else {
                    data.updateFriday('');
                  }
                },
                isChecked: data.getFriday.day != null,
                onRegular: () {
                  if (data.getFriday.isRegular == null ||
                      data.getFriday.isRegular == false) {
                    data.updateFridayType('+Regular');
                  } else {
                    data.updateFridayType('-Regular');
                  }
                },
                regularChecked: data.getFriday.isRegular != null &&
                    data.getFriday.isRegular!,
                onEvening: () {
                  if (data.getFriday.isEvening == null ||
                      data.getFriday.isEvening == false) {
                    data.updateFridayType('+Evening');
                  } else {
                    data.updateFridayType('-Evening');
                  }
                },
                eveningChecked: data.getFriday.isEvening != null &&
                    data.getFriday.isEvening!,
                onWeekend: () {
                  if (data.getFriday.isWeekend == null ||
                      data.getFriday.isWeekend == false) {
                    data.updateFridayType('+Weekend');
                  } else {
                    data.updateFridayType('-Weekend');
                  }
                },
                weekendChecked: data.getFriday.isWeekend != null &&
                    data.getFriday.isWeekend!,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Saturday',
                onTap: () {
                  if (data.getSaturday.day == null) {
                    data.updateSaturday('Saturday');
                  } else {
                    data.updateSaturday('');
                  }
                },
                isChecked: data.getSaturday.day != null,
                onRegular: () {
                  if (data.getSaturday.isRegular == null ||
                      data.getSaturday.isRegular == false) {
                    data.updateSaturdayType('+Regular');
                  } else {
                    data.updateSaturdayType('-Regular');
                  }
                },
                regularChecked: data.getSaturday.isRegular != null &&
                    data.getSaturday.isRegular!,
                onEvening: () {
                  if (data.getSaturday.isEvening == null ||
                      data.getSaturday.isEvening == false) {
                    data.updateSaturdayType('+Evening');
                  } else {
                    data.updateSaturdayType('-Evening');
                  }
                },
                eveningChecked: data.getSaturday.isEvening != null &&
                    data.getSaturday.isEvening!,
                onWeekend: () {
                  if (data.getSaturday.isWeekend == null ||
                      data.getSaturday.isWeekend == false) {
                    data.updateSaturdayType('+Weekend');
                  } else {
                    data.updateSaturdayType('-Weekend');
                  }
                },
                weekendChecked: data.getSaturday.isWeekend != null &&
                    data.getSaturday.isWeekend!,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: 'Sunday',
                onTap: () {
                  if (data.getSunday.day == null) {
                    data.updateSunday('Sunday');
                  } else {
                    data.updateSunday('');
                  }
                },
                isChecked: data.getSunday.day != null,
                onRegular: () {
                  if (data.getSunday.isRegular == null ||
                      data.getSunday.isRegular == false) {
                    data.updateSundayType('+Regular');
                  } else {
                    data.updateSundayType('-Regular');
                  }
                },
                regularChecked: data.getSunday.isRegular != null &&
                    data.getSunday.isRegular!,
                onEvening: () {
                  if (data.getSunday.isEvening == null ||
                      data.getSunday.isEvening == false) {
                    data.updateSundayType('+Evening');
                  } else {
                    data.updateSundayType('-Evening');
                  }
                },
                eveningChecked: data.getSunday.isEvening != null &&
                    data.getSunday.isEvening!,
                onWeekend: () {
                  if (data.getSunday.isWeekend == null ||
                      data.getSunday.isWeekend == false) {
                    data.updateSundayType('+Weekend');
                  } else {
                    data.updateSundayType('-Weekend');
                  }
                },
                weekendChecked: data.getSunday.isWeekend != null &&
                    data.getSunday.isWeekend!,
              ),
              const SizedBox(height: 15),
            ],
          ));
    });
  }
}
