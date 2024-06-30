import 'package:aamusted_timetable_generator/core/data/constants/constant_data.dart';
import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../provider/config_provider.dart';

final periodOneStartTimeProvider = StateProvider<List<String>>((ref) {
  return regularTime;
});
final periodOneEndTimeProvider = StateProvider<List<String>>((ref) {
  var periods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
  var period = periods.where((element) => element.position == 0).toList();
  if (period.isNotEmpty) {
    var periodOneStart = period[0].startTime;
    if (periodOneStart.isEmpty) {
      return [];
    } else {
      return regularTime.where((element) {
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

final periodTwoStartTimeProvider = StateProvider<List<String>>((ref) {
 var periods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
  var period = periods.where((element) => element.position == 0).toList();
  if (period.isNotEmpty) {
    var periodEndStart = period[0].endTime;
    if (periodEndStart.isEmpty) {
      return [];
    } else {
      return regularTime.where((element) {
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

final periodTwoEndTimeProvider = StateProvider<List<String>>((ref) {
 var periods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
  var period = periods.where((element) => element.position == 1).toList();
  if (period.isNotEmpty) {
    var periodTwoStart = period[0].startTime;
    if (periodTwoStart.isEmpty) {
      return [];
    } else {
      return regularTime.where((element) {
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

final periodThreeStartTimeProvider = StateProvider<List<String>>((ref) {
 var periods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
  var period = periods.where((element) => element.position == 1).toList();
  if (period.isNotEmpty) {
    var periodEndStart = period[0].endTime;
    if (periodEndStart.isEmpty) {
      return [];
    } else {
      return regularTime.where((element) {
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

final periodThreeEndTimeProvider = StateProvider<List<String>>((ref) {
 var periods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
  var period = periods.where((element) => element.position == 2).toList();
  if (period.isNotEmpty) {
    var periodTwoStart = period[0].startTime;
    if (periodTwoStart.isEmpty) {
      return [];
    } else {
      return regularTime.where((element) {
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

final periodFourStartTimeProvider = StateProvider<List<String>>((ref) {
 var periods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
  var period = periods.where((element) => element.position == 2).toList();
  if (period.isNotEmpty) {
    var periodEndStart = period[0].endTime;
    if (periodEndStart.isEmpty) {
      return [];
    } else {
      return regularTime.where((element) {
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

final periodFourEndTimeProvider = StateProvider<List<String>>((ref) {
 var periods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
  var period = periods.where((element) => element.position == 3).toList();
  if (period.isNotEmpty) {
    var periodTwoStart = period[0].startTime;
    if (periodTwoStart.isEmpty) {
      return [];
    } else {
      return regularTime.where((element) {
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

final periodFiveStartTimeProvider = StateProvider<List<String>>((ref) {
 var periods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
  var period = periods.where((element) => element.position == 3).toList();
  if (period.isNotEmpty) {
    var periodEndStart = period[0].endTime;
    if (periodEndStart.isEmpty) {
      return [];
    } else {
      return regularTime.where((element) {
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

final periodFiveEndTimeProvider = StateProvider<List<String>>((ref) {
 var periods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
  var period = periods.where((element) => element.position == 4).toList();
  if (period.isNotEmpty) {
    var periodTwoStart = period[0].startTime;
    if (periodTwoStart.isEmpty) {
      return [];
    } else {
      return regularTime.where((element) {
        var time = AppUtils.stringToTimeOfDay(element);
        var periodFiveStartTime = AppUtils.stringToTimeOfDay(periodTwoStart);
        //add 30 minutes to the start time
        periodFiveStartTime = TimeOfDay(
            hour: periodFiveStartTime.hour + 1,
            minute: periodFiveStartTime.minute);
        var difference = AppUtils.compareTimeOfDay(time, periodFiveStartTime);
        return difference > 0;
      }).toList();
    }
  } else {
    return [];
  }
});
