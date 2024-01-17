import 'package:flutter/widgets.dart';

abstract class BaseTableColumn<TType extends Object> {
  final String title;
  final bool? isNumeric;
  final double? width;
  final bool? sortable;
  final Widget Function(TType) cellBuilder;
  BaseTableColumn({
    required this.title,
    this.isNumeric = false,
    this.width,
    this.sortable = false,
    required this.cellBuilder,
  });
  Widget buildCell(TType item, int rowIndex);
}

class CustomTableColumn<TType extends Object> extends BaseTableColumn<TType> {
  CustomTableColumn({
    required super.title,
    required super.cellBuilder,
    super.isNumeric,
    super.width,
    super.sortable,
  });

  @override
  Widget buildCell(Object item, int rowIndex) {
    return cellBuilder(item as TType);
  }
}
