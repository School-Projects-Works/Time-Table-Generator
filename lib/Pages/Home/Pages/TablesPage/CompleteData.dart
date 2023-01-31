// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Config/PeriodModel.dart';

import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../Services/FileService.dart';
import 'TableItems/DayItem.dart';

class CompleteData extends StatefulWidget {
  const CompleteData({super.key});

  @override
  State<CompleteData> createState() => _CompleteDataState();
}

class _CompleteDataState extends State<CompleteData> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HiveListener>(builder: (context, hive, child) {
      var table = hive.getTables;
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
          if (table != null)
            Expanded(
                child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: table.isEmpty
                        ? Text(
                            'Notable generated yet',
                            style: GoogleFonts.nunito(),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: hive.getCurrentConfig.days!
                                  .map((e) => DayItem(
                                        day: e,
                                        periods: periods,
                                        tables: table
                                            .where((element) =>
                                                element.day!
                                                    .toLowerCase()
                                                    .trimToLowerCase() ==
                                                e.toLowerCase())
                                            .toList(),
                                      ))
                                  .toList(),
                            ),
                          )))
        ]),
      );
    });
  }
}
