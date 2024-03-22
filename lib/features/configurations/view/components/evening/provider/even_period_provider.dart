import 'package:aamusted_timetable_generator/core/data/constants/constant_data.dart';
import 'package:aamusted_timetable_generator/features/configurations/view/components/evening/provider/evening_config_provider.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final evePeriodOneStartProvider =
    StateProvider<List<String>>((ref) => eveningTime);
final evePeriodOneEndProvider = StateProvider<List<String>>((ref) {
  var configs = ref.watch(eveningConfigProvider);
  //get period one start time
  var period = configs.periods
      .where((element) => element['period'] == 'Period 1')
      .toList();
  if (period.isNotEmpty) {
    var periodOneStart = period[0]['startTime'];
    // check if period one start time is null
    if (periodOneStart == null) {
      return [];
    } else {
      //remove all time before period one start time inclusive from list of time
      return eveningTime.where((element) {
        var time = AppUtils.stringToTimeOfDay(element);
        var periodOneStartTime = AppUtils.stringToTimeOfDay(periodOneStart);
        var difference = AppUtils.compareTimeOfDay(time, periodOneStartTime);
        return difference > 0;
      }).toList();
    }
  } else {
    return [];
  }
});

final evePeriodTwoStartProvider = StateProvider<List<String>>((ref) {
  var configs = ref.watch(eveningConfigProvider);
  //get period one start time
  var periods = configs.periods
      .where((element) => element['period'] == 'Period 1')
      .toList();
  if (periods.isNotEmpty) {
    var periodEndStart = periods[0]['endTime'];
    // check if period one start time is null
    if (periodEndStart == null) {
      return [];
    } else {
      //remove all time before period one start time inclusive from list of time
      return eveningTime.where((element) {
        var time = AppUtils.stringToTimeOfDay(element);
        var periodOneEndTime = AppUtils.stringToTimeOfDay(periodEndStart);
        var difference = AppUtils.compareTimeOfDay(time, periodOneEndTime);
        return difference >= 0;
      }).toList();
    }
  } else {
    return [];
  }
});
final evePeriodTwoEndProvider = StateProvider<List<String>>((ref) {
  var configs = ref.watch(eveningConfigProvider);
  //get period one start time
  var periods = configs.periods
      .where((element) => element['period'] == 'Period 2')
      .toList();
  if (periods.isNotEmpty) {
    var periodTwoStart = periods[0]['startTime'];
    // check if period one start time is null
    if (periodTwoStart == null) {
      return [];
    } else {
      //remove all time before period one start time inclusive from list of time
      return eveningTime.where((element) {
        var time = AppUtils.stringToTimeOfDay(element);
        var periodTwoStartTime = AppUtils.stringToTimeOfDay(periodTwoStart);
        var difference = AppUtils.compareTimeOfDay(time, periodTwoStartTime);
        return difference > 0;
      }).toList();
    }
  } else {
    return [];
  }
});

final evePeriodThreeStartProvider = StateProvider<List<String>>((ref) {
  var configs = ref.watch(eveningConfigProvider);
  //get period one start time
  var periods = configs.periods
      .where((element) => element['period'] == 'Period 2')
      .toList();
  if (periods.isNotEmpty) {
    var periodTwoEnd = periods[0]['endTime'];
    // check if period one start time is null
    if (periodTwoEnd == null) {
      return [];
    } else {
      //remove all time before period one start time inclusive from list of time
      return eveningTime.where((element) {
        var time = AppUtils.stringToTimeOfDay(element);
        var periodTwoEndTime = AppUtils.stringToTimeOfDay(periodTwoEnd);
        var difference = AppUtils.compareTimeOfDay(time, periodTwoEndTime);
        return difference >= 0;
      }).toList();
    }
  } else {
    return [];
  }
});
final evePeriodThreeEndProvider = StateProvider<List<String>>((ref) {
  var configs = ref.watch(eveningConfigProvider);
  //get period one start time
  var periods = configs.periods
      .where((element) => element['period'] == 'Period 3')
      .toList();
  if (periods.isNotEmpty) {
    var periodThreeStart = periods[0]['startTime'];

    // check if period one start time is null
    if (periodThreeStart == null) {
      return [];
    } else {
      //remove all time before period one start time inclusive from list of time
      return eveningTime.where((element) {
        var time = AppUtils.stringToTimeOfDay(element);
        var periodThreeStartTime = AppUtils.stringToTimeOfDay(periodThreeStart);
        var difference = AppUtils.compareTimeOfDay(time, periodThreeStartTime);
        return difference > 0;
      }).toList();
    }
  } else {
    return [];
  }
});

final evePeriodFourStartProvider = StateProvider<List<String>>((ref) {
  var configs = ref.watch(eveningConfigProvider);
  //get period one start time
  var periods = configs.periods
      .where((element) => element['period'] == 'Period 3')
      .toList();
  if (periods.isNotEmpty) {
    var periodThreeEnd = periods[0]['endTime'];
    // check if period one start time is null
    if (periodThreeEnd == null) {
      return [];
    } else {
      //remove all time before period one start time inclusive from list of time
      return eveningTime.where((element) {
        var time = AppUtils.stringToTimeOfDay(element);
        var periodThreeEndTime = AppUtils.stringToTimeOfDay(periodThreeEnd);
        var difference = AppUtils.compareTimeOfDay(time, periodThreeEndTime);
        return difference >= 0;
      }).toList();
    }
  } else {
    return [];
  }
});
final evePeriodFourEndProvider = StateProvider<List<String>>((ref) {
  var configs = ref.watch(eveningConfigProvider);
  //get period one start time
  var periods = configs.periods
      .where((element) => element['period'] == 'Period 4')
      .toList();
  if (periods.isNotEmpty) {
    var periodFourStart = periods[0]['startTime'];
    // check if period one start time is null
    if (periodFourStart == null) {
      return [];
    } else {
      //remove all time before period one start time inclusive from list of time
      return eveningTime.where((element) {
        var time = AppUtils.stringToTimeOfDay(element);
        var periodFourStartTime = AppUtils.stringToTimeOfDay(periodFourStart);
        var difference = AppUtils.compareTimeOfDay(time, periodFourStartTime);
        return difference > 0;
      }).toList();
    }
  } else {
    return [];
  }
});

final eveBreakStartProvider = StateProvider<List<String>>((ref) {
  var configs = ref.watch(eveningConfigProvider);
  //get all period ranges and time within range
  List<String> occupiedTime = [];
  var list =
      configs.periods.where((element) => element['period'] != 'Break').toList();
  for (var element in list) {
    if (element['startTime'] != null && element['endTime'] != null) {
      var periodStart = AppUtils.stringToTimeOfDay(element['startTime']);
      var periodEnd = AppUtils.stringToTimeOfDay(element['endTime']);
      for (var time in eveningTime) {
        var timeOfDay = AppUtils.stringToTimeOfDay(time);
        var difference = AppUtils.compareTimeOfDay(timeOfDay, periodStart);
        var difference2 = AppUtils.compareTimeOfDay(timeOfDay, periodEnd);
        if (difference >= 0 && difference2 <= 0) {
          occupiedTime.add(time);
        }
      }
    }
  }
  //get all time which appeared twice in occupied time
  if (occupiedTime.isEmpty) {
    return eveningTime;
  }
  var remainingTime = eveningTime
      .where((element) =>
          occupiedTime.where((time) => time == element).toList().length < 2)
      .toList();
  return remainingTime;
});
final eveBreakEndProvider = StateProvider<List<String>>((ref) {
  var configs = ref.watch(eveningConfigProvider);
  //get period one start time
  var breakPeriod =
      configs.periods.where((element) => element['period'] == 'Break').toList();
  if (breakPeriod.isNotEmpty) {
    var breakStart = breakPeriod[0]['startTime'];
    // check if period one start time is null
    if (breakStart == null) {
      return [];
    } else {
      //remove all time before period one start time inclusive from list of time
      return eveningTime.where((element) {
        var time = AppUtils.stringToTimeOfDay(element);
        var breakStartTime = AppUtils.stringToTimeOfDay(breakStart);
        var difference = AppUtils.compareTimeOfDay(time, breakStartTime);
        return difference > 0;
      }).toList();
    }
  } else {
    return [];
  }
});
