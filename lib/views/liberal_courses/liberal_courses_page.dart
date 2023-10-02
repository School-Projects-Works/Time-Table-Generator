import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
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
    return material.Material(
      child: Container(
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
                    const SizedBox(width: 10),
                         FilledButton(
                          //red button
                        style: ButtonStyle(
                            backgroundColor:
                                ButtonState.all(Colors.red.withOpacity(.8))),
                        child: const Text('Clear All'),
                        onPressed: () {
                          //Todo clear all
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                      height: 45,
                      width: 600,
                    child: TextBox(
                      placeholder: 'Search',
                      onChanged: (value) {
                        //Todo search
                      },
                      suffixMode: OverlayVisibilityMode.always,
                      suffix: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(FluentIcons.search),
                      ),
                    
                    )),
                ),
              ),

              Expanded(
              child: material.Material(
                color: Colors.white,
                child: DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 600,
                    columns:
                        ["Course Code", "Course Title", "Lecturer", "Action"]
                        .map((e) => material.DataColumn(label: Text(e))).toList(),
                    rows: List<material.DataRow>.generate(
                        100,
                        (index) => material.DataRow(cells: [
                              material.DataCell(Text('A' * (10 - index % 10))),
                              material.DataCell(Text('B' * (10 - (index + 5) % 10))),
                              material.DataCell(Text('C' * (15 - (index + 5) % 10))),
                              material.DataCell(Text('D' * (15 - (index + 10) % 10))),
                             
                            ]))),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
