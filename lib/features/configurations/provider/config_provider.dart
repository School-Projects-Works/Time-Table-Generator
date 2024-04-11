import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/usecase/config_usecase.dart';
import 'package:aamusted_timetable_generator/features/database/provider/database_provider.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final configFutureProvider = FutureProvider<ConfigModel>((ref) async {
  String academicYear = ref.watch(academicYearProvider);
  String academicSemester = ref.watch(semesterProvider);
  var id = '$academicYear-$academicSemester'
      .trim()
      .replaceAll(' ', '')
      .toLowerCase()
      .replaceAll('/', '-');
  var configs =
      await ConfigUsecase(db: ref.watch(dbProvider)).getConfigurations();
  var config = configs
      .where((element) =>
          element.id == id &&
          element.year == academicYear &&
          element.semester == academicSemester)
      .toList();
  if (config.isNotEmpty) {
    var currentConfig = config[0];
    ref.read(configProvider.notifier).setConfig(currentConfig);
    return currentConfig;
  } else {
    ref.read(configProvider.notifier).setConfig(ConfigModel());
    return ConfigModel();
  }
});

final configProvider =
    StateNotifierProvider<RegularConfig, ConfigModel>((ref) => RegularConfig());

class RegularConfig extends StateNotifier<ConfigModel> {
  RegularConfig() : super(ConfigModel());

  void addPeriod({required String name, required int position}) {
    var period = PeriodModel(period: name, position: position);
    state = state.copyWith(periods: [...state.periods, period.toMap()]);
  }

  void removePeriod(String name) {
    var newPeriods =
        state.periods.where((element) => element['period'] != name).toList();
    state = state.copyWith(periods: newPeriods);
  }

  void setPeriodStartTime({required String period, required String startTime}) {
    var periodModels =
        state.periods.where((element) => element['period'] == period).toList();
    if (periodModels.isNotEmpty) {
      var periodModel = PeriodModel.fromMap(periodModels[0]);
      periodModel.startTime = startTime;
      state = state.copyWith(
          periods: state.periods
              .map((e) => e['period'] == period ? periodModel.toMap() : e)
              .toList());
    }
  }

  void setPeriodEndTime({required String period, required String endTime}) {
    var periodModels =
        state.periods.where((element) => element['period'] == period).toList();
    if (periodModels.isNotEmpty) {
      var periodModel = PeriodModel.fromMap(periodModels[0]);
      periodModel.endTime = endTime;
      state = state.copyWith(
          periods: state.periods
              .map((e) => e['period'] == period ? periodModel.toMap() : e)
              .toList());
    }
  }

  void setPeriodAsBreak(
      {required String name, required bool isBreak, required WidgetRef ref}) {
    var period =
        state.periods.where((element) => element['period'] == name).toList();
    if (period.isNotEmpty) {
      var periodModel = PeriodModel.fromMap(period[0]);
      periodModel.isBreak = isBreak;
      state = state.copyWith(
        breakTime: () => periodModel.toMap(),
          periods: state.periods
              .map((e) => e['period'] == name ? periodModel.toMap() : e)
              .toList());
    }
  }

  void addDay(String e) {
    state = state.copyWith(days: [...state.days, e]);
  }

  void removeDay(String e) {
    state = state.copyWith(
        days: state.days.where((element) => element != e).toList());
    if (state.days.isEmpty) {
      state.copyWith(
        regLibDay: () => null,
        evenLibDay: () => null,
      );
    }
  }

  void setRegLibLevel(String? value) {
    state = state.copyWith(regLibLevel: () => value);
  }

  void setRegLibDay(String? value) {
    state = state.copyWith(regLibDay: () => value);
  }

  void setLiberalPeriod(String string) {
    //get period from periods
    var period =
        state.periods.where((element) => element['period'] == string).toList();
    if (period.isNotEmpty) {
      state = state.copyWith(regLibPeriod: () => period[0]);
    }
  }

  void setEvenLibDay(String? value) {
    state = state.copyWith(evenLibDay: () => value);
  }

  void setEvenLibLevel(String? value) {
    state = state.copyWith(evenLibLevel: () => value);
  }

  void saveConfiguration(BuildContext context, WidgetRef ref) async {
    try {
      CustomDialog.dismiss();
      CustomDialog.showLoading(message: 'Saving configuration..');
      var year = ref.watch(academicYearProvider);
      var semester = ref.watch(semesterProvider);
      var id = '$year-$semester'
          .trim()
          .replaceAll(' ', '')
          .toLowerCase()
          .replaceAll('/', '-');
      state = state.copyWith(
        id: () => id,
        year: () => year,
        semester: () => semester,
      );
      var (success, _, message) = await ConfigUsecase(db: ref.watch(dbProvider))
          .addConfigurations(state);
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
      var (success, _, message) = await ConfigUsecase(db: ref.watch(dbProvider))
          .deleteConfigurations(state.id!);
      if (!success) {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message:
                message ?? 'An error occurred while deleting configuration');
      } else {
        ref.invalidate(configFutureProvider);
        state = ConfigModel();
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
    state = ConfigModel();
  }

  void setConfig(ConfigModel config) {
    state = config;
  }
}


