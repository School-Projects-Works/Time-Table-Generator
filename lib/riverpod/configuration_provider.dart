import 'package:aamusted_timetable_generator/data/models/configs/configuration_model.dart';
import 'package:aamusted_timetable_generator/data/user_cases/database_config_usecase.dart';
import 'package:aamusted_timetable_generator/global/widgets/custom_dialog.dart';
import 'package:aamusted_timetable_generator/riverpod/academic_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final configurationFutureProvider =
//     FutureProvider<ConfigurationModel?>((ref) async {
//   String academicYear = ref.watch(academicYearProvider);
//   String academicSemester = ref.watch(semesterProvider);
//   String targetedStudents = ref.watch(studentTypeProvider);
//   return await ConfigUsecase()
//       .getConfigurations(academicYear, academicSemester, targetedStudents);
// });

final configurationProvider =
    StateNotifierProvider<ConfigurationNotifier, ConfigurationModel>((ref) {
  String academicYear = ref.watch(academicYearProvider);
  String academicSemester = ref.watch(semesterProvider);
  String targetedStudents = ref.watch(studentTypeProvider);
  return ConfigurationNotifier(
      academicYear, academicSemester, targetedStudents);
});

class ConfigurationNotifier extends StateNotifier<ConfigurationModel> {
  final String academicYear;
  final String academicSemester;
  final String targetedStudents;
  ConfigurationNotifier(
      this.academicYear, this.academicSemester, this.targetedStudents)
      : super(ConfigurationModel(
          hasClass: false,
          hasCourse: false,
          hasLiberalCourse: false,
        )) {
    _init();
  }
  void _init() async {
    var data = await ConfigUsecase()
        .getConfigurations(academicYear, academicSemester, targetedStudents);
    if (data != null) {
      state = data;
    }
  }

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

  void saveConfiguration(BuildContext context) async {
    MyDialog myDialog = MyDialog(context: context, message: '', title: '');
    try {
      //show loading

      myDialog
        ..message = 'Saving configuration..'
        ..title = 'Please wait'
        ..loading();
      String id = '$academicYear$academicSemester$targetedStudents'
          .trim()
          .toLowerCase();
      var breakTime = state.periods
          .where((element) => element['period'] == 'Break')
          .toList();
      state = state.copyWith(
        id: id.hashCode.toString(),
        academicYear: academicYear,
        academicSemester: academicSemester,
        targetedStudents: targetedStudents,
        breakTime: breakTime.isNotEmpty ? breakTime : [],
      );
      await ConfigUsecase().deleteConfigurations(state.academicYear!,
          state.academicSemester!, state.targetedStudents!);
      await ConfigUsecase().addConfigurations(state);
      //close loading
      if (mounted) {
        myDialog        
          .closeLoading();
        // show success dialog
        myDialog
          ..message = 'Configuration saved successfully'
          ..title = 'Success'
          ..success();
      }
    } catch (error) {
      if (mounted) {
        myDialog
          ..message = 'An error occured while saving configuration'
          ..title = 'Error'
          ..error();
      }
    }
  }

  void deleteConfiguration(BuildContext context)async {
    MyDialog myDialog = MyDialog(context: context, message: '', title: '');
    try {
      //show loading
      myDialog
        ..message = 'Deleting configuration..'
        ..title = 'Please wait'
        ..loading();
    
      await ConfigUsecase().deleteConfigurations(academicYear, academicSemester,
          targetedStudents);
      //close loading
      if (mounted) {
        _init();
        myDialog
          .closeLoading();
        // show success dialog
        
        myDialog
          ..message = 'Configuration deleted successfully'
          ..title = 'Success'
          ..success();
      }
    } catch (error) {
      if (mounted) {
        myDialog
          ..message = 'An error occured while deleting configuration'
          ..title = 'Error'
          ..error();
      }
    }
  }

  void clearConfig(BuildContext context) {
    state = ConfigurationModel(
      hasClass: false,
      hasCourse: false,
      hasLiberalCourse: false,
    );
  }
}
