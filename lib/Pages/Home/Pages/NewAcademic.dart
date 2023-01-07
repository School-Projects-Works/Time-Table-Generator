import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Components/CustomDropDown.dart';
import '../../../Styles/colors.dart';

class NewAcademic extends StatefulWidget {
  const NewAcademic({Key? key}) : super(key: key);

  @override
  State<NewAcademic> createState() => _NewAcademicState();
}

class _NewAcademicState extends State<NewAcademic> {
  String? year;
  int? semester;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Card(
        elevation: 10,
        child: SizedBox(
          width: size.width * .6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No Academic Year Found. Please add at least one academic year and semester to proceed.',
                  style: GoogleFonts.nunito(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Select Academic Year',
                      style:
                          GoogleFonts.nunito(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 200,
                        child: CustomDropDown(
                            onChanged: (value) {
                              setState(() {
                                year = value;
                              });
                            },
                            items: [
                              for (int i = DateTime.now().year;
                                  i < DateTime.now().year + 10;
                                  i++)
                                DropdownMenuItem(
                                  value: i,
                                  child: Text(
                                    '$i - ${i + 1}',
                                    style: GoogleFonts.nunito(),
                                  ),
                                ),
                            ],
                            color: background))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Select Semester',
                      style:
                          GoogleFonts.nunito(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 200,
                        child: CustomDropDown(
                            onChanged: (value) {
                              setState(() {
                                semester = value;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  'Semester 1',
                                  style: GoogleFonts.nunito(),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                  'Semester 2',
                                  style: GoogleFonts.nunito(),
                                ),
                              ),
                            ],
                            color: background))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onPressed: saveAcademic,
                  text: 'Save Academic Year',
                  color: primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveAcademic() {}
}
