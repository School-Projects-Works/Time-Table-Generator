import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main/provider/main_provider.dart';
import '../data/config/config_model.dart';
import '../usecase/config_usecase.dart';

final configFutureProvider = FutureProvider<ConfigModel>((ref) async {
  String academicYear = ref.watch(academicYearProvider);
  String academicSemester = ref.watch(semesterProvider);
  String targetedStudents = ref.watch(studentTypeProvider);
  var configs = await ConfigUsecase().getConfigurations();
  var config = configs
      .where((element) =>
          element.academicYear == academicYear &&
          element.academicSemester == academicSemester &&
          element.targetedStudents == targetedStudents)
      .toList();
  if (config.isNotEmpty) {
    ref.read(configurationProvider.notifier).setConfig(config[0]);
    return config[0];
  } else {
    return ConfigModel(
      hasClass: false,
      hasCourse: false,
      hasLiberalCourse: false,
    );
  }
});

final configurationProvider =
    StateNotifierProvider<ConfigurationNotifier, ConfigModel>((ref) {
  return ConfigurationNotifier();
});

class ConfigurationNotifier extends StateNotifier<ConfigModel> {
  ConfigurationNotifier() : super(ConfigModel());

  void addDay(String e) {
    state = state.copyWith(days: [...state.days, e]);
  }

  void removeDay(String e) {
    state = state.copyWith(
        days: state.days.where((element) => element != e).toList());
  }

  void addPeriod(String e) {
    //remove period if exist already
    state = state.copyWith(
        periods:
            state.periods.where((element) => element['period'] != e).toList());
    //add new period
    state = state.copyWith(periods: [
      ...state.periods,
      {'period': e}
    ]);
  }

  void removePeriod(String e) {
    state = state.copyWith(
        periods:
            state.periods.where((element) => element['period'] != e).toList());
  }

  void setPeriodStartTime(String period, String? start) {
    state = state.copyWith(
        periods: state.periods
            .map((e) => e['period'] == period ? {...e, 'startTime': start} : e)
            .toList());
  }

  void setPeriodEndTime(String period, String? end) {
    state = state.copyWith(
        periods: state.periods
            .map((e) => e['period'] == period ? {...e, 'endTime': end} : e)
            .toList());
  }

  void setLiberalLevel(String? value) {
    state = state.copyWith(liberalLevel: value);
  }

  void setLiberalDay(String? value) {
    state = state.copyWith(liberalCourseDay: value);
  }

  void setLiberalPeriod(String string) {
    //get period from periods
    var period =
        state.periods.where((element) => element['period'] == string).toList();
    if (period.isNotEmpty) {
      state = state.copyWith(liberalCoursePeriod: period[0]);
    }
  }

  void saveConfiguration(BuildContext context, WidgetRef ref) async {
    try {
      CustomDialog.dismiss();
      CustomDialog.showLoading(message: 'Saving configuration..');
      var breakTime = state.periods
          .where((element) => element['period'] == 'Break')
          .toList();
      state = state.copyWith(
        id: AppUtils.getId(),
        academicYear: ref.watch(academicYearProvider),
        academicSemester: ref.watch(semesterProvider),
        targetedStudents: ref.watch(studentTypeProvider),
        breakTime: breakTime.isNotEmpty ? breakTime : [],
      );
      var (success, _, message) =
          await ConfigUsecase().addConfigurations(state);
      if (success) {
        ref.invalidate(configFutureProvider);
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: message ?? 'Configuration saved successfully');
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: message ?? 'An error occurred');
      }
    } catch (error) {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'An error occurred');
    }
  }

  void deleteConfiguration(BuildContext context, WidgetRef ref) async {
    try {
      CustomDialog.dismiss();
      CustomDialog.showLoading(message: 'Deleting configuration..');

      var (success, _, message) =
          await ConfigUsecase().deleteConfigurations(state.id!);
      if (!success) {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message:
                message ?? 'An error occurred while deleting configuration');
      } else {
        ref.invalidate(configFutureProvider);
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: message ?? 'Configuration deleted successfully');
      }
    } catch (error) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          message: 'An error occurred while deleting configuration');
    }
  }

  void clearConfig(BuildContext context) {
    state = ConfigModel(
      hasClass: false,
      hasCourse: false,
      hasLiberalCourse: false,
    );
  }

  void setConfig(ConfigModel config) {
    state = config;
  }
}
