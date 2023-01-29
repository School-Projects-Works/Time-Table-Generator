// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/CustomTable.dart';
import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/SateManager/ConfigDataFlow.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'TableDataSource.dart';
import 'TableItems/DayItem.dart';

class CompleteData extends StatefulWidget {
  const CompleteData({super.key});

  @override
  State<CompleteData> createState() => _CompleteDataState();
}

class _CompleteDataState extends State<CompleteData> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, hive, child) {
      var table = hive.getTables;
      return Consumer<ConfigDataFlow>(builder: (context, config, child) {
        var periods = config.configurations.periods;
        return Expanded(
          child: Column(children: [
            Expanded(
                child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: table!.isEmpty
                        ? Text(
                            'Notable generated yet',
                            style: GoogleFonts.nunito(),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                DayItem(
                                  day: 'MONDAY',
                                  tables: table
                                      .where((element) =>
                                          element.day!
                                              .toLowerCase()
                                              .trimToLowerCase() ==
                                          'monday')
                                      .toList(),
                                ),
                                DayItem(
                                  day: 'TUESDAY',
                                  tables: table
                                      .where((element) =>
                                          element.day!
                                              .toLowerCase()
                                              .trimToLowerCase() ==
                                          'tuesday')
                                      .toList(),
                                ),
                                DayItem(
                                  day: 'WEDNESDAY',
                                  tables: table
                                      .where((element) =>
                                          element.day!
                                              .toLowerCase()
                                              .trimToLowerCase() ==
                                          'wednesday')
                                      .toList(),
                                ),
                                DayItem(
                                  day: 'THURSDAY',
                                  tables: table
                                      .where((element) =>
                                          element.day!
                                              .toLowerCase()
                                              .trimToLowerCase() ==
                                          'thursday')
                                      .toList(),
                                ),
                                DayItem(
                                  day: 'FRIDAY',
                                  tables: table
                                      .where((element) =>
                                          element.day!
                                              .toLowerCase()
                                              .trimToLowerCase() ==
                                          'friday')
                                      .toList(),
                                ),
                                DayItem(
                                  day: 'SATURDAY',
                                  tables: table
                                      .where((element) =>
                                          element.day!
                                              .toLowerCase()
                                              .trimToLowerCase() ==
                                          'saturday')
                                      .toList(),
                                ),
                                DayItem(
                                  day: 'SUNDAY',
                                  tables: table
                                      .where((element) =>
                                          element.day!
                                              .toLowerCase()
                                              .trimToLowerCase() ==
                                          'sunday')
                                      .toList(),
                                ),
                              ],
                            ),
                          )))
          ]),
        );
      });
    });
  }
}
