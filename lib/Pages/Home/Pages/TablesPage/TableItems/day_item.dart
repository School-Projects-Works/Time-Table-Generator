import 'package:aamusted_timetable_generator/Constants/custom_string_functions.dart';
import 'package:aamusted_timetable_generator/Models/Table/table_item_model.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/TableItems/table_item.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../Models/Config/period_model.dart';
import '../../../../../SateManager/hive_listener.dart';
import '../../../../../Services/file_service.dart';
import '../../../../../Styles/diagonal_widget.dart';
import '../../../../../Styles/colors.dart';

class DayItem extends StatefulWidget {
  const DayItem({super.key, required this.tables, this.day, this.periods});
  final List<TableItemModel> tables;
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

    // let print the first and second periods

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
      var data = widget.tables;
      //data.shuffle();
      var group = groupBy(data, (element) => element.venue);
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
                                                letterSpacing: 30,
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
