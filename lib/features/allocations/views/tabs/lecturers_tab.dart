import 'package:aamusted_timetable_generator/features/allocations/data/courses/courses_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widget/custom_input.dart';
import '../../../../core/widget/table/widgets/custom_table.dart';

class LecturersTab extends ConsumerStatefulWidget {
  const LecturersTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LecturersTabState();
}

class _LecturersTabState extends ConsumerState<LecturersTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: CustomTable<CourseModel>(
        header: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            width: 600,
            child: CustomTextFields(
              hintText: 'Search for a lecturer',
              suffixIcon: const Icon(FluentIcons.search),
              onChanged: (value) {},
            ),
          ),
        ]),
        data: [],
        columns: [],
        rows: [],
      ),
    );
  }
}
