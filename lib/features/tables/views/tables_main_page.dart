import 'package:aamusted_timetable_generator/features/tables/views/complete_data.dart';
import 'package:aamusted_timetable_generator/features/tables/views/ibcomplete_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../usecase/condition.dart';

class TablesMainPage extends ConsumerStatefulWidget {
  const TablesMainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TablesMainPageState();
}

class _TablesMainPageState extends ConsumerState<TablesMainPage> {
  @override
  Widget build(BuildContext context) {
    var conditions = IncompleteConditions(ref: ref);
    if (!conditions.allocationExists() ||
        !conditions.venueExists() ||
        !conditions.configExists() ||
        !conditions.oneStudyModeExists() ||
        !conditions.regularLibConfigExists() ||
        !conditions.specialVenuesFixed()||
        !conditions.eveningLibConfigExists()) {
      return const IncompleteDataPage();
    }
    return const CompleteDataPage();
  }
}
