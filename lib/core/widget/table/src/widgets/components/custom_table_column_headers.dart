import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/custom_table_columns_model.dart';

class CustomTableColumnHeader<TResult extends Object> extends ConsumerWidget {
  const CustomTableColumnHeader({
    super.key,
    required this.data,
    required this.columns,
    this.rowsSelectable = false,
    this.isAllRowsSelected = false,
    this.selectAllRows,
  });
  final List<CustomTableColumn<TResult>> columns;
  final bool rowsSelectable;
  final List<TResult> data;
  final bool isAllRowsSelected;
  final void Function(bool?)? selectAllRows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget child = SizedBox(
      height: 60,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        if (rowsSelectable)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: SizedBox(
                  width: 40,
                  child: Checkbox(
                    value: isAllRowsSelected,
                    tristate: true,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    checkColor: Colors.white,
                    onChanged: selectAllRows,
                  ))),

        /* COLUMNS */
        ...columns.map((column) {
          Widget innerChild = Text(column.title,
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis);

          innerChild = Tooltip(
            message: column.title,
            child: innerChild,
          );
          innerChild = column.width == null
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      heightFactor: null,
                      child: innerChild,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: column.width!,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        heightFactor: null,
                        child: innerChild),
                  ),
                );
          return innerChild;
        }),
      ]),
    );
    return child;
  }
}
