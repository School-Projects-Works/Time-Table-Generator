import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/lecturer_course_class_pair.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/liberay/liberal_time_pair.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/others/other_table_gen_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/special/special_table_gen_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/unsaved_tables_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/venue_time_pair_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../liberay/liberal_tables_gen_provider.dart';

final tableGenerationProvider =
    StateNotifierProvider<TableGenerationProvider, void>(
        (ref) => TableGenerationProvider());

class TableGenerationProvider extends StateNotifier<void> {
  TableGenerationProvider() : super(null);

  void generateTable(WidgetRef ref) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Generating Table.....');
    ref.read(venueTimePairProvider.notifier).generateVTP(ref);
    var vtps = ref.watch(venueTimePairProvider);
    ref.read(liberalTimePairProvider.notifier).generateLTP(ref);
    ref.read(liberalTableGenerationProvider.notifier).generateTables(ref);
    // //! generate the LCCP data
    // ref.read(lecturerCourseClassPairProvider.notifier).generateLCCP(ref);
    // //! generate the special table
    // ref.read(spcialTableGenProvider.notifier).generateTable(ref);
    // //! generate the other table
    // ref.read(otherTableGenProvider.notifier).generateTable(ref);
    ref.read(unsavedTableProvider.notifier).saveTables(ref);
    CustomDialog.dismiss();
  }
}
