import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/provider/config_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/table_gen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'day_item.dart';

class TableWidget extends ConsumerStatefulWidget {
  const TableWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends ConsumerState<TableWidget> {
  @override
  Widget build(BuildContext context) {
    var config = ref.watch(configurationProvider);
    var data = StudyModeModel.fromMap(config.regular);
    var tables = ref.watch(filteredTableProvider);
    return SingleChildScrollView(
      child: Column(
        children: data.days.map((e) {
          var data1 = tables.where((element) => element.day == e).toList();

          if (data1.isEmpty) {
            return Container();
          }
          return DayItem(
            day: e,
          );
        }).toList(),
      ),
    );
  }
}
