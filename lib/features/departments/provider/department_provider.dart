

import 'package:aamusted_timetable_generator/core/functions/time_sorting.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aamusted_timetable_generator/features/departments/data/department_model.dart';
import 'package:aamusted_timetable_generator/features/departments/services/department_services.dart';

final departmentStream =
    StreamProvider.autoDispose<List<DepartmentModel>>((ref) async* {
  var data = DepartmentServices.getDepartments();
  await for (var value in data) {
    ref.read(departmentsProvider.notifier).setDepartments(value);
    yield value;
  }
});

class FilterDepartment {
  List<DepartmentModel> items;
  List<DepartmentModel> filteredItems;
  FilterDepartment({
    required this.items,
    required this.filteredItems,
  });

  FilterDepartment copyWith({
    List<DepartmentModel>? items,
    List<DepartmentModel>? filteredItems,
  }) {
    return FilterDepartment(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
    );
  }
}

final departmentsProvider =
    StateNotifierProvider<DepartmentProvider, FilterDepartment>(
        (ref) => DepartmentProvider());

class DepartmentProvider extends StateNotifier<FilterDepartment> {
  DepartmentProvider() : super(FilterDepartment(items: [], filteredItems: []));

  void setDepartments(List<DepartmentModel> departments) {
    state = state.copyWith(items: departments, filteredItems: departments);
  }

  void filterDepartments(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredItems: state.items);
    } else {
      var filtered = state.items
          .where((element) =>
              element.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(filteredItems: filtered);
    }
  }

  void addDepartment(String text) async {
    CustomDialog.showLoading(message: 'Adding Department...');
    // check if department already exists
    var exists = state.items
        .where((element) => element.name == text.toCapitalized())
        .toList();
    if (exists.isNotEmpty) {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Department already exists');
      return;
    }
    var departmentsIds = state.items.map((e) => e.id!).toList();
    //get only numbers from the ids
    var values = departmentsIds.map((e) {
      String newnum = e.replaceAll(RegExp(r'[^0-9]'), '');
      print(e);
      return int.tryParse(newnum);
    }).toList();
    List<int> numbers = [];
    for (var value in values) {
      if (value is int) {
        numbers.add(value);
      }
    }

    //get the max number
    var max = numbers.isEmpty
        ? 0
        : numbers
            .reduce((value, element) => value! > element! ? value : element);
    var prefix = max <= 9
        ? '000'
        : max < 100
            ? '00'
            : max < 1000
                ? '0'
                : '';
    var id = 'DEP$prefix${max + 1}';
    var newDepartment = DepartmentModel(
      id: id,
      name: text.toCapitalized(),
      password: id.toLowerCase(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    var success = await DepartmentServices.addDepartment(newDepartment);
    CustomDialog.dismiss();
    if (success) {
      CustomDialog.showToast(message: 'Department added successfully');
    } else {
      CustomDialog.showError(message: 'Failed to add department');
    }
  }

  void deleteDepartment(DepartmentModel item) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Deleting Department...');
    await DepartmentServices.deleteDepartment(item);
    CustomDialog.dismiss();
    CustomDialog.showToast(message: 'Department deleted successfully');
  }
}

final selectedDepartmentProvider =
    StateNotifierProvider<SelectedProvider, DepartmentModel?>(
        (ref) => SelectedProvider());

class SelectedProvider extends StateNotifier<DepartmentModel?> {
  SelectedProvider() : super(null);

  void setSelectedDepartment(DepartmentModel department) {
    state = department;
  }

  void clearSelectedDepartment() {
    state = null;
  }

  void updateDepartment(WidgetRef ref, String name) async {
    CustomDialog.showLoading(message: 'Updating Department...');
    state = state!.copyWith(name: () => name.toCapitalized());
    var success = await DepartmentServices.updateDepartment(state!);
    CustomDialog.dismiss();
    if (success) {
      clearSelectedDepartment();
      CustomDialog.showToast(message: 'Department updated successfully');
    } else {
      CustomDialog.showError(message: 'Failed to update department');
    }
  }
}

final activeDepartmentProvider =
    StateNotifierProvider<ActiveDepartmentProvider, DepartmentModel?>(
        (ref) => ActiveDepartmentProvider());

class ActiveDepartmentProvider extends StateNotifier<DepartmentModel?> {
  ActiveDepartmentProvider() : super(null);

  void setActiveDepartment(DepartmentModel department) {
    state = department;
  }

  void clearActiveDepartment() {
    state = null;
  }
}
