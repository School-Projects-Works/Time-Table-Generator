// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../SateManager/HiveListener.dart';
import '../../../../Styles/colors.dart';

class ClassDataSource extends DataTableSource {
  final BuildContext context;

  ClassDataSource(this.context);
  @override
  DataRow? getRow(int index) {
    final classList =
        Provider.of<HiveListener>(context, listen: false).getFilteredClass;
    if (index >= classList.length) return null;
    final classItem = classList[index];
    return DataRow.byIndex(
      selected: Provider.of<HiveListener>(context, listen: false)
          .getSelectedClasses
          .contains(classItem),
      onSelectChanged: (value) {
        if (value!) {
          Provider.of<HiveListener>(context, listen: false)
              .addSelectedClass([classItem]);
        } else {
          Provider.of<HiveListener>(context, listen: false)
              .removeSelectedClass([classItem]);
        }
      },
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          const Set<MaterialState> interactiveStates = <MaterialState>{
            MaterialState.pressed,
            MaterialState.hovered,
            MaterialState.focused,
          };

          if (states.any(interactiveStates.contains)) {
            return Colors.blue.withOpacity(.2);
          } else if (Provider.of<HiveListener>(context, listen: false)
              .getSelectedClasses
              .contains(classItem)) {
            return Colors.blue.withOpacity(.7);
          }
          return null;
        },
      ),
      index: index,
      cells: [
        DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 50, minWidth: 50),
          child: Checkbox(
            checkColor: primaryColor,
            activeColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                const Set<MaterialState> interactiveStates = <MaterialState>{
                  MaterialState.pressed,
                  MaterialState.hovered,
                  MaterialState.focused,
                };

                if (states.any(interactiveStates.contains)) {
                  return Colors.black.withOpacity(.5);
                } else {
                  return Colors.black.withOpacity(.5);
                }
              },
            ),
            value: Provider.of<HiveListener>(context, listen: false)
                .getSelectedClasses
                .contains(classItem),
            onChanged: (val) {
              if (val!) {
                Provider.of<HiveListener>(context, listen: false)
                    .addSelectedClass([classItem]);
              } else {
                Provider.of<HiveListener>(context, listen: false)
                    .removeSelectedClass([classItem]);
              }
            },
          ),
        )),
        DataCell(Text(classItem.level!)),
        DataCell(Text(classItem.type!)),
        DataCell(Text(classItem.name!)),
        DataCell(Text(classItem.department!)),
        DataCell(ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
            child: Text(classItem.size!))),
        DataCell(ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
            child: Text(classItem.hasDisability!))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount =>
      Provider.of<HiveListener>(context, listen: false).getFilteredClass.length;

  @override
  int get selectedRowCount => 0;
}
