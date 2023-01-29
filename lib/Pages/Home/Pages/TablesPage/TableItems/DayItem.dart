import 'package:aamusted_timetable_generator/Constants/CustomStringFunctions.dart';
import 'package:aamusted_timetable_generator/Models/Table/TableModel.dart';
import 'package:aamusted_timetable_generator/Pages/Home/Pages/TablesPage/TableItems/TableItem.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../SateManager/ConfigDataFlow.dart';
import '../../../../../Styles/DiagonalWidget.dart';
import '../../../../../Styles/colors.dart';

class DayItem extends StatefulWidget {
  const DayItem({super.key, required this.tables, this.day});
  final List<TableModel> tables;
  final String? day;

  @override
  State<DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<DayItem> {
  @override
  Widget build(BuildContext context) {
    var group = groupBy(widget.tables, (element) => element.venue);
    return Consumer<ConfigDataFlow>(builder: (context, config, child) {
      var periods = config.configurations.periods;
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
                          fontSize: 25, color: secondaryColor)),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
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
                                    padding: const EdgeInsets.only(bottom: 25),
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
                      Container(
                          width: 260,
                          height: 70,
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '1',
                                  style: DefaultTextStyle.of(context).style,
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: 'st',
                                        style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.ideographic)),
                                    TextSpan(
                                        text: ' - ',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    TextSpan(
                                        text: '3',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    TextSpan(
                                        text: 'rd',
                                        style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.ideographic)),
                                  ],
                                ),
                              ),
                              if (periods!
                                  .where((element) => element['period']
                                      .toString()
                                      .contains('1'))
                                  .isNotEmpty)
                                Text(
                                    '${periods.where((element) => element['period'].toString().contains('1')).first['startTime'].toString()} - ${periods.where((element) => element['period'].toString().contains('1')).first['endTime'].toString()}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: Colors.black)),
                            ],
                          )),
                      Container(
                          width: 260,
                          height: 70,
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '4',
                                  style: DefaultTextStyle.of(context).style,
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: 'th',
                                        style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.ideographic)),
                                    TextSpan(
                                        text: ' - ',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    TextSpan(
                                        text: '6',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    TextSpan(
                                        text: 'th',
                                        style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.ideographic)),
                                  ],
                                ),
                              ),
                              if (periods!
                                  .where((element) => element['period']
                                      .toString()
                                      .contains('2'))
                                  .isNotEmpty)
                                Text(
                                    '${periods.where((element) => element['period'].toString().contains('2')).first['startTime'].toString()} - ${periods.where((element) => element['period'].toString().contains('2')).first['endTime'].toString()}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: Colors.black)),
                            ],
                          )),
                      Container(
                          width: 120,
                          height: 70,
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '7',
                                  style: DefaultTextStyle.of(context).style,
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: 'th',
                                        style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.ideographic)),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Container(
                          width: 260,
                          height: 70,
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '8',
                                  style: DefaultTextStyle.of(context).style,
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: 'th',
                                        style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.ideographic)),
                                    TextSpan(
                                        text: ' - ',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    TextSpan(
                                        text: '10',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    TextSpan(
                                        text: 'th',
                                        style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.ideographic)),
                                  ],
                                ),
                              ),
                              if (periods
                                  .where((element) => element['period']
                                      .toString()
                                      .contains('3'))
                                  .isNotEmpty)
                                Text(
                                    '${periods.where((element) => element['period'].toString().contains('3')).first['startTime'].toString()} - ${periods.where((element) => element['period'].toString().contains('3')).first['endTime'].toString()}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: Colors.black)),
                            ],
                          )),
                      Container(
                          width: 260,
                          height: 70,
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '11',
                                  style: DefaultTextStyle.of(context).style,
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: 'th',
                                        style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.ideographic)),
                                    TextSpan(
                                        text: ' - ',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    TextSpan(
                                        text: '13',
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    TextSpan(
                                        text: 'th',
                                        style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.ideographic)),
                                  ],
                                ),
                              ),
                              if (periods
                                  .where((element) => element['period']
                                      .toString()
                                      .contains('4'))
                                  .isNotEmpty)
                                Text(
                                    '${periods.where((element) => element['period'].toString().contains('4')).first['startTime'].toString()} - ${periods.where((element) => element['period'].toString().contains('4')).first['endTime'].toString()}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: Colors.black)),
                            ],
                          )),
                    ],
                  ),
                  ...group.entries
                      .map((e) => TableRow(
                            tables: e.value,
                            venue: e.key,
                          ))
                      .toList(),
                ]),
          ),
        ),
      );
    });
  }
}

class TableRow extends StatefulWidget {
  const TableRow({super.key, required this.tables, this.venue});
  final List<TableModel> tables;
  final String? venue;
  @override
  State<TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<TableRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TableItem(
          venue: widget.venue,
        ),
        widget.tables
                .where((element) =>
                    element.period.toString().trimToLowerCase().contains('1'))
                .isNotEmpty
            ? TableItem(
                table: widget.tables
                    .where((element) => element.period
                        .toString()
                        .trimToLowerCase()
                        .contains('1'))
                    .first,
              )
            : const TableItem(),
        widget.tables
                .where((element) =>
                    element.period.toString().trimToLowerCase().contains('2'))
                .isNotEmpty
            ? TableItem(
                table: widget.tables
                    .where((element) => element.period
                        .toString()
                        .trimToLowerCase()
                        .contains('2'))
                    .first,
              )
            : const TableItem(),
        Container(
          height: 100,
          width: 120,
        ),
        widget.tables
                .where((element) =>
                    element.period.toString().trimToLowerCase().contains('3'))
                .isNotEmpty
            ? TableItem(
                table: widget.tables
                    .where((element) => element.period
                        .toString()
                        .trimToLowerCase()
                        .contains('3'))
                    .first,
              )
            : const TableItem(),
        widget.tables
                .where((element) =>
                    element.period.toString().trimToLowerCase().contains('4'))
                .isNotEmpty
            ? TableItem(
                table: widget.tables
                    .where((element) => element.period
                        .toString()
                        .trimToLowerCase()
                        .contains('4'))
                    .first,
              )
            : const TableItem(),
      ],
    );
  }
}
