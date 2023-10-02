import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../riverpod/excel_file_provider.dart';

class VenuesPage extends ConsumerStatefulWidget {
  const VenuesPage({super.key});

  @override
  ConsumerState<VenuesPage> createState() => _VenuesPageState();
}

class _VenuesPageState extends ConsumerState<VenuesPage> {
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
                    Text('Venues'.toUpperCase(),
                        style: FluentTheme.of(context).typography.title),
                    const Spacer(),
                    FilledButton(
                        child: const Text('Import Venue'),
                        onPressed: () {
                          // ref
                          //     .read(excelFileProvider.notifier)
                          //     .importV(context);
                        }),
                    const SizedBox(width: 10),
                    Button(
                        style: ButtonStyle(
                            border: ButtonState.all(
                                BorderSide(color: Colors.green))),
                        child: const Text('Venue Template'),
                        onPressed: () {
                          ref
                              .read(excelFileProvider.notifier)
                              .generateVenueExcelTemplate(context);
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
                      columns: [
                        "Venue",
                        "Capacity",
                        "is Special",
                        "is Disability Friendly",
                        "Action"
                      ]
                          .map((e) => material.DataColumn(label: Text(e)))
                          .toList(),
                      rows: List<material.DataRow>.generate(
                          100,
                          (index) => material.DataRow(cells: [
                                material.DataCell(
                                    Text('A' * (10 - index % 10))),
                                material.DataCell(
                                    Text('B' * (10 - (index + 5) % 10))),
                                material.DataCell(
                                    Text('C' * (15 - (index + 5) % 10))),
                                material.DataCell(
                                    Text('D' * (15 - (index + 10) % 10))),
                                material.DataCell(
                                    Text('D' * (15 - (index + 10) % 10))),
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
