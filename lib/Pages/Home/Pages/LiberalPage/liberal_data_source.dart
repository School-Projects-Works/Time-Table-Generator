import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../SateManager/hive_listener.dart';
import '../../../../Styles/colors.dart';

class LiberalDataSource extends DataTableSource {
  final BuildContext context;
  LiberalDataSource(this.context);

  @override
  DataRow? getRow(int index) {
    var data =
        Provider.of<HiveListener>(context, listen: false).getFilteredLiberal;
    if (index >= data.length) return null;
    final liberalItem = data[index];
    return DataRow.byIndex(
      selected: Provider.of<HiveListener>(context, listen: false)
          .getSelectedLiberals
          .contains(liberalItem),
      onSelectChanged: (value) {
        if (value!) {
          Provider.of<HiveListener>(context, listen: false)
              .addSelectedLiberals([liberalItem]);
        } else {
          Provider.of<HiveListener>(context, listen: false)
              .removeSelectedLiberal([liberalItem]);
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
              .getSelectedLiberals
              .contains(liberalItem)) {
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
                .getSelectedLiberals
                .contains(liberalItem),
            onChanged: (val) {
              if (val!) {
                Provider.of<HiveListener>(context, listen: false)
                    .addSelectedLiberals([liberalItem]);
              } else {
                Provider.of<HiveListener>(context, listen: false)
                    .removeSelectedLiberal([liberalItem]);
              }
            },
          ),
        )),
        DataCell(ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
            child: Text(liberalItem.code!))),
        DataCell(Text(liberalItem.title!)),
        DataCell(Text(liberalItem.targetStudents!)),
        DataCell(Text(liberalItem.lecturerName!)),
        DataCell(Text(liberalItem.lecturerEmail!)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => Provider.of<HiveListener>(context, listen: false)
      .getFilteredLiberal
      .length;

  @override
  int get selectedRowCount => 0;
}
