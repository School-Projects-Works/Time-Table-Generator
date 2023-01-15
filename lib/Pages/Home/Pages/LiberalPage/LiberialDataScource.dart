import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../SateManager/HiveListener.dart';
import '../../../../Styles/colors.dart';

class LiberialDataScource extends DataTableSource {
  final BuildContext context;
  LiberialDataScource(this.context);

  @override
  DataRow? getRow(int index) {
    var data =
        Provider.of<HiveListener>(context, listen: false).getFilteredLiberial;
    if (index >= data.length) return null;
    final liberialItem = data[index];
    return DataRow.byIndex(
      selected: Provider.of<HiveListener>(context, listen: false)
          .getSelectedLiberials
          .contains(liberialItem),
      onSelectChanged: (value) {
        if (value!) {
          Provider.of<HiveListener>(context, listen: false)
              .addSelectedLiberials([liberialItem]);
        } else {
          Provider.of<HiveListener>(context, listen: false)
              .removeSelectedLiberial([liberialItem]);
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
              .getSelectedLiberials
              .contains(liberialItem)) {
            return Colors.blue.withOpacity(.7);
          }
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
                .getSelectedLiberials
                .contains(liberialItem),
            onChanged: (val) {
              if (val!) {
                Provider.of<HiveListener>(context, listen: false)
                    .addSelectedLiberials([liberialItem]);
              } else {
                Provider.of<HiveListener>(context, listen: false)
                    .removeSelectedLiberial([liberialItem]);
              }
            },
          ),
        )),
        DataCell(ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
            child: Text(liberialItem.code!))),
        DataCell(Text(liberialItem.title!)),
        DataCell(Text(liberialItem.lecturerName!)),
        DataCell(Text(liberialItem.lecturerEmail!)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => Provider.of<HiveListener>(context, listen: false)
      .getFilteredLiberial
      .length;

  @override
  int get selectedRowCount => 0;
}
