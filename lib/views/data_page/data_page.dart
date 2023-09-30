import 'package:aamusted_timetable_generator/riverpod/excel_file_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tabs/class_screen.dart';

class DataPage extends ConsumerStatefulWidget {
  const DataPage({super.key});

  @override
  ConsumerState<DataPage> createState() => _DataPageState();
}

class _DataPageState extends ConsumerState<DataPage> {
  List<Tab> tabs = [
    Tab(
      text: const Text('Clases'),
      semanticLabel: '',
      icon: const Icon(FluentIcons.classroom_logo),
      body: const ClassScreen(),
    ),
    Tab(
      text: const Text('Courses'),
      semanticLabel: '',
      icon: const Icon(FluentIcons.double_bookmark),
      body: const ClassScreen(),
    ),
    Tab(
      text: const Text('Liberal Courses'),
      semanticLabel: '',
      icon: const Icon(FluentIcons.publish_course),
      body: const ClassScreen(),
    ),
  ];
  int currentIndex = 0;
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
                  Text('Course Allocations'.toUpperCase(),
                      style: FluentTheme.of(context).typography.title),
                  const Spacer(),
                  FilledButton(
                      child: const Text('Import Allocations'),
                      onPressed: () {
                        ref
                            .read(excelFileProvider.notifier)
                            .generateAllocationExcelFile(context);
                      }),
                  const SizedBox(width: 10),
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
                      child: const Text('Allocation Template'),
                      onPressed: () {
                        ref
                            .read(excelFileProvider.notifier)
                            .generateAllocationExcelFile(context);
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
            const SizedBox(height: 20),
            //tab view

            Expanded(
              child: TabView(
                tabs: tabs,
                currentIndex: currentIndex,
                onChanged: (index) => setState(() => currentIndex = index),
                tabWidthBehavior: TabWidthBehavior.equal,
                closeButtonVisibility: CloseButtonVisibilityMode.never,
                showScrollButtons: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
