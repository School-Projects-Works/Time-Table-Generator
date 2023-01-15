import 'dart:math' as math;
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class CustomTable extends StatefulWidget {
  CustomTable({
    super.key,
    this.header,
    this.actions,
    required this.columns,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    this.dataRowHeight = kMinInteractiveDimension,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showCheckboxColumn = true,
    this.showFirstLastButtons = false,
    this.initialFirstRowIndex = 0,
    this.onPageChanged,
    this.rowsPerPage = defaultRowsPerPage,
    this.availableRowsPerPage = const <int>[
      defaultRowsPerPage,
      defaultRowsPerPage * 2,
      defaultRowsPerPage * 5,
      defaultRowsPerPage * 10
    ],
    this.onRowsPerPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.arrowHeadColor,
    this.border,
    required this.source,
    this.checkboxHorizontalMargin,
    this.controller,
    this.primary,
    this.controller2,
    this.bottomAction,
  })  : assert(actions == null || (header != null)),
        assert(columns.isNotEmpty),
        assert(sortColumnIndex == null ||
            (sortColumnIndex >= 0 && sortColumnIndex < columns.length)),
        assert(rowsPerPage > 0),
        assert(() {
          if (onRowsPerPageChanged != null) {
            assert(availableRowsPerPage.contains(rowsPerPage));
          }
          return true;
        }()),
        assert(
          !(controller != null && (primary ?? false)),
          'Primary ScrollViews obtain their ScrollController via inheritance from a PrimaryScrollController widget. '
          'You cannot both set primary to true and pass an explicit controller.',
        );

  final Widget? header;

  final List<Widget>? actions;
  final List<DataColumn> columns;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ValueSetter<bool?>? onSelectAll;
  final double dataRowHeight;
  final double headingRowHeight;
  final double horizontalMargin;
  final double columnSpacing;
  final bool showCheckboxColumn;
  final bool showFirstLastButtons;
  final int? initialFirstRowIndex;
  final ValueChanged<int>? onPageChanged;
  final int rowsPerPage;
  static const int defaultRowsPerPage = 10;
  final List<int> availableRowsPerPage;
  final ValueChanged<int?>? onRowsPerPageChanged;
  final DataTableSource source;
  final DragStartBehavior dragStartBehavior;
  final double? checkboxHorizontalMargin;
  final Color? arrowHeadColor;
  final ScrollController? controller;
  final ScrollController? controller2;
  final bool? primary;
  final TableBorder? border;
  final Widget? bottomAction;

  @override
  CustomTableState createState() => CustomTableState();
}

class CustomTableState extends State<CustomTable> {
  late int _firstRowIndex;
  late int _rowCount;
  late bool _rowCountApproximate;
  int _selectedRowCount = 0;
  final Map<int, DataRow?> _rows = <int, DataRow?>{};

  @override
  void initState() {
    super.initState();
    _firstRowIndex = PageStorage.of(context)?.readState(context) as int? ?? 0;
    widget.source.addListener(_handleDataSourceChanged);
    _handleDataSourceChanged();
  }

  @override
  void didUpdateWidget(CustomTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    widget.source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(() {
      _rowCount = widget.source.rowCount;
      _rowCountApproximate = widget.source.isRowCountApproximate;
      _selectedRowCount = widget.source.selectedRowCount;
      _rows.clear();
    });
  }

  /// Ensures that the given row is visible.
  void pageTo(int rowIndex) {
    final int oldFirstRowIndex = _firstRowIndex;
    setState(() {
      final int rowsPerPage = widget.rowsPerPage;
      _firstRowIndex = (rowIndex ~/ rowsPerPage) * rowsPerPage;
    });
    if ((widget.onPageChanged != null) &&
        (oldFirstRowIndex != _firstRowIndex)) {
      widget.onPageChanged!(_firstRowIndex);
    }
  }

  DataRow _getBlankRowFor(int index) {
    return DataRow.byIndex(
      index: index,
      cells: widget.columns
          .map<DataCell>((DataColumn column) => DataCell.empty)
          .toList(),
    );
  }

  DataRow _getProgressIndicatorRowFor(int index) {
    bool haveProgressIndicator = false;
    final List<DataCell> cells =
        widget.columns.map<DataCell>((DataColumn column) {
      if (!column.numeric) {
        haveProgressIndicator = true;
        return const DataCell(CircularProgressIndicator());
      }
      return DataCell.empty;
    }).toList();
    if (!haveProgressIndicator) {
      haveProgressIndicator = true;
      cells[0] = const DataCell(CircularProgressIndicator());
    }
    return DataRow.byIndex(
      index: index,
      cells: cells,
    );
  }

  List<DataRow> _getRows(int firstRowIndex, int rowsPerPage) {
    final List<DataRow> result = <DataRow>[];
    final int nextPageFirstRowIndex = firstRowIndex + rowsPerPage;
    bool haveProgressIndicator = false;
    for (int index = firstRowIndex; index < nextPageFirstRowIndex; index += 1) {
      DataRow? row;
      if (index < _rowCount || _rowCountApproximate) {
        row = _rows.putIfAbsent(index, () => widget.source.getRow(index));
        if (row == null && !haveProgressIndicator) {
          row ??= _getProgressIndicatorRowFor(index);
          haveProgressIndicator = true;
        }
      }
      row ??= _getBlankRowFor(index);
      result.add(row);
    }
    return result;
  }

  void _handleFirst() {
    pageTo(0);
  }

  void _handlePrevious() {
    pageTo(math.max(_firstRowIndex - widget.rowsPerPage, 0));
  }

  void _handleNext() {
    pageTo(_firstRowIndex + widget.rowsPerPage);
  }

  void _handleLast() {
    pageTo(((_rowCount - 1) / widget.rowsPerPage).floor() * widget.rowsPerPage);
  }

  bool _isNextPageUnavailable() =>
      !_rowCountApproximate &&
      (_firstRowIndex + widget.rowsPerPage >= _rowCount);

  final GlobalKey _tableKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    // HEADER
    final List<Widget> headerWidgets = <Widget>[];
    if (_selectedRowCount == 0 && widget.header != null) {
      headerWidgets.add(Expanded(child: widget.header!));
    } else if (widget.header != null) {
      headerWidgets.add(Expanded(
        child: Text(localizations.selectedRowCountTitle(_selectedRowCount)),
      ));
    }
    if (widget.actions != null) {
      headerWidgets.addAll(
        widget.actions!.map<Widget>((Widget action) {
          return Padding(
            // 8.0 is the default padding of an icon button
            padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0),
            child: action,
          );
        }).toList(),
      );
    }

    // FOOTER
    final TextStyle? footerTextStyle = themeData.textTheme.bodySmall;
    final List<Widget> footerWidgets = <Widget>[];
    if (widget.onRowsPerPageChanged != null) {
      final List<Widget> availableRowsPerPage = widget.availableRowsPerPage
          .where(
              (int value) => value <= _rowCount || value == widget.rowsPerPage)
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('$value'),
        );
      }).toList();
      footerWidgets.addAll(<Widget>[
        Container(
            width:
                14.0), // to match trailing padding in case we overflow and end up scrolling
        Text(localizations.rowsPerPageTitle),
        ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: 64.0), // 40.0 for the text, 24.0 for the icon
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                items: availableRowsPerPage.cast<DropdownMenuItem<int>>(),
                value: widget.rowsPerPage,
                onChanged: widget.onRowsPerPageChanged,
                style: footerTextStyle,
              ),
            ),
          ),
        ),
      ]);
    }
    footerWidgets.addAll(<Widget>[
      Container(width: 32.0),
      Text(
        localizations.pageRowsInfoTitle(
          _firstRowIndex + 1,
          _firstRowIndex + widget.rowsPerPage,
          _rowCount,
          _rowCountApproximate,
        ),
      ),
      Container(width: 32.0),
      if (widget.showFirstLastButtons)
        IconButton(
          icon: Icon(Icons.skip_previous, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.firstPageTooltip,
          onPressed: _firstRowIndex <= 0 ? null : _handleFirst,
        ),
      IconButton(
        icon: Icon(Icons.chevron_left, color: widget.arrowHeadColor),
        padding: EdgeInsets.zero,
        tooltip: localizations.previousPageTooltip,
        onPressed: _firstRowIndex <= 0 ? null : _handlePrevious,
      ),
      Container(width: 24.0),
      IconButton(
        icon: Icon(Icons.chevron_right, color: widget.arrowHeadColor),
        padding: EdgeInsets.zero,
        tooltip: localizations.nextPageTooltip,
        onPressed: _isNextPageUnavailable() ? null : _handleNext,
      ),
      if (widget.showFirstLastButtons)
        IconButton(
          icon: Icon(Icons.skip_next, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.lastPageTooltip,
          onPressed: _isNextPageUnavailable() ? null : _handleLast,
        ),
      Container(width: 14.0),
    ]);

    // CARD
    var constraints = MediaQuery.of(context).size;

    return Card(
        semanticContainer: true,
        child: VsScrollbar(
          controller: widget.controller2,
          showTrackOnHover: true, // default false
          isAlwaysShown: true, // default false
          scrollbarFadeDuration: const Duration(
              milliseconds: 500), // default : Duration(milliseconds: 300)
          scrollbarTimeToFade: const Duration(
              milliseconds: 800), // default : Duration(milliseconds: 600)
          style: const VsScrollbarStyle(
            hoverThickness: 12.0, // default 12.0
            radius: Radius.circular(2), // default Radius.circular(8.0)
            thickness: 10.0, // [ default 8.0 ]
            color: primaryColor, // default ColorScheme Theme
          ),
          child: SingleChildScrollView(
            controller: widget.controller2,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (headerWidgets.isNotEmpty)
                    Semantics(
                      container: true,
                      child: DefaultTextStyle(
                        style: _selectedRowCount > 0
                            ? themeData.textTheme.titleMedium!.copyWith(
                                color: themeData.colorScheme.secondary)
                            : themeData.textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.w400),
                        child: IconTheme.merge(
                          data: const IconThemeData(
                            opacity: 0.54,
                          ),
                          child: Ink(
                            height: 64.0,
                            color: _selectedRowCount > 0
                                ? themeData.secondaryHeaderColor
                                : null,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 24, end: 14.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: headerWidgets,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  VsScrollbar(
                    controller: widget.controller,
                    showTrackOnHover: true, // default false
                    isAlwaysShown: true, // default false
                    scrollbarFadeDuration: const Duration(
                        milliseconds:
                            500), // default : Duration(milliseconds: 300)
                    scrollbarTimeToFade: const Duration(
                        milliseconds:
                            800), // default : Duration(milliseconds: 600)
                    style: const VsScrollbarStyle(
                      hoverThickness: 12.0, // default 12.0
                      radius:
                          Radius.circular(2), // default Radius.circular(8.0)
                      thickness: 10.0, // [ default 8.0 ]
                      color: secondaryColor, // default ColorScheme Theme
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      primary: widget.primary,
                      controller: widget.controller,
                      dragStartBehavior: widget.dragStartBehavior,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.width),
                          child: SingleChildScrollView(
                            child: DataTable(
                              key: _tableKey,
                              border: widget.border,
                              columns: widget.columns,
                              sortColumnIndex: widget.sortColumnIndex,
                              sortAscending: widget.sortAscending,
                              onSelectAll: widget.onSelectAll,
                              decoration: const BoxDecoration(),
                              dataRowHeight: widget.dataRowHeight,
                              headingRowHeight: widget.headingRowHeight,
                              horizontalMargin: widget.horizontalMargin,
                              checkboxHorizontalMargin:
                                  widget.checkboxHorizontalMargin,
                              columnSpacing: widget.columnSpacing,
                              showCheckboxColumn: widget.showCheckboxColumn,
                              showBottomBorder: true,
                              rows:
                                  _getRows(_firstRowIndex, widget.rowsPerPage),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 14.0),
                        widget.bottomAction ?? Container(),
                        Expanded(
                          child: DefaultTextStyle(
                            style: footerTextStyle!,
                            child: IconTheme.merge(
                              data: const IconThemeData(
                                opacity: 0.54,
                              ),
                              child: SizedBox(
                                height: 56.0,
                                child: SingleChildScrollView(
                                  dragStartBehavior: widget.dragStartBehavior,
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  child: Row(
                                    children: footerWidgets,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
