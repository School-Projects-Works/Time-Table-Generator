// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CustomCheckBox.dart';

class PeriodSection extends StatelessWidget {
  const PeriodSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, data, child) {
      return Column(
        children: [
          Container(
              width: size.width * 0.55,
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
                      'Select periods on which class will take place for this targeted student group (${data.targetedStudents}).',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.grey,
                      )),
                  const SizedBox(height: 20),
                  CustomCheckBox(
                    title: '1st Period',
                    hasTime: true,
                    onStartChanged: (value) {
                      data.setPeriodOneStart(value);
                    },
                    onEndChanged: (value) {
                      data.setPeriodOneEnd(value);
                    },
                    startVal: data.getPeriodOne.startTime,
                    endVal: data.periodOne.endTime,
                    onTap: () {
                      if (data.getPeriodOne.period == null) {
                        data.updatePeriodOne('1st Period');
                      } else {
                        data.updatePeriodOne('');
                      }
                    },
                    isChecked: data.getPeriodOne.period != null,
                  ),
                  const Divider(color: Colors.grey, thickness: 1, height: 25),
                  CustomCheckBox(
                    title: '2nd Period',
                    hasTime: true,
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
                  ),
                  const Divider(color: Colors.grey, thickness: 1, height: 25),
                  CustomCheckBox(
                    title: '3rd Period',
                    hasTime: true,
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
                  ),
                  const Divider(color: Colors.grey, thickness: 1, height: 25),
                  CustomCheckBox(
                    title: '4th Period',
                    hasTime: true,
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
                  ),
                  const SizedBox(height: 15),
                ],
              )),
          Container(
            width: size.width * 0.55,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              Text(
                'Select Break',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                  'Select when there be break for the target of students (${data.targetedStudents}) if applicable.',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 20),
              CustomCheckBox(
                title: 'Break',
                hasTime: true,
                alwaysChecked: true,
                onStartChanged: (value) {
                  data.setPeriodFiveStart(value);
                },
                onEndChanged: (value) {
                  data.setPeriodFiveEnd(value);
                },
                startVal: data.getBreakTime.startTime,
                endVal: data.getBreakTime.endTime,
                onTap: () {
                  if (data.getBreakTime.period == null) {
                    data.updatePeriodFive('Break');
                  } else {
                    data.updatePeriodFive('');
                  }
                },
                isChecked: data.getBreakTime.period != null,
              ),
            ]),
          )
        ],
      );
    });
  }
}
