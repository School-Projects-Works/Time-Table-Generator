import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredTableProvider = StateNotifierProvider<FilteredTableProvider, List<TablesModel>>((ref) => FilteredTableProvider(ref.watch(tableDataProvider)));


class FilteredTableProvider extends StateNotifier<List<TablesModel>> {
  FilteredTableProvider(this.tables) : super(tables);

  final List<TablesModel> tables;
}