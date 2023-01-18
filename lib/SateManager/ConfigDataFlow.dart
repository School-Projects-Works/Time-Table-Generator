// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:aamusted_timetable_generator/Models/Config/DayModel.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import '../Models/Config/ConfigModel.dart';
import '../Models/Config/PeriodModel.dart';

class ConfigDataFlow extends ChangeNotifier {
  var data = HiveCache.getConfigList();
  ConfigModel configurations = ConfigModel();
  ConfigModel get getConfigurations => configurations;

  List<String>? configList = [];
  List<String>? get getConfigList => configList;

  void updateConfigList() {
    var data = HiveCache.getConfigList();
    if (data.isNotEmpty) {
      configList!.clear();
      for (ConfigModel config in data) {
        configList!.add(config.academicName!);
      }
    }
    notifyListeners();
  }

  String? liberalCourseDay, liberalCoursePeriod;
  String? get getLiberalCourseDay => liberalCourseDay;
  String? get getLiberalCoursePeriod => liberalCoursePeriod;

  void updateConfigurations(ConfigModel newConfigurations) {
    configurations = newConfigurations;
    if (configurations.days != null) {
      monday = DaysModel.fromJson(configurations.days!
          .where((element) => element['day'] == "Monday")
          .first);
      tuesday = DaysModel.fromJson(configurations.days!
          .where((element) => element['day'] == "Tuesday")
          .first);
      wednesday = DaysModel.fromJson(configurations.days!
          .where((element) => element['day'] == "Wednesday")
          .first);
      thursday = DaysModel.fromJson(configurations.days!
          .where((element) => element['day'] == "Thursday")
          .first);
      friday = DaysModel.fromJson(configurations.days!
          .where((element) => element['day'] == "Friday")
          .first);
      saturday = DaysModel.fromJson(configurations.days!
          .where((element) => element['day'] == "Saturday")
          .first);
      sunday = DaysModel.fromJson(configurations.days!
          .where((element) => element['day'] == "Sunday")
          .first);
    } else {
      monday = DaysModel().clear();
      tuesday = DaysModel().clear();
      wednesday = DaysModel().clear();
      thursday = DaysModel().clear();
      friday = DaysModel().clear();
      saturday = DaysModel().clear();
      sunday = DaysModel().clear();
    }
    if (configurations.periods != null && configurations.periods!.isNotEmpty) {
      periodOne = PeriodModel.fromJson(configurations.periods!
          .where((element) => element['period'] == "1st Period")
          .first);
      periodTwo = PeriodModel.fromJson(configurations.periods!
          .where((element) => element['period'] == "2nd Period")
          .first);
      periodThree = PeriodModel.fromJson(configurations.periods!
          .where((element) => element['period'] == "3rd Period")
          .first);
      periodFour = PeriodModel.fromJson(configurations.periods!
          .where((element) => element['period'] == "4th Period")
          .first);
    } else {
      periodOne = PeriodModel().clear();
      periodTwo = PeriodModel().clear();
      periodThree = PeriodModel().clear();
      periodFour = PeriodModel().clear();
    }
    liberalCourseDay = configurations.liberalCourseDay != null
        ? configurations.liberalCourseDay!['day']
        : null;
    liberalCoursePeriod = configurations.liberalCoursePeriod != null
        ? configurations.liberalCoursePeriod!['period']
        : null;
    notifyListeners();
  }

  DaysModel monday = DaysModel().clear();
  DaysModel get getMonday => monday;
  void updateMonday(String newMonday) {
    if (monday.day == null) {
      monday.day = newMonday;
    } else {
      monday.clear();
    }
    notifyListeners();
  }

  DaysModel tuesday = DaysModel().clear();
  DaysModel get getTuesday => tuesday;
  void updateTuesday(String newTuesday) {
    if (tuesday.day == null) {
      tuesday.day = newTuesday;
    } else {
      tuesday.clear();
    }
    notifyListeners();
  }

  DaysModel wednesday = DaysModel().clear();
  DaysModel get getWednesday => wednesday;
  void updateWednesday(String newWednesday) {
    if (wednesday.day == null) {
      wednesday.day = newWednesday;
    } else {
      wednesday.clear();
    }
    notifyListeners();
  }

  DaysModel thursday = DaysModel().clear();
  DaysModel get getThursday => thursday;
  void updateThursday(String newThursday) {
    if (thursday.day == null) {
      thursday.day = newThursday;
    } else {
      thursday.clear();
    }
    notifyListeners();
  }

  DaysModel friday = DaysModel().clear();
  DaysModel get getFriday => friday;
  void updateFriday(String newFriday) {
    if (friday.day == null) {
      friday.day = newFriday;
    } else {
      friday.clear();
    }
    notifyListeners();
  }

  DaysModel saturday = DaysModel().clear();
  DaysModel get getSaturday => saturday;
  void updateSaturday(String newSaturday) {
    if (saturday.day == null) {
      saturday.day = newSaturday;
    } else {
      saturday.clear();
    }
    notifyListeners();
  }

  DaysModel sunday = DaysModel().clear();
  DaysModel get getSunday => sunday;
  void updateSunday(String newSunday) {
    if (sunday.day == null) {
      sunday.day = newSunday;
    } else {
      sunday.clear();
    }
    notifyListeners();
  }

  void updateMondayType(String s) {
    switch (s) {
      case '+Regular':
        monday.isRegular = true;
        break;
      case '-Regular':
        monday.isRegular = false;
        break;
      case '+Evening':
        monday.isEvening = true;
        break;
      case '-Evening':
        monday.isEvening = false;
        break;
      case '+Weekend':
        monday.isWeekend = true;
        break;
      case '-Weekend':
        monday.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateTuesdayType(String s) {
    switch (s) {
      case '+Regular':
        tuesday.isRegular = true;
        break;
      case '-Regular':
        tuesday.isRegular = false;
        break;
      case '+Evening':
        tuesday.isEvening = true;
        break;
      case '-Evening':
        tuesday.isEvening = false;
        break;
      case '+Weekend':
        tuesday.isWeekend = true;
        break;
      case '-Weekend':
        tuesday.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateWednesdayType(String s) {
    switch (s) {
      case '+Regular':
        wednesday.isRegular = true;
        break;
      case '-Regular':
        wednesday.isRegular = false;
        break;
      case '+Evening':
        wednesday.isEvening = true;
        break;
      case '-Evening':
        wednesday.isEvening = false;
        break;
      case '+Weekend':
        wednesday.isWeekend = true;
        break;
      case '-Weekend':
        wednesday.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateThursdayType(String s) {
    switch (s) {
      case '+Regular':
        thursday.isRegular = true;
        break;
      case '-Regular':
        thursday.isRegular = false;
        break;
      case '+Evening':
        thursday.isEvening = true;
        break;
      case '-Evening':
        thursday.isEvening = false;
        break;
      case '+Weekend':
        thursday.isWeekend = true;
        break;
      case '-Weekend':
        thursday.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateFridayType(String s) {
    switch (s) {
      case '+Regular':
        friday.isRegular = true;
        break;
      case '-Regular':
        friday.isRegular = false;
        break;
      case '+Evening':
        friday.isEvening = true;
        break;
      case '-Evening':
        friday.isEvening = false;
        break;
      case '+Weekend':
        friday.isWeekend = true;
        break;
      case '-Weekend':
        friday.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateSaturdayType(String s) {
    switch (s) {
      case '+Regular':
        saturday.isRegular = true;
        break;
      case '-Regular':
        saturday.isRegular = false;
        break;
      case '+Evening':
        saturday.isEvening = true;
        break;
      case '-Evening':
        saturday.isEvening = false;
        break;
      case '+Weekend':
        saturday.isWeekend = true;
        break;
      case '-Weekend':
        saturday.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateSundayType(String s) {
    switch (s) {
      case '+Regular':
        sunday.isRegular = true;
        break;
      case '-Regular':
        sunday.isRegular = false;
        break;
      case '+Evening':
        sunday.isEvening = true;
        break;
      case '-Evening':
        sunday.isEvening = false;
        break;
      case '+Weekend':
        sunday.isWeekend = true;
        break;
      case '-Weekend':
        sunday.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  PeriodModel periodOne = PeriodModel().clear();
  PeriodModel get getPeriodOne => periodOne;
  void updatePeriodOne(String newPeriodOne) {
    if (periodOne.period == null || periodOne.period!.isEmpty) {
      periodOne.period = newPeriodOne;
    } else {
      periodOne.clear();
    }
    notifyListeners();
  }

  PeriodModel periodTwo = PeriodModel().clear();
  PeriodModel get getPeriodTwo => periodTwo;
  void updatePeriodTwo(String newPeriodTwo) {
    if (periodTwo.period == null || periodTwo.period!.isEmpty) {
      periodTwo.period = newPeriodTwo;
    } else {
      periodTwo.clear();
    }
    notifyListeners();
  }

  PeriodModel periodThree = PeriodModel().clear();
  PeriodModel get getPeriodThree => periodThree;
  void updatePeriodThree(String newPeriodThree) {
    if (periodThree.period == null || periodThree.period!.isEmpty) {
      periodThree.period = newPeriodThree;
    } else {
      periodThree.clear();
    }
    notifyListeners();
  }

  PeriodModel periodFour = PeriodModel().clear();
  PeriodModel get getPeriodFour => periodFour;
  void updatePeriodFour(String newPeriodFour) {
    if (periodFour.period == null || periodFour.period!.isEmpty) {
      periodFour.period = newPeriodFour;
    } else {
      periodFour.clear();
    }
    notifyListeners();
  }

  void updatePeriodOneType(String s) {
    switch (s) {
      case '+Regular':
        periodOne.isRegular = true;
        break;
      case '-Regular':
        periodOne.isRegular = false;
        break;
      case '+Evening':
        periodOne.isEvening = true;
        break;
      case '-Evening':
        periodOne.isEvening = false;
        break;
      case '+Weekend':
        periodOne.isWeekend = true;
        break;
      case '-Weekend':
        periodOne.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updatePeriodTwoType(String s) {
    switch (s) {
      case '+Regular':
        periodTwo.isRegular = true;
        break;
      case '-Regular':
        periodTwo.isRegular = false;
        break;
      case '+Evening':
        periodTwo.isEvening = true;
        break;
      case '-Evening':
        periodTwo.isEvening = false;
        break;
      case '+Weekend':
        periodTwo.isWeekend = true;
        break;
      case '-Weekend':
        periodTwo.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updatePeriodThreeType(String s) {
    switch (s) {
      case '+Regular':
        periodThree.isRegular = true;
        break;
      case '-Regular':
        periodThree.isRegular = false;
        break;
      case '+Evening':
        periodThree.isEvening = true;
        break;
      case '-Evening':
        periodThree.isEvening = false;
        break;
      case '+Weekend':
        periodThree.isWeekend = true;
        break;
      case '-Weekend':
        periodThree.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updatePeriodFourType(String s) {
    switch (s) {
      case '+Regular':
        periodFour.isRegular = true;
        break;
      case '-Regular':
        periodFour.isRegular = false;
        break;
      case '+Evening':
        periodFour.isEvening = true;
        break;
      case '-Evening':
        periodFour.isEvening = false;
        break;
      case '+Weekend':
        periodFour.isWeekend = true;
        break;
      case '-Weekend':
        periodFour.isWeekend = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void setPeriodOneStart(value) {
    if (value != null) {
      periodOne.startTime = value;
    }
    notifyListeners();
  }

  void setPeriodOneEnd(value) {
    if (value != null) {
      periodOne.endTime = value;
    }
    notifyListeners();
  }

  void setPeriodTwoStart(value) {
    if (value != null) {
      periodTwo.startTime = value;
    }
    notifyListeners();
  }

  void setPeriodTwoEnd(value) {
    if (value != null) {
      periodTwo.endTime = value;
    }
    notifyListeners();
  }

  void setPeriodThreeStart(value) {
    if (value != null) {
      periodThree.startTime = value;
    }
    notifyListeners();
  }

  void setPeriodThreeEnd(value) {
    if (value != null) {
      periodThree.endTime = value;
    }
    notifyListeners();
  }

  void setPeriodFourStart(value) {
    if (value != null) {
      periodFour.startTime = value;
    }
    notifyListeners();
  }

  void setPeriodFourEnd(value) {
    if (value != null) {
      periodFour.endTime = value;
    }
    notifyListeners();
  }

  void saveConfig(HiveListener hiveListener) {
    if (monday.day == null &&
        tuesday.day == null &&
        wednesday.day == null &&
        thursday.day == null &&
        friday.day == null &&
        saturday.day == null &&
        sunday.day == null) {
      CustomDialog.showError(message: 'Please select at least one day');
    } else if (periodOne.period == null &&
        periodTwo.period == null &&
        periodThree.period == null &&
        periodFour.period == null) {
      CustomDialog.showError(message: 'Please select at least one period');
    } else if (periodOne.period != null && periodOne.startTime == null) {
      CustomDialog.showError(
          message: 'Please select start time for period one');
    } else if (periodOne.period != null && periodOne.endTime == null) {
      CustomDialog.showError(message: 'Please select end time for period one');
    } else if (periodTwo.period != null && periodTwo.startTime == null) {
      CustomDialog.showError(
          message: 'Please select start time for period two');
    } else if (periodTwo.period != null && periodTwo.endTime == null) {
      CustomDialog.showError(message: 'Please select end time for period two');
    } else if (periodThree.period != null && periodThree.startTime == null) {
      CustomDialog.showError(
          message: 'Please select start time for period three');
    } else if (periodThree.period != null && periodThree.endTime == null) {
      CustomDialog.showError(
          message: 'Please select end time for period three');
    } else if (periodFour.period != null && periodFour.startTime == null) {
      CustomDialog.showError(
          message: 'Please select start time for period four');
    } else if (periodFour.period != null && periodFour.endTime == null) {
      CustomDialog.showError(message: 'Please select end time for period four');
    } else if (monday.day != null &&
        (monday.isRegular == null || monday.isRegular == false) &&
        (monday.isEvening == null || monday.isEvening == false) &&
        (monday.isWeekend == null || monday.isWeekend == false)) {
      CustomDialog.showError(
          message: 'Please select at least one group of students for Monday');
    } else if (tuesday.day != null &&
        (tuesday.isRegular == null || tuesday.isRegular == false) &&
        (tuesday.isEvening == null || tuesday.isEvening == false) &&
        (tuesday.isWeekend == null || tuesday.isWeekend == false)) {
      CustomDialog.showError(
          message: 'Please select at least one group of students for Tuesday');
    } else if (wednesday.day != null &&
        (wednesday.isRegular == null || wednesday.isRegular == false) &&
        (wednesday.isEvening == null || wednesday.isEvening == false) &&
        (wednesday.isWeekend == null || wednesday.isWeekend == false)) {
      CustomDialog.showError(
          message:
              'Please select at least one group of students for Wednesday');
    } else if (thursday.day != null &&
        (thursday.isRegular == null || thursday.isRegular == false) &&
        (thursday.isEvening == null || thursday.isEvening == false) &&
        (thursday.isWeekend == null || thursday.isWeekend == false)) {
      CustomDialog.showError(
          message: 'Please select at least one group of students for Thursday');
    } else if (friday.day != null &&
        (friday.isRegular == null || friday.isRegular == false) &&
        (friday.isEvening == null || friday.isEvening == false) &&
        (friday.isWeekend == null || friday.isWeekend == false)) {
      CustomDialog.showError(
          message: 'Please select at least one group of students for Friday');
    } else if (saturday.day != null &&
        (saturday.isRegular == null || saturday.isRegular == false) &&
        (saturday.isEvening == null || saturday.isEvening == false) &&
        (saturday.isWeekend == null || saturday.isWeekend == false)) {
      CustomDialog.showError(
          message: 'Please select at least one group of students for Saturday');
    } else if (sunday.day != null &&
        (sunday.isRegular == null || sunday.isRegular == false) &&
        (sunday.isEvening == null || sunday.isEvening == false) &&
        (sunday.isWeekend == null || sunday.isWeekend == false)) {
      CustomDialog.showError(
          message: 'Please select at least one group of students for Sunday');
    } else if (periodOne.period != null &&
        (periodOne.isRegular == null || periodOne.isRegular == false) &&
        (periodOne.isEvening == null || periodOne.isEvening == false) &&
        (periodOne.isWeekend == null || periodOne.isWeekend == false)) {
      CustomDialog.showError(
          message:
              'Please select at least one group of students for period one');
    } else if (periodTwo.period != null &&
        (periodTwo.isRegular == null || periodTwo.isRegular == false) &&
        (periodTwo.isEvening == null || periodTwo.isEvening == false) &&
        (periodTwo.isWeekend == null || periodTwo.isWeekend == false)) {
      CustomDialog.showError(
          message:
              'Please select at least one group of students for period two');
    } else if (periodThree.period != null &&
        (periodThree.isRegular == null || periodThree.isRegular == false) &&
        (periodThree.isEvening == null || periodThree.isEvening == false) &&
        (periodThree.isWeekend == null || periodThree.isWeekend == false)) {
      CustomDialog.showError(
          message:
              'Please select at least one group of students for period three');
    } else if (periodFour.period != null &&
        (periodFour.isRegular == null || periodFour.isRegular == false) &&
        (periodFour.isEvening == null || periodFour.isEvening == false) &&
        (periodFour.isWeekend == null || periodFour.isWeekend == false)) {
      CustomDialog.showError(
          message:
              'Please select at least one group of students for period four');
    } else {
      CustomDialog.showLoading(message: 'Saving configurations...');
      configurations.days = [
        monday.toJson(),
        tuesday.toJson(),
        wednesday.toJson(),
        thursday.toJson(),
        friday.toJson(),
        saturday.toJson(),
        sunday.toJson()
      ];
      configurations.periods = [
        periodOne.toJson(),
        periodTwo.toJson(),
        periodThree.toJson(),
        periodFour.toJson()
      ];

      HiveCache.addConfigurations(configurations);
      updateConfigurations(configurations);
      CustomDialog.dismiss();
      CustomDialog.showSuccess(message: 'Configurations saved successfully');
    }
  }

  void setLiberalDay(Map<String, dynamic> p1) {
    configurations.liberalCourseDay = p1;
    HiveCache.addConfigurations(configurations);
    updateConfigurations(configurations);
    updateConfigList();
  }

  void setLiberalPeriod(Map<String, dynamic> p1) {
    configurations.liberalCoursePeriod = p1;
    HiveCache.addConfigurations(configurations);
    updateConfigurations(configurations);
    updateConfigList();
  }

  void updateHasCourse(bool bool) {
    configurations.hasCourse = bool;
    HiveCache.addConfigurations(configurations);
    updateConfigurations(configurations);
    updateConfigList();
  }

  void updateHasLiberal(bool bool) {
    configurations.hasLiberalCourse = bool;
    HiveCache.addConfigurations(configurations);
    updateConfigurations(configurations);
    updateConfigList();
  }

  void updateHasClass(bool bool) {
    configurations.hasClass = bool;
    HiveCache.addConfigurations(configurations);
    updateConfigurations(configurations);
    updateConfigList();
  }

  void updateHasVenue(data) {
    configurations.hasVenues = data;
    HiveCache.addConfigurations(configurations);
    updateConfigurations(configurations);
    updateConfigList();
  }
}
