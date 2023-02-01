import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Table/TableModel.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/TableItems/TableItem.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../Models/Config/PeriodModel.dart';
import '../../../../../Services/FileService.dart';
import '../../../../../Styles/DiagonalWidget.dart';
import '../../../../../Styles/colors.dart';

class DayItem extends StatefulWidget {
  const DayItem({super.key, required this.tables, this.day, this.periods});
  final List<TableModel> tables;
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
      periods.sort((a, b) => GlobalFunctions.timeFromString(a.startTime!)
          .hour
          .compareTo(GlobalFunctions.timeFromString(b.startTime!).hour));
      //split periods at where breakTime is
      breakPeriod = periods.firstWhereOrNull((element) =>
          element.period!.trimToLowerCase() == 'break'.trimToLowerCase());
      if (breakPeriod != null) {
        for (PeriodModel period in periods) {
          //we check if period start time is less than break time
          if (GlobalFunctions.timeFromString(period.startTime!).hour <
              GlobalFunctions.timeFromString(breakPeriod!.startTime!).hour) {
            firstPeriods.add(period);
          } else if (GlobalFunctions.timeFromString(period.startTime!).hour >
              GlobalFunctions.timeFromString(breakPeriod!.startTime!).hour) {
            secondPeriods.add(period);
          }
        }
      } else {
        firstPeriods = periods;
      }
    }
    return periods!;
  }

  @override
  void initState() {
    super.initState();
    workOnPeriod();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HiveListener>(builder: (context, hive, child) {
      var group = groupBy(widget.tables, (element) => element.venue);
      return FutureBuilder<List<PeriodModel>>(
          future: workOnPeriod(),
          builder: (context, snapshot) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
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
                                          padding:
                                              const EdgeInsets.only(top: 25),
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
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  Text(
                                                      '${e.startTime} - ${e.endTime}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black)),
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
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(breakPeriod!.startTime!,
                                            style: GoogleFonts.poppins(
                                                fontSize: 20,
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
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  Text(
                                                      '${e.startTime} - ${e.endTime}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black)),
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
                              Column(
                                children: group.keys
                                    .map(
                                      (e) => TableItem(
                                        venue: e,
                                      ),
                                    )
                                    .toList(),
                              ),
                              if (firstPeriods.isNotEmpty)
                                Column(
                                  children: group.keys
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
                                              return const TableItem();
                                            }
                                          }).toList(),
                                        ),
                                      )
                                      .toList(),
                                ),
                              if (breakPeriod != null)
                                SizedBox(
                                  width: 90,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            'BREAK',
                                            style: GoogleFonts.poppins(
                                                fontSize: 40,
                                                color: Colors.black,
                                                wordSpacing: 10,
                                                letterSpacing: 100,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (secondPeriods.isNotEmpty)
                                Column(
                                  children: group.keys
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
                                              return const TableItem();
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
              ),
            );
          });
    });
  }
}

class TableRow extends StatefulWidget {
  const TableRow(
      {super.key,
      required this.tables,
      this.venue,
      this.breakPeriod,
      required this.firstPeriod,
      required this.secondPeriod});
  final List<TableModel> tables;
  final String? venue;
  final PeriodModel? breakPeriod;
  final List<PeriodModel> firstPeriod, secondPeriod;
  @override
  State<TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<TableRow> {
  List<TableModel> firstSet = [];
  List<TableModel> secondSet = [];
  PeriodModel? breakPeriod;
  Future<List<TableModel>> workOnPeriod() async {
    var table = widget.tables;
    if (widget.breakPeriod != null) {
      firstSet = [];
      secondSet = [];
      table.sort((a, b) => GlobalFunctions.timeFromString(
              a.periodMap!['startTime']!)
          .hour
          .compareTo(
              GlobalFunctions.timeFromString(b.periodMap!['startTime']!).hour));

      if (breakPeriod != null) {
        for (TableModel tab in table) {
          //we check if period start time is less than break time
          if (GlobalFunctions.timeFromString(tab.periodMap!['startTime']!)
                  .hour <
              GlobalFunctions.timeFromString(breakPeriod!.startTime!).hour) {
            firstSet.add(tab);
          } else if (GlobalFunctions.timeFromString(
                      tab.periodMap!['startTime']!)
                  .hour >
              GlobalFunctions.timeFromString(breakPeriod!.startTime!).hour) {
            secondSet.add(tab);
          }
        }
      } else {
        firstSet = table;
      }
    }
    return table!;
  }

  @override
  void initState() {
    super.initState();
    workOnPeriod();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TableModel>>(
        future: workOnPeriod(),
        builder: (context, snapshot) {
          //print break period
          if (widget.breakPeriod != null) {
            breakPeriod = widget.breakPeriod;
          }
          //print second period
          for (var o in widget.secondPeriod) {
            print(o.period);
          }
          return Row(
            children: [
              TableItem(
                venue: widget.venue,
              ),
              if (widget.firstPeriod.isNotEmpty)
                Row(children: [
                  for (PeriodModel period in widget.firstPeriod)
                    widget.tables.firstWhereOrNull(
                                (element) => element.period == period.period) !=
                            null
                        ? TableItem(
                            table: widget.tables.firstWhere(
                                (element) => element.period == period.period),
                          )
                        : const TableItem()
                ]),

              if (breakPeriod != null)
                const SizedBox(
                  height: 100,
                  width: 120,
                ),
              if (widget.secondPeriod.isNotEmpty)
                Row(
                  children: [
                    for (PeriodModel period in widget.secondPeriod)
                      widget.tables.firstWhereOrNull((element) =>
                                  element.period == period.period) !=
                              null
                          ? TableItem(
                              table: widget.tables.firstWhere(
                                  (element) => element.period == period.period),
                            )
                          : const TableItem()
                  ],
                ),
              // widget.tables
              //         .where((element) =>
              //             element.period.toString().trimToLowerCase().contains('1'))
              //         .isNotEmpty
              //     ? TableItem(
              //         table: widget.tables
              //             .where((element) => element.period
              //                 .toString()
              //                 .trimToLowerCase()
              //                 .contains('1'))
              //             .first,
              //       )
              //     : const TableItem(),
              // widget.tables
              //         .where((element) =>
              //             element.period.toString().trimToLowerCase().contains('2'))
              //         .isNotEmpty
              //     ? TableItem(
              //         table: widget.tables
              //             .where((element) => element.period
              //                 .toString()
              //                 .trimToLowerCase()
              //                 .contains('2'))
              //             .first,
              //       )
              //     : const TableItem(),
              // const SizedBox(
              //   height: 100,
              //   width: 120,
              //   child: Text('Lunch', style: TextStyle(fontSize: 20)),
              // ),
              // widget.tables
              //         .where((element) =>
              //             element.period.toString().trimToLowerCase().contains('3'))
              //         .isNotEmpty
              //     ? TableItem(
              //         table: widget.tables
              //             .where((element) => element.period
              //                 .toString()
              //                 .trimToLowerCase()
              //                 .contains('3'))
              //             .first,
              //       )
              //     : const TableItem(),
              // widget.tables
              //         .where((element) =>
              //             element.period.toString().trimToLowerCase().contains('4'))
              //         .isNotEmpty
              //     ? TableItem(
              //         table: widget.tables
              //             .where((element) => element.period
              //                 .toString()
              //                 .trimToLowerCase()
              //                 .contains('4'))
              //             .first,
              //       )
              //     : const TableItem(),
            ],
          );
        });
  }
}
