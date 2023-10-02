import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
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
            child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 600,
                columns:
                    ["Level", "Class Code", "Department", "Class Size", "hasDisabeled","Action"]
                    .map((e) => DataColumn(label: Text(e))).toList(),
                rows: List<DataRow>.generate(
                    100,
                    (index) => DataRow(cells: [
                          DataCell(Text('A' * (10 - index % 10))),
                          DataCell(Text('B' * (10 - (index + 5) % 10))),
                          DataCell(Text('C' * (15 - (index + 5) % 10))),
                          DataCell(Text('D' * (15 - (index + 10) % 10))),
                           DataCell(Text('C' * (15 - (index + 5) % 10))),
                          DataCell(Text('D' * (15 - (index + 10) % 10))),
                         
                        ]))),
          ),
        ],
      ),
    );
  }
}
