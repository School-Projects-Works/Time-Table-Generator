import 'package:aamusted_timetable_generator/Components/custom_dropdown.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../Constants/constant.dart';
import '../../../SateManager/hive_listener.dart';

class TopView extends StatefulWidget {
  const TopView({Key? key}) : super(key: key);

  @override
  State<TopView> createState() => _TopViewState();
}

class _TopViewState extends State<TopView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, mongo, child) {
      return Container(
        height: 90,
        color: background,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', height: 80),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              width: size.width * 0.25,
              child: Row(
                children: [
                  Text(
                    'Academic Year : ',
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomDropDown(
                        hintText: 'Select Academic Year',
                        radius: 10,
                        color: background,
                        value: mongo.currentAcademicYear,
                        onChanged: (value) {
                          mongo.updateCurrentAcademicYear(value);
                        },
                        items: Constant.academicYear
                            .map((val) => DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                    style: GoogleFonts.nunito(),
                                  ),
                                ))
                            .toList()),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.2,
              child: Row(
                children: [
                  Text(
                    'Semester : ',
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomDropDown(
                      hintText: 'Select Academic Semester',
                      radius: 10,
                      color: background,
                      value: mongo.currentSemester,
                      onChanged: (value) {
                        mongo.updateCurrentSemester(value);
                      },
                      items: Constant.semesters
                          .map((val) => DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                  style: GoogleFonts.nunito(),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.22,
              child: Row(
                children: [
                  Text(
                    'Students Type : ',
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomDropDown(
                      hintText: 'Select Targeted Students',
                      radius: 10,
                      color: background,
                      value: mongo.targetedStudents,
                      onChanged: (value) {
                        mongo.updateTargetedStudents(value);
                      },
                      items: Constant.studentTypes
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: GoogleFonts.nunito(),
                              )))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    });
  }
}
