import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final regularConfigProvider =
    StateNotifierProvider<RegularConfig, StudyModeModel>(
        (ref) => RegularConfig());

class RegularConfig extends StateNotifier<StudyModeModel> {
  RegularConfig() : super(StudyModeModel());

  void updateConfig(StudyModeModel config) {
    state = config;
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
    if (e == 'break') {
      state = state.copyWith(breakTime: [
        ...state.breakTime,
        {'period': e}
      ]);
    }
  }

  void removePeriod(String e) {
    state = state.copyWith(
        periods:
            state.periods.where((element) => element['period'] != e).toList());
    if (e == 'break') {
      state = state.copyWith(breakTime: []);
    }
    if (state.periods.isEmpty) {
      state = state.copyWith(regLibPeriod: () => null);
      
    }
  }

  void setPeriodStartTime(String period, String? start) {
    state = state.copyWith(
        periods: state.periods
            .map((e) => e['period'] == period ? {...e, 'startTime': start} : e)
            .toList());
    if (period == 'break') {
      state = state.copyWith(
          breakTime: state.breakTime
              .map(
                  (e) => e['period'] == period ? {...e, 'startTime': start} : e)
              .toList());
    }
  }

  void setPeriodEndTime(String period, String? end) {
    state = state.copyWith(
        periods: state.periods
            .map((e) => e['period'] == period ? {...e, 'endTime': end} : e)
            .toList());
    if (period == 'break') {
      state = state.copyWith(
          breakTime: state.breakTime
              .map((e) => e['period'] == period ? {...e, 'endTime': end} : e)
              .toList());
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

  void mode(Map<String, dynamic> regularConfig) {
    if (regularConfig.isEmpty ||
        regularConfig['days'].isEmpty ||
        regularConfig['periods'].isEmpty) {
      state = StudyModeModel();
    } else {
      state = StudyModeModel.fromMap(regularConfig);
    }
  }

  void setEvenLibDay(String? value) {
    state = state.copyWith(evenLibDay: () => value);
  }

  void setEvenLibLevel(String? value) {
    state = state.copyWith(evenLibLevel: () => value);
  }
}
