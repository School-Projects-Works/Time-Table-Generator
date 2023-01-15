// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Models/Course/CourseModel.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/CoursePage/setSpecialVenuePage.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Components/BreathingWidget.dart';

class CoursesDataSource extends DataTableSource {
  final BuildContext context;

  CoursesDataSource(this.context);
  @override
  DataRow? getRow(int index) {
    var data =
        Provider.of<HiveListener>(context, listen: false).getFilteredCourses;
    var venue = Provider.of<HiveListener>(context, listen: false).getVenues;

    if (index >= data.length) return null;
    var course = data[index];
    bool isSpecialVenue = course.specialVenue!.toLowerCase() != "no";
    bool hasVenue = venue.any((element) =>
        element.name!.toLowerCase() == course.specialVenue!.toLowerCase());
    final textStyle = GoogleFonts.nunito(
      fontSize: 15,
      color: Colors.black,
    );
    return DataRow.byIndex(
      selected: Provider.of<HiveListener>(context, listen: false)
          .getSelectedCourses
          .contains(course),
      onSelectChanged: (value) {
        if (value!) {
          Provider.of<HiveListener>(context, listen: false)
              .addSelectedCourses([course]);
        } else {
          Provider.of<HiveListener>(context, listen: false)
              .removeSelectedCourses([course]);
        }
      },
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          const Set<MaterialState> interactiveStates = <MaterialState>{
            MaterialState.pressed,
            MaterialState.hovered,
            MaterialState.focused,
          };

          if (states.any(interactiveStates.contains)) {
            return Colors.blue.withOpacity(.2);
          }
          if (isSpecialVenue && hasVenue) {
            return Colors.green;
          } else if (isSpecialVenue && !hasVenue) {
            return Colors.red.withOpacity(.6);
          } else if (Provider.of<HiveListener>(context, listen: false)
              .getSelectedCourses
              .contains(course)) {
            return Colors.blue.withOpacity(.7);
          }
          return null;
        },
      ),
      index: index,
      cells: [
        DataCell(Checkbox(
          checkColor: primaryColor,
          activeColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              const Set<MaterialState> interactiveStates = <MaterialState>{
                MaterialState.pressed,
                MaterialState.hovered,
                MaterialState.focused,
              };

              if (states.any(interactiveStates.contains)) {
                return Colors.black.withOpacity(.5);
              } else {
                return Colors.black.withOpacity(.5);
              }
            },
          ),
          value: Provider.of<HiveListener>(context, listen: false)
              .getSelectedCourses
              .contains(course),
          onChanged: (val) {
            if (val!) {
              Provider.of<HiveListener>(context, listen: false)
                  .addSelectedCourses([course]);
            } else {
              Provider.of<HiveListener>(context, listen: false)
                  .removeSelectedCourses([course]);
            }
          },
        )),
        DataCell(Text(
          course.code!,
          style: textStyle,
        )),
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Text(
            course.title!,
            style: textStyle,
          ),
        )),
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text(
            course.creditHours!,
            style: textStyle,
          ),
        )),
        if (isSpecialVenue && !hasVenue)
          DataCell(InkWell(
            onTap: () => setSpecialVenue(course),
            child: BreathingWidget(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course.specialVenue!,
                      style: textStyle,
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.warning)
                  ],
                ),
              ),
            ),
          )),
        if (isSpecialVenue && hasVenue)
          DataCell(InkWell(
            onTap: () => setSpecialVenue(course),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course.specialVenue!,
                      style: textStyle,
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.check)
                  ],
                ),
              ),
            ),
          )),
        if (!isSpecialVenue)
          DataCell(ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: Text(
              course.specialVenue!,
              style: textStyle,
            ),
          )),
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Text(
            course.department!,
            style: textStyle,
          ),
        )),
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Text(
            course.lecturerName!,
            style: textStyle,
          ),
        )),
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Text(
            course.lecturerEmail!,
            style: textStyle,
          ),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => Provider.of<HiveListener>(context, listen: false)
      .getFilteredCourses
      .length;

  @override
  int get selectedRowCount => 0;

  setSpecialVenue(CourseModel course) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (_, __, ___) => SetSpecialVenue(
          course: course,
        ),
      ),
    );
  }
}
