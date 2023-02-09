// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/custom_button.dart';
import 'package:aamusted_timetable_generator/Constants/custom_string_functions.dart';
import 'package:aamusted_timetable_generator/SateManager/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Components/smart_dialog.dart';
import '../../Models/Config/config_model.dart';
import '../../SateManager/hive_cache.dart';
import '../../SateManager/hive_listener.dart';
import '../../Styles/colors.dart';
import 'Pages/VenuePage/venue_page.dart';
import 'Components/side_bar.dart';
import 'Components/top_view.dart';
import 'Pages/ClassPage/classes_page.dart';
import 'Pages/ConfigPage/configurations_page.dart';
import 'Pages/CoursePage/courses_page.dart';
import 'Pages/LiberalPage/liberal_page.dart';
import 'Pages/TablesPage/timetable_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<NavigationProvider>(builder: (context, nav, child) {
      return Consumer<HiveListener>(builder: (context, hive, child) {
        return SizedBox(
          width: double.infinity,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopView(),
              if (hive.getCurrentConfig.id == null)
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        RichText(
                          text: TextSpan(
                              text:
                                  'You do not have any configurations for the selected:\n',
                              style: GoogleFonts.nunito(
                                  color: Colors.black45,
                                  fontSize: size.width * .012,
                                  fontWeight: FontWeight.w700),
                              children: [
                                TextSpan(
                                    text: 'Academic Year :',
                                    style: GoogleFonts.nunito(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' ${hive.currentAcademicYear}\n',
                                    style: GoogleFonts.nunito(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: 'Academic Semester :',
                                    style: GoogleFonts.nunito(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' ${hive.currentSemester}\n',
                                    style: GoogleFonts.nunito(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: 'Student Type :',
                                    style: GoogleFonts.nunito(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' ${hive.targetedStudents}\n',
                                    style: GoogleFonts.nunito(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                            width: size.width * .2,
                            child: CustomButton(
                                onPressed: () {
                                  createNewConfig();
                                },
                                text: 'Create Config'))
                      ]),
                )),
              if (hive.getCurrentConfig.id != null)
                Expanded(
                  child: Row(
                    children: [
                      const SideBard(),
                      Consumer<HiveListener>(builder: (context, hive, child) {
                        return Expanded(
                          child: Container(
                              height: size.height,
                              margin: const EdgeInsets.only(
                                  left: 10, top: 10, right: 5, bottom: 5),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: background,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10))),
                              child: IndexedStack(
                                index: nav.page,
                                children: const [
                                  // NewAcademic(),
                                  Configuration(),
                                  CoursesPage(),
                                  ClassesPage(),
                                  LiberalPage(),
                                  VenuePage(),
                                  TimeTablePage(),
                                ],
                              )),
                        );
                      })
                    ],
                  ),
                )
            ],
          ),
        );
      });
    });
  }

  void createNewConfig() {
    var provider = Provider.of<HiveListener>(context, listen: false);
    CustomDialog.showLoading(message: 'Creating Configurations....');
    ConfigModel configurations = ConfigModel();
    configurations.academicName =
        '${provider.currentAcademicYear} ${provider.currentSemester}';
    configurations.academicYear = provider.currentAcademicYear;
    configurations.academicSemester = provider.currentSemester;
    configurations.id =
        '_${provider.currentAcademicYear}_${provider.currentSemester}_${provider.targetedStudents}'
            .trimToLowerCase();
    configurations.targetedStudents = provider.targetedStudents;
    HiveCache.addConfigurations(configurations);
    Provider.of<HiveListener>(context, listen: false).updateConfigList();
    CustomDialog.dismiss();
    CustomDialog.showSuccess(
      message:
          'Configuration successfully created!! Proceed to add Required data and generate Tables.',
    );
  }
}
