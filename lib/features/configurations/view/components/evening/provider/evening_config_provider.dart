import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eveningConfigProvider =
    StateNotifierProvider<EveningConfig, StudyModeModel>(
        (ref) => EveningConfig());

class EveningConfig extends StateNotifier<StudyModeModel> {
  EveningConfig() : super(StudyModeModel());

  void updateConfig(StudyModeModel config) {
    state = config;
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
    state = state.copyWith(liberalLevel: () => value);
  }

  void setLiberalDay(String? value) {
    state = state.copyWith(liberalCourseDay: () => value);
  }

  void setLiberalPeriod(String string) {
    //get period from periods
    var period =
        state.periods.where((element) => element['period'] == string).toList();
    if (period.isNotEmpty) {
      state = state.copyWith(liberalCoursePeriod: () => period[0]);
    }
  }

  void mode(Map<String, dynamic> eveningConfig) {
    state= StudyModeModel.fromMap(eveningConfig);
  }
}
