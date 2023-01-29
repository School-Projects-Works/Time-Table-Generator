// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Styles/colors.dart';

class VenueDataSource extends DataTableSource {
  final BuildContext context;
  VenueDataSource(this.context);

  @override
  DataRow? getRow(int index) {
    var data = Provider.of<HiveListener>(context).getFilteredVenue;
    if (index >= data.length) return null;
    var venue = data[index];
    final style = GoogleFonts.nunito(fontSize: 15);
    return DataRow.byIndex(
        selected: Provider.of<HiveListener>(context, listen: false)
            .getSelectedVenues
            .contains(venue),
        onSelectChanged: (value) {
          if (value!) {
            Provider.of<HiveListener>(context, listen: false)
                .addSelectedVenues([venue]);
          } else {
            Provider.of<HiveListener>(context, listen: false)
                .removeSelectedVenues([venue]);
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
                .getSelectedVenues
                .contains(venue)) {
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
                  .getSelectedVenues
                  .contains(venue),
              onChanged: (val) {
                if (val!) {
                  Provider.of<HiveListener>(context, listen: false)
                      .addSelectedVenues([venue]);
                } else {
                  Provider.of<HiveListener>(context, listen: false)
                      .removeSelectedVenues([venue]);
                }
              },
            ),
          )),
          DataCell(Text(
            venue.name!,
            style: style,
          )),
          DataCell(ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: Text(
              venue.capacity!,
              style: style,
            ),
          )),
          DataCell(ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: Text(
              venue.isDisabilityAccessible!,
              style: style,
            ),
          )),
          DataCell(ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: Text(
              venue.isSpecialVenue!,
              style: style,
            ),
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount =>
      Provider.of<HiveListener>(context, listen: false).getFilteredVenue.length;

  @override
  int get selectedRowCount => 0;
}
