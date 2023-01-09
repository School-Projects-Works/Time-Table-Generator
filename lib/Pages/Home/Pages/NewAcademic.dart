import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Academic/AcademicModel.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Components/CustomDropDown.dart';
import '../../../Styles/colors.dart';

class NewAcademic extends StatefulWidget {
  const NewAcademic({Key? key}) : super(key: key);

  @override
  State<NewAcademic> createState() => _NewAcademicState();
}

class _NewAcademicState extends State<NewAcademic> {
  String? year;
  String? semester;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Card(
        elevation: 10,
        child: SizedBox(
          width: size.width * .5,
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
                const Divider(
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Academic Year',
                        style: GoogleFonts.nunito(
                            color: Colors.black, fontSize: 20),
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
                                    value: '$i - ${i + 1}',
                                    child: Text(
                                      '$i - ${i + 1}',
                                      style: GoogleFonts.nunito(),
                                    ),
                                  ),
                              ],
                              color: background))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Semester',
                        style: GoogleFonts.nunito(
                            color: Colors.black, fontSize: 20),
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
                                  value: 'Semester1',
                                  child: Text(
                                    'Semester 1',
                                    style: GoogleFonts.nunito(),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Semester2',
                                  child: Text(
                                    'Semester 2',
                                    style: GoogleFonts.nunito(),
                                  ),
                                ),
                              ],
                              color: background))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: size.width * .25,
                  child: CustomButton(
                    onPressed: saveAcademic,
                    text: 'Save Academic Year',
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveAcademic() {
    if (year != null && semester != null) {
      CustomDialog.showLoading(message: 'Saving Academic Year');
      String id = "$year$semester".trimToLowerCase();
      AcademicModel academicModel = AcademicModel(
          id: id,
          year: year!,
          semester: semester!,
          createdAt: DateTime.now(),
          name: "$year $semester");
      var results = HiveCache.getSingleAcademic(id);
      if (results == null) {
        var data = HiveCache.saveAcademic(academicModel);
        if (data.isNotEmpty) {
          Provider.of<HiveListener>(context, listen: false)
              .setAcademicList(data);
          CustomDialog.dismiss();
          CustomDialog.showSuccess(
            message: 'Academic Year Saved Successfully',
          );
        } else {
          CustomDialog.dismiss();
          CustomDialog.showError(
            message: 'An error occured while saving academic year',
          );
        }
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
          message: 'This academic Year and seamester Already Exists',
        );
      }
    } else {
      CustomDialog.showError(
        message: 'Please select a year and semester',
      );
    }
  }
}
