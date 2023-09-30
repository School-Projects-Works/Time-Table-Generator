import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/excel_file_provider.dart';

class LiberalCoursesPage extends ConsumerStatefulWidget {
  const LiberalCoursesPage({super.key});

  @override
  ConsumerState<LiberalCoursesPage> createState() => _LiberalCoursesPageState();
}

class _LiberalCoursesPageState extends ConsumerState<LiberalCoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text('Liberal Courses'.toUpperCase(),
                      style: FluentTheme.of(context).typography.title),
                  const Spacer(),
                  FilledButton(
                      child: const Text('Import Liberal'),
                      onPressed: () {
                        ref
                            .read(excelFileProvider.notifier)
                            .generateLiberalExcelFile(context);
                      }),
                  const SizedBox(width: 10),
                   Button(
                      style: ButtonStyle(
                          border:
                              ButtonState.all(BorderSide(color: Colors.green))),
                      child: const Text('Liberal Template'),
                      onPressed: () {
                        ref
                            .read(excelFileProvider.notifier)
                            .generateLiberalExcelFile(context);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
