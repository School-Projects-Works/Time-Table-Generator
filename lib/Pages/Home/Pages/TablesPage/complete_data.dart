// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Constants/custom_string_functions.dart';
import 'package:aamusted_timetable_generator/Models/Config/period_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Models/Table/table_item_model.dart';
import '../../../../SateManager/hive_listener.dart';
import '../../../../Services/file_service.dart';
import 'TableItems/day_item.dart';

class CompleteData extends StatefulWidget {
  const CompleteData({super.key});

  @override
  State<CompleteData> createState() => _CompleteDataState();
}

class _CompleteDataState extends State<CompleteData> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HiveListener>(builder: (context, hive, child) {
      var items = hive.getFilteredTableItems;
      List<PeriodModel> periods = hive.getCurrentConfig.periods!
          .map((e) => PeriodModel.fromMap(e))
          .toList();
      if (hive.getCurrentConfig.breakTime != null) {
        periods.add(PeriodModel.fromMap(hive.getCurrentConfig.breakTime!));
      }
      periods.sort((a, b) => GlobalFunctions.timeFromString(a.startTime!)
          .hour
          .compareTo(GlobalFunctions.timeFromString(b.startTime!).hour));
      return Expanded(
        child: Column(children: [
          Expanded(
              child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: items.isEmpty
                      ? Text(
                          'No ${hive.getTableType} table generated yet for ${hive.currentAcademicYear} ${hive.currentSemester} ${hive.targetedStudents} Students ',
                          style: GoogleFonts.nunito(),
                        )
                      : TablesWidget(
                          table: items,
                          hive: hive,
                          periods: periods,
                        )))
        ]),
      );
    });
  }
}

class TablesWidget extends StatelessWidget {
  const TablesWidget(
      {super.key,
      required this.table,
      required this.hive,
      required this.periods});
  final List<TableItemModel> table;
  final HiveListener hive;
  final List<PeriodModel> periods;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: hive.getCurrentConfig.days!.map((e) {
          var data1 = table.where((element) => element.day == e);

          if (data1.isEmpty) {
            return Container();
          }
          return DayItem(
            day: e,
            periods: periods,
            data: table,
            tables: table
                .where((element) =>
                    element.day!.toLowerCase().trimToLowerCase() ==
                    e.toLowerCase())
                .toList(),
          );
        }).toList(),
      ),
    );
  }
}
