import 'package:aamusted_timetable_generator/core/functions/time_sorting.dart';
import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/provider/config_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/table_gen_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/views/componenets/single_item.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/theme/theme.dart';
import '../../components/daigonal_line.dart';
import '../../data/periods_model.dart';

class DayItem extends ConsumerStatefulWidget {
  const DayItem({super.key, required this.day});
  final String day;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayItemState();
}

class _DayItemState extends ConsumerState<DayItem> {
  List<PeriodsModel> firstPeriods = [];
  List<PeriodsModel> secondPeriods = [];
  PeriodsModel? breakPeriod;
  Future<List<PeriodsModel>> workOnPeriod() async {
    var config = ref.watch(configurationProvider);
    var configData = StudyModeModel.fromMap(config.regular);
    var periods =
        configData.periods.map((e) => PeriodsModel.fromMap(e)).toList();
    if (periods.isNotEmpty) {
      firstPeriods = [];
      secondPeriods = [];
      periods.sort((a, b) => compareTimeOfDay(stringToTimeOfDay(a.startTime), stringToTimeOfDay(b.startTime)));
      //split periods at where breakTime is
      breakPeriod = periods.firstWhereOrNull((element) =>
          element.period.toLowerCase().replaceAll(' ', '') == 'break'.trim());
      if (breakPeriod != null) {
        for (PeriodsModel period in periods) {
          //we check if period start time is less than break time
          if (stringToTimeOfDay(period.startTime).hour < stringToTimeOfDay(breakPeriod!.startTime).hour) {
            firstPeriods.add(period);
          } else if (stringToTimeOfDay(period.startTime).hour > stringToTimeOfDay(breakPeriod!.startTime).hour) {
            secondPeriods.add(period);
          }
        }
      } else {
        firstPeriods = periods;
      }
    }
    return periods;
  }

  @override
  void initState() {
    super.initState();
    //workOnPeriod();
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(filteredTableProvider).where(
        (element) => element.day.toLowerCase() == widget.day.toLowerCase()).toList();
    data.shuffle();
    var group = groupBy(data, (element) => element.venueName);
    return FutureBuilder<List<PeriodsModel>>(
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
                      Text(widget.day,
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
                                                Text(e.period,
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
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(breakPeriod!.startTime.toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      Text(breakPeriod!.endTime.toString(),
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
                                                Text(e.period,
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
                      if (data.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: group.keys
                                  .map(
                                    (e) => SingleItem(
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
                                          var table = data
                                              .firstWhereOrNull((element) =>
                                                  element.venueName == venue &&
                                                  element.period ==
                                                      period.period);
                                          if (table != null) {
                                            return SingleItem(
                                              table: table,
                                            );
                                          } else {
                                            return SingleItem();
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
                                          var table = data
                                              .firstWhereOrNull((element) =>
                                                  element.venueName == venue &&
                                                  element.period ==
                                                      period.period);
                                          if (table != null) {
                                            return SingleItem(
                                              table: table,
                                            );
                                          } else {
                                            return SingleItem();
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
  }
}
