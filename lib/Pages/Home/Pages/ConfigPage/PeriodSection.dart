// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CustomCheckBox.dart';
import '../../../../SateManager/ConfigDataFlow.dart';

class PeriodSection extends StatelessWidget {
  const PeriodSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<ConfigDataFlow>(builder: (context, data, child) {
      return Container(
          width: size.width * 0.46,
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Periods',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                  'Select periods on which class will take place and provide the category of students who will have class on these periods.',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 20),
              CustomCheckBox(
                title: '1st Period',
                hasDropDown: true,
                onStartChanged: (value) {
                  data.setPeriodOneStart(value);
                },
                onEndChanged: (value) {
                  data.setPeriodOneEnd(value);
                },
                startVal: data.periodOne.startTime,
                endVal: data.periodOne.endTime,
                onTap: () {
                  if (data.getPeriodOne.period == null) {
                    data.updatePeriodOne('1st Period');
                  } else {
                    data.updatePeriodOne('');
                  }
                },
                isChecked: data.getPeriodOne.period != null,
                onRegular: () {
                  if (data.getPeriodOne.isRegular == null ||
                      data.getPeriodOne.isRegular == false) {
                    data.updatePeriodOneType('+Regular');
                  } else {
                    data.updatePeriodOneType('-Regular');
                  }
                },
                regularChecked: data.getPeriodOne.isRegular != null &&
                    data.getPeriodOne.isRegular!,
                onEvening: () {
                  if (data.getPeriodOne.isEvening == null ||
                      data.getPeriodOne.isEvening == false) {
                    data.updatePeriodOneType('+Evening');
                  } else {
                    data.updatePeriodOneType('-Evening');
                  }
                },
                eveningChecked: data.getPeriodOne.isEvening != null &&
                    data.getPeriodOne.isEvening!,
                onWeekend: () {
                  if (data.getPeriodOne.isWeekend == null ||
                      data.getPeriodOne.isWeekend == false) {
                    data.updatePeriodOneType('+Weekend');
                  } else {
                    data.updatePeriodOneType('-Weekend');
                  }
                },
                weekendChecked: data.getPeriodOne.isWeekend != null &&
                    data.getPeriodOne.isWeekend!,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: '2nd Period',
                hasDropDown: true,
                onStartChanged: (value) {
                  data.setPeriodTwoStart(value);
                },
                onEndChanged: (value) {
                  data.setPeriodTwoEnd(value);
                },
                startVal: data.periodTwo.startTime,
                endVal: data.periodTwo.endTime,
                onTap: () {
                  if (data.getPeriodTwo.period == null) {
                    data.updatePeriodTwo('2nd Period');
                  } else {
                    data.updatePeriodTwo('');
                  }
                },
                isChecked: data.getPeriodTwo.period != null,
                onRegular: () {
                  if (data.getPeriodTwo.isRegular == null ||
                      data.getPeriodTwo.isRegular == false) {
                    data.updatePeriodTwoType('+Regular');
                  } else {
                    data.updatePeriodTwoType('-Regular');
                  }
                },
                regularChecked: data.getPeriodTwo.isRegular != null &&
                    data.getPeriodTwo.isRegular!,
                onEvening: () {
                  if (data.getPeriodTwo.isEvening == null ||
                      data.getPeriodTwo.isEvening == false) {
                    data.updatePeriodTwoType('+Evening');
                  } else {
                    data.updatePeriodTwoType('-Evening');
                  }
                },
                eveningChecked: data.getPeriodTwo.isEvening != null &&
                    data.getPeriodTwo.isEvening!,
                onWeekend: () {
                  if (data.getPeriodTwo.isWeekend == null ||
                      data.getPeriodTwo.isWeekend == false) {
                    data.updatePeriodTwoType('+Weekend');
                  } else {
                    data.updatePeriodTwoType('-Weekend');
                  }
                },
                weekendChecked: data.getPeriodTwo.isWeekend != null &&
                    data.getPeriodTwo.isWeekend!,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: '3rd Period',
                hasDropDown: true,
                onStartChanged: (value) {
                  data.setPeriodThreeStart(value);
                },
                onEndChanged: (value) {
                  data.setPeriodThreeEnd(value);
                },
                startVal: data.periodThree.startTime,
                endVal: data.periodThree.endTime,
                onTap: () {
                  if (data.getPeriodThree.period == null) {
                    data.updatePeriodThree('3rd Period');
                  } else {
                    data.updatePeriodThree('');
                  }
                },
                isChecked: data.getPeriodThree.period != null,
                onRegular: () {
                  if (data.getPeriodThree.isRegular == null ||
                      data.getPeriodThree.isRegular == false) {
                    data.updatePeriodThreeType('+Regular');
                  } else {
                    data.updatePeriodThreeType('-Regular');
                  }
                },
                regularChecked: data.getPeriodThree.isRegular != null &&
                    data.getPeriodThree.isRegular!,
                onEvening: () {
                  if (data.getPeriodThree.isEvening == null ||
                      data.getPeriodThree.isEvening == false) {
                    data.updatePeriodThreeType('+Evening');
                  } else {
                    data.updatePeriodThreeType('-Evening');
                  }
                },
                eveningChecked: data.getPeriodThree.isEvening != null &&
                    data.getPeriodThree.isEvening!,
                onWeekend: () {
                  if (data.getPeriodThree.isWeekend == null ||
                      data.getPeriodThree.isWeekend == false) {
                    data.updatePeriodThreeType('+Weekend');
                  } else {
                    data.updatePeriodThreeType('-Weekend');
                  }
                },
                weekendChecked: data.getPeriodThree.isWeekend != null &&
                    data.getPeriodThree.isWeekend!,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 25),
              CustomCheckBox(
                title: '4th Period',
                hasDropDown: true,
                onStartChanged: (value) {
                  data.setPeriodFourStart(value);
                },
                onEndChanged: (value) {
                  data.setPeriodFourEnd(value);
                },
                startVal: data.periodFour.startTime,
                endVal: data.periodFour.endTime,
                onTap: () {
                  if (data.getPeriodFour.period == null) {
                    data.updatePeriodFour('4th Period');
                  } else {
                    data.updatePeriodFour('');
                  }
                },
                isChecked: data.getPeriodFour.period != null,
                onRegular: () {
                  if (data.getPeriodFour.isRegular == null ||
                      data.getPeriodFour.isRegular == false) {
                    data.updatePeriodFourType('+Regular');
                  } else {
                    data.updatePeriodFourType('-Regular');
                  }
                },
                regularChecked: data.getPeriodFour.isRegular != null &&
                    data.getPeriodFour.isRegular!,
                onEvening: () {
                  if (data.getPeriodFour.isEvening == null ||
                      data.getPeriodFour.isEvening == false) {
                    data.updatePeriodFourType('+Evening');
                  } else {
                    data.updatePeriodFourType('-Evening');
                  }
                },
                eveningChecked: data.getPeriodFour.isEvening != null &&
                    data.getPeriodFour.isEvening!,
                onWeekend: () {
                  if (data.getPeriodFour.isWeekend == null ||
                      data.getPeriodFour.isWeekend == false) {
                    data.updatePeriodFourType('+Weekend');
                  } else {
                    data.updatePeriodFourType('-Weekend');
                  }
                },
                weekendChecked: data.getPeriodFour.isWeekend != null &&
                    data.getPeriodFour.isWeekend!,
              ),
              const SizedBox(height: 15),
            ],
          ));
    });
  }
}
