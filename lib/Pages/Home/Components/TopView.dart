// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Components/CustomDropDown.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/HelpPage.dart';
import 'package:aamusted_timetable_generator/SateManager/NavigationProvider.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../SateManager/HiveCache.dart';
import '../../../SateManager/HiveListener.dart';

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
            SizedBox(
              width: size.width * 0.3,
              child: Row(
                children: [
                  Text(
                    'Current Academic Year : ',
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
                        var id = mongo.getAcademicList
                            .firstWhere((element) => element.name == value)
                            .id;
                        var config = HiveCache.getConfig(id);
                        Provider.of<HiveListener>(context, listen: false)
                            .updateCurrentConfig(config);
                      },
                      items: mongo.getAcademicList
                          .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(
                                e.name!,
                                style: GoogleFonts.nunito(),
                              )))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.3,
              child: Row(
                children: [
                  Text(
                    'Targeted Students : ',
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
                      items: ['Regular', 'Weekend', 'Evening', 'Sandwich']
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
            if (mongo.getAcademicList.isNotEmpty)
              SizedBox(
                  height: 50,
                  child: CustomButton(
                      onPressed: addNewAcademic, text: 'Add Configurations')),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    });
  }

  void addNewAcademic() {
    Provider.of<NavigationProvider>(context, listen: false).setPage(6);
  }
}
