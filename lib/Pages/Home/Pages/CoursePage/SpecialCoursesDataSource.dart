import 'package:aamusted_timetable_generator/Pages/Home/Pages/CoursePage/setSpecialVenuePage.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../Components/BreathingWidget.dart';
import '../../../../Models/Course/CourseModel.dart';
import '../../../../SateManager/HiveListener.dart';

class SpecialCourseDataSource extends DataTableSource {
  SpecialCourseDataSource(this.context);
  final BuildContext context;

  @override
  DataRow? getRow(int index) {
    var data = Provider.of<HiveListener>(context, listen: false)
        .getCourseList
        .where((element) => element.specialVenue!.toLowerCase() != "no")
        .toList();
    if (index >= data.length) return null;
    var course = data[index];
    final textStyle = GoogleFonts.nunito(
      fontSize: 15,
      color: Colors.black,
    );

    bool hasVenue = course.venues!.isNotEmpty;
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
            if (hasVenue) {
              return primaryColor;
            } else if (!hasVenue) {
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
          if (!hasVenue)
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
          if (hasVenue)
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
                        course.venues!.join(' or '),
                        style: textStyle,
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.check)
                    ],
                  ),
                ),
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
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => Provider.of<HiveListener>(context, listen: false)
      .getCourseList
      .where((element) => element.specialVenue!.toLowerCase() != "no")
      .toList()
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
