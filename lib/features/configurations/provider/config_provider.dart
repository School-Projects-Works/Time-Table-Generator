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
    MyDialog myDialog = MyDialog(context: context, message: '', title: '');
    try {
      //show loading
      myDialog.toast()
        ..message = 'Saving configuration..'
        ..title = 'Please wait'
        ..loading();
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
        if (mounted) {
          myDialog.closeLoading();
          // show success dialog
          myDialog
            ..message = message ?? 'Configuration saved successfully'
            ..title = 'Success'
            ..success();
        }
      } else {
        if (mounted) {
          myDialog.closeLoading();
          // show success dialog
          myDialog
            ..message =
                message ?? 'An error occurred while saving configuration'
            ..title = 'Error'
            ..error();
        }
      }
    } catch (error) {
      if (mounted) {
        myDialog.closeLoading();
        myDialog
          ..message = 'An error occurred while saving configuration'
          ..title = 'Error'
          ..error();
      }
    }
  }

  void deleteConfiguration(BuildContext context, WidgetRef ref) async {
    MyDialog myDialog = MyDialog(context: context, message: '', title: '');
    try {
      //show loading
      myDialog
        ..message = 'Deleting configuration..'
        ..title = 'Please wait'
        ..loading();

      var (success, _, message) =
          await ConfigUsecase().deleteConfigurations(state.id!);
      if (!success) {
        if (mounted) {
          myDialog.closeLoading();
          // show success dialog
          myDialog
            ..message =
                message ?? 'An error occurred while deleting configuration'
            ..title = 'Error'
            ..error();
        }
      } else {
        ref.invalidate(configFutureProvider);
        if (mounted) {
          myDialog.closeLoading();
          // show success dialog
          myDialog
            ..message = message ?? 'Configuration deleted successfully'
            ..title = 'Success'
            ..success();
        }
      }
    } catch (error) {
      if (mounted) {
        myDialog.closeLoading();
        myDialog
          ..message = 'An error occured while deleting configuration'
          ..title = 'Error'
          ..error();
      }
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
