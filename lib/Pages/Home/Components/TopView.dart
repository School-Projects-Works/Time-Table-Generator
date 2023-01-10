import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Components/CustomDropDown.dart';

import 'package:aamusted_timetable_generator/Services/FileService.dart';

import 'package:aamusted_timetable_generator/SateManager/NavigationProvider.dart';

import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../SateManager/ConfigDataFlow.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                    angle: 6.1,
                    child: Text(
                      'A',
                      style: GoogleFonts.adamina(
                          color: secondaryColor,
                          fontSize: 50,
                          fontWeight: FontWeight.w700),
                    )),
                Text(
                  'Tt',
                  style: GoogleFonts.pacifico(
                      fontSize: 50,
                      color: primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                Transform.rotate(
                    angle: 6.1,
                    child: Text(
                      'G',
                      style: GoogleFonts.russoOne(
                          fontSize: 50,
                          color: secondaryColor,
                          fontWeight: FontWeight.w700),
                    ))
              ],
            ),
            SizedBox(
              width: size.width * 0.4,
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
                        Provider.of<ConfigDataFlow>(context, listen: false)
                            .updateConfigurations(config);
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
              height: 50,
              child: CustomButton(
                  onPressed: () {
                    ExcelService.readExcelFile();
                  },
                  text: 'Add Academic Year'),
            ),
            if (mongo.getAcademicList.isNotEmpty)
              SizedBox(
                  height: 50,
                  child: CustomButton(
                      onPressed: addNewAcademic, text: 'Add Academic Year')),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    });
  }

  void addNewAcademic() {
    Provider.of<NavigationProvider>(context, listen: false).setPage(7);
  }
}
