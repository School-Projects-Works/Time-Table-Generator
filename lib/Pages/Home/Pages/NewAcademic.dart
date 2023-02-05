// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Academic/AcademicModel.dart';
import 'package:aamusted_timetable_generator/Models/Config/ConfigModel.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../Components/CustomDropDown.dart';
import '../../../SateManager/NavigationProvider.dart';
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
    return Consumer<NavigationProvider>(builder: (context, nav, child) {
      return Container(
        alignment: Alignment.center,
        width: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: size.width * .6,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (nav.page == 6)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -10),
                          child: InkWell(
                            onTap: () {
                              Provider.of<NavigationProvider>(context,
                                      listen: false)
                                  .setPage(0);
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Create New Academic Year, Semester and Targeted Students under which you can add courses, Students, Venues and generate timetable for that semester',
                          style: GoogleFonts.nunito(
                              color: Colors.black, fontSize: 20),
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
                          height: 30,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: size.width * .25,
                          child: CustomButton(
                            onPressed: saveAcademic,
                            text: 'Save Academic Year',
                            color: secondaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void saveAcademic() {
    if (year != null && semester != null) {
      var provider = Provider.of<HiveListener>(context, listen: false);
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
          provider.setAcademicList(data);
          ConfigModel configurations = ConfigModel();
          configurations.academicName = academicModel.name;
          configurations.academicYear = academicModel.year;
          configurations.academicSemester = academicModel.semester;
          configurations.id =
              '${academicModel.id}_${provider.targetedStudents.trimToLowerCase()}';
          configurations.targetedStudents = provider.targetedStudents;
          HiveCache.addConfigurations(configurations);
          Provider.of<HiveListener>(context, listen: false).updateConfigList();
          CustomDialog.dismiss();
          CustomDialog.showSuccess(
            message: 'Academic Year Saved Successfully',
          );
        } else {
          CustomDialog.dismiss();
          CustomDialog.showError(
            message: 'An error occurred while saving academic year',
          );
        }
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
          message: 'This academic Year and semester Already Exists',
        );
      }
    } else {
      CustomDialog.showError(
        message: 'Please select a year , semester and targeted students',
      );
    }
  }
}
