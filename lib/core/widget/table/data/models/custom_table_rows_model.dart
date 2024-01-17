import 'package:flutter/material.dart';
import 'custom_table_columns_model.dart';

abstract class BaseTableRow<TType extends Object> {
  TType item;
  int index;
  bool isSelected;
  void Function(bool?)? selectRow;
  BuildContext context;
  BaseTableRow({
    required this.item,
    required this.index,
    required this.context,
    this.isSelected = false,
    this.selectRow,
  });
  Widget buildCell(TType item, int columnIndex, BuildContext context,
      {bool rowsSelectable = false, required List<CustomTableColumn> columns});
}

class CustomTableRow<TType extends Object> extends BaseTableRow {
  CustomTableRow({
    required super.item,
    required super.index,
    required super.context,
    super.isSelected,
    super.selectRow,
  });

  @override
  Widget buildCell(Object item, int columnIndex, BuildContext context,
      {bool rowsSelectable = false, required List<CustomTableColumn> columns}) {
    Widget rowItem = Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor),
        ),
      ),
      child: Ink(
        padding: EdgeInsets.zero,
        color: isSelected ? Theme.of(context).colorScheme.secondary : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (rowsSelectable)
              if (rowsSelectable)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: SizedBox(
                    width: 40,
                    child: Checkbox(
                        value: isSelected,
                        tristate: true,
                        onChanged: selectRow),
                  ),
                ),
            ...columns.map((column) => column.width == null
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: column.isNumeric ?? false
                            ? Alignment.center
                            : Alignment.centerLeft,
                        heightFactor: null,
                        child: column.buildCell(item, index),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: column.width!,
                      child: Align(
                        alignment: column.isNumeric ?? false
                            ? Alignment.center
                            : Alignment.centerLeft,
                        heightFactor: null,
                        child: column.buildCell(item, index),
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );

    return rowItem;
  }
}
