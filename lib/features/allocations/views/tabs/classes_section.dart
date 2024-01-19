import 'package:aamusted_timetable_generator/core/widget/custom_input.dart';
import 'package:aamusted_timetable_generator/core/widget/table/widgets/custom_table.dart';
import 'package:aamusted_timetable_generator/features/allocations/data/classes/class_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassesTab extends ConsumerStatefulWidget {
  const ClassesTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassesTabState();
}

class _ClassesTabState extends ConsumerState<ClassesTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: CustomTable<ClassModel>(
        header: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            width: 600,
            child: CustomTextFields(
              hintText: 'Search for a class',
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
