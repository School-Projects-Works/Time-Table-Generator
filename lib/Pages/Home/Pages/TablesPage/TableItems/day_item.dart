// ignore_for_file: depend_on_referenced_packages

import 'package:aamusted_timetable_generator/Constants/custom_string_functions.dart';
import 'package:aamusted_timetable_generator/Models/Table/table_item_model.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/TableItems/table_item.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../Models/Config/period_model.dart';
import '../../../../../SateManager/hive_listener.dart';
import '../../../../../Services/file_service.dart';
import '../../../../../Styles/diagonal_widget.dart';
import '../../../../../Styles/colors.dart';

class DayItem extends StatefulWidget {
  const DayItem(
      {super.key,
      required this.tables,
      this.day,
      this.periods,
      required this.data});
  final List<TableItemModel> tables;
  final List<TableItemModel> data;
  final String? day;
  final List<PeriodModel>? periods;

  @override
  State<DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<DayItem> {
  List<PeriodModel> firstPeriods = [];
  List<PeriodModel> secondPeriods = [];
  PeriodModel? breakPeriod;
  Future<List<PeriodModel>> workOnPeriod() async {
    var periods = widget.periods;
    if (periods != null) {
      firstPeriods = [];
      secondPeriods = [];

      periods.sort((a, b) {
        TimeOfDay aTime = GlobalFunctions.timeFromString(a.startTime!);
        TimeOfDay bTime = GlobalFunctions.timeFromString(b.startTime!);
        return aTime.hour.compareTo(bTime.hour);
      });

      //split periods at where breakTime is
      breakPeriod = periods.firstWhereOrNull((element) =>
          element.period!.trimToLowerCase() == 'break'.trimToLowerCase());
      if (breakPeriod != null) {
        for (PeriodModel period in periods) {
          //we check if period start time is less than break time

          if (GlobalFunctions.timeFromString(period.startTime!).hour <
              GlobalFunctions.timeFromString(breakPeriod!.startTime!).hour) {
            firstPeriods.add(period);
          } else {
            if (GlobalFunctions.timeFromString(period.startTime!).hour >
                GlobalFunctions.timeFromString(breakPeriod!.startTime!).hour) {
              secondPeriods.add(period);
            }
          }
        }
      } else {
        firstPeriods = periods;
      }
    }

    return periods!;
  }

  final ValueNotifier<double> _columnViewSizeNotifier = ValueNotifier(0);
  final GlobalKey _columnKey = GlobalKey();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _updateScrollViewPadding();
    });
    super.initState();
    workOnPeriod();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HiveListener>(builder: (context, hive, child) {
      var data = widget.tables;
      var group = groupBy(data, (element) => element.venue);
      // sort the group by the key in ascending order
      var sortedKeys = group.keys.toList(growable: false)
        ..sort((k1, k2) => k1!.compareTo(k2!));
      return FutureBuilder<List<PeriodModel>>(
          future: workOnPeriod(),
          builder: (context, snapshot) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.day!,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: secondaryColor)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                              width: 260,
                              height: 70,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                              ),
                              child: CustomPaint(
                                painter: DiagonalLinePainter(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 25),
                                        child: Text('Venue',
                                            style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25),
                                        child: Text('Period',
                                            style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Row(
                            children: [
                              if (firstPeriods.isNotEmpty)
                                Row(
                                  children: firstPeriods
                                      .map((e) => Container(
                                            width: 260,
                                            height: 70,
                                            padding: const EdgeInsets.all(5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(e.period!,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    '${e.startTime} - ${e.endTime}',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        color: Colors.black)),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              if (breakPeriod != null)
                                Container(
                                  height: 70,
                                  width: 90,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      top: BorderSide(color: Colors.black),
                                      bottom: BorderSide(
                                          color: Colors.black, width: 2),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(breakPeriod!.startTime!,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      Text(breakPeriod!.endTime!,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              if (secondPeriods.isNotEmpty)
                                Row(
                                  children: secondPeriods
                                      .map((e) => Container(
                                            width: 260,
                                            height: 70,
                                            padding: const EdgeInsets.all(5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(e.period!,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    '${e.startTime} - ${e.endTime}',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        color: Colors.black)),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                            ],
                          )
                        ],
                      ),
                      if (widget.tables.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NotificationListener<SizeChangedLayoutNotification>(
                              onNotification: (notification) {
                                _updateScrollViewPadding();
                                return true;
                              },
                              child: SizeChangedLayoutNotifier(
                                child: Column(
                                  key: _columnKey,
                                  children: sortedKeys
                                      .map(
                                        (e) => TableItem(
                                          venue: e,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            if (firstPeriods.isNotEmpty)
                              Column(
                                children: sortedKeys
                                    .map(
                                      (venue) => Row(
                                        children: firstPeriods.map((period) {
                                          var table = widget.tables
                                              .firstWhereOrNull((element) =>
                                                  element.venue == venue &&
                                                  element.period ==
                                                      period.period);
                                          if (table != null) {
                                            return TableItem(
                                              table: table,
                                            );
                                          } else {
                                            return TableItem(
                                              metaData: {
                                                'day': widget.day,
                                                'period': period.period,
                                                'venue': venue,
                                                'periodMap': period.toMap(),
                                                'venueId': widget.tables
                                                    .firstWhereOrNull(
                                                        (element) =>
                                                            element.venue ==
                                                            venue)
                                                    ?.venueId,
                                              },
                                            );
                                          }
                                        }).toList(),
                                      ),
                                    )
                                    .toList(),
                              ),
                            if (breakPeriod != null)
                              ValueListenableBuilder<double>(
                                  valueListenable: _columnViewSizeNotifier,
                                  builder: (BuildContext context,
                                      double columnHeight, Widget? child) {
                                    var fontSize = columnHeight * .02;
                                    var spaceBetween = columnHeight * .1;
                                    if (columnHeight <= 100) {
                                      fontSize = columnHeight * .16;
                                      spaceBetween = columnHeight * .08;
                                    } else if (columnHeight > 100 &&
                                        columnHeight < 1100) {
                                      fontSize = columnHeight * .1;
                                      spaceBetween = columnHeight * .1;
                                    } else if (columnHeight >= 1100 &&
                                        columnHeight <= 1500) {
                                      fontSize = columnHeight * .046;
                                      spaceBetween = columnHeight * .15;
                                    } else if (columnHeight > 1500) {
                                      fontSize = 2500 * .025;
                                      spaceBetween = columnHeight * .15;
                                    }
                                    return Container(
                                      alignment: Alignment.center,
                                      width: 90,
                                      height: columnHeight,
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                          'BREAK',
                                          style: GoogleFonts.poppins(
                                              fontSize: fontSize,
                                              color: Colors.black,
                                              letterSpacing: spaceBetween,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                          //textDirection: TextDirection.ltr,
                                        ),
                                      ),
                                    );
                                  }),
                            if (secondPeriods.isNotEmpty)
                              Column(
                                children: sortedKeys
                                    .map(
                                      (venue) => Row(
                                        children: secondPeriods.map((period) {
                                          var table = widget.tables
                                              .firstWhereOrNull((element) =>
                                                  element.venue == venue &&
                                                  element.period ==
                                                      period.period);
                                          if (table != null) {
                                            return TableItem(
                                              table: table,
                                            );
                                          } else {
                                            return TableItem(
                                              metaData: {
                                                'day': widget.day,
                                                'period': period.period,
                                                'venue': venue,
                                                'periodMap': period.toMap(),
                                                'venueId': widget.tables
                                                    .firstWhereOrNull(
                                                        (element) =>
                                                            element.venue ==
                                                            venue)
                                                    ?.venueId,
                                              },
                                            );
                                          }
                                        }).toList(),
                                      ),
                                    )
                                    .toList(),
                              ),
                          ],
                        )
                    ]),
              ),
            );
          });
    });
  }

  void _updateScrollViewPadding() {
    final height = _columnKey.currentContext!.size!.height;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _columnViewSizeNotifier.value = height;
    });
  }
}
