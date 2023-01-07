import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:flutter/material.dart';
import '../Models/Config/ConfigModel.dart';

class ConfigDataFlow extends ChangeNotifier {
  ConfigModel configurations = ConfigModel();
  ConfigModel get getConfigurations => configurations;
  void updateConfigurations(ConfigModel newConfigurations) {
    configurations = newConfigurations;
    if (configurations.days != null) {
      monday = configurations.days!
          .where((element) => element['day'] == "Monday")
          .first;
      tuesday = configurations.days!
          .where((element) => element['day'] == "Tuesday")
          .first;
      wednesday = configurations.days!
          .where((element) => element['day'] == "Wednesday")
          .first;
      thursday = configurations.days!
          .where((element) => element['day'] == "Thursday")
          .first;
      friday = configurations.days!
          .where((element) => element['day'] == "Friday")
          .first;
      saturday = configurations.days!
          .where((element) => element['day'] == "Saturday")
          .first;
      sunday = configurations.days!
          .where((element) => element['day'] == "Sunday")
          .first;
    }
    notifyListeners();
  }

  Map<String, dynamic> monday = {};
  Map<String, dynamic> get getMonday => monday;
  void updateMonday(String newMonday) {
    if (monday.isEmpty) {
      monday['day'] = newMonday;
    } else {
      monday.clear();
    }
    notifyListeners();
  }

  Map<String, dynamic> tuesday = {};
  Map<String, dynamic> get getTuesday => tuesday;
  void updateTuesday(String newTuesday) {
    if (tuesday.isEmpty) {
      tuesday['day'] = newTuesday;
    } else {
      tuesday.clear();
    }
    notifyListeners();
  }

  Map<String, dynamic> wednesday = {};
  Map<String, dynamic> get getWednesday => wednesday;
  void updateWednesday(String newWednesday) {
    if (wednesday.isEmpty) {
      wednesday['day'] = newWednesday;
    } else {
      wednesday.clear();
    }
    notifyListeners();
  }

  Map<String, dynamic> thursday = {};
  Map<String, dynamic> get getThursday => thursday;
  void updateThursday(String newThursday) {
    if (thursday.isEmpty) {
      thursday['day'] = newThursday;
    } else {
      thursday.clear();
    }
    notifyListeners();
  }

  Map<String, dynamic> friday = {};
  Map<String, dynamic> get getFriday => friday;
  void updateFriday(String newFriday) {
    if (friday.isEmpty) {
      friday['day'] = newFriday;
    } else {
      friday.clear();
    }
    notifyListeners();
  }

  Map<String, dynamic> saturday = {};
  Map<String, dynamic> get getSaturday => saturday;
  void updateSaturday(String newSaturday) {
    if (saturday.isEmpty) {
      saturday['day'] = newSaturday;
    } else {
      saturday.clear();
    }
    notifyListeners();
  }

  Map<String, dynamic> sunday = {};
  Map<String, dynamic> get getSunday => sunday;
  void updateSunday(String newSunday) {
    if (sunday.isEmpty) {
      sunday['day'] = newSunday;
    } else {
      sunday.clear();
    }
    notifyListeners();
  }

  void updateMondayType(String s) {
    switch (s) {
      case '+Regular':
        monday['reg'] = true;
        break;
      case '-Regular':
        monday['reg'] = false;
        break;
      case '+Evening':
        monday['eve'] = true;
        break;
      case '-Evening':
        monday['eve'] = false;
        break;
      case '+Weekend':
        monday['week'] = true;
        break;
      case '-Weekend':
        monday['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateTuesdayType(String s) {
    switch (s) {
      case '+Regular':
        tuesday['reg'] = true;
        break;
      case '-Regular':
        tuesday['reg'] = false;
        break;
      case '+Evening':
        tuesday['eve'] = true;
        break;
      case '-Evening':
        tuesday['eve'] = false;
        break;
      case '+Weekend':
        tuesday['week'] = true;
        break;
      case '-Weekend':
        tuesday['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateWednesdayType(String s) {
    switch (s) {
      case '+Regular':
        wednesday['reg'] = true;
        break;
      case '-Regular':
        wednesday['reg'] = false;
        break;
      case '+Evening':
        wednesday['eve'] = true;
        break;
      case '-Evening':
        wednesday['eve'] = false;
        break;
      case '+Weekend':
        wednesday['week'] = true;
        break;
      case '-Weekend':
        wednesday['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateThursdayType(String s) {
    switch (s) {
      case '+Regular':
        thursday['reg'] = true;
        break;
      case '-Regular':
        thursday['reg'] = false;
        break;
      case '+Evening':
        thursday['eve'] = true;
        break;
      case '-Evening':
        thursday['eve'] = false;
        break;
      case '+Weekend':
        thursday['week'] = true;
        break;
      case '-Weekend':
        thursday['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateFridayType(String s) {
    switch (s) {
      case '+Regular':
        friday['reg'] = true;
        break;
      case '-Regular':
        friday['reg'] = false;
        break;
      case '+Evening':
        friday['eve'] = true;
        break;
      case '-Evening':
        friday['eve'] = false;
        break;
      case '+Weekend':
        friday['week'] = true;
        break;
      case '-Weekend':
        friday['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateSaturdayType(String s) {
    switch (s) {
      case '+Regular':
        saturday['reg'] = true;
        break;
      case '-Regular':
        saturday['reg'] = false;
        break;
      case '+Evening':
        saturday['eve'] = true;
        break;
      case '-Evening':
        saturday['eve'] = false;
        break;
      case '+Weekend':
        saturday['week'] = true;
        break;
      case '-Weekend':
        saturday['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updateSundayType(String s) {
    switch (s) {
      case '+Regular':
        sunday['reg'] = true;
        break;
      case '-Regular':
        sunday['reg'] = false;
        break;
      case '+Evening':
        sunday['eve'] = true;
        break;
      case '-Evening':
        sunday['eve'] = false;
        break;
      case '+Weekend':
        sunday['week'] = true;
        break;
      case '-Weekend':
        sunday['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  Map<String, dynamic> periodOne = {};
  Map<String, dynamic> get getPeriodOne => periodOne;
  void updatePeriodOne(String newPeriodOne) {
    if (periodOne.isEmpty) {
      periodOne['period'] = newPeriodOne;
    } else {
      periodOne.clear();
    }
    notifyListeners();
  }

  Map<String, dynamic> periodTwo = {};
  Map<String, dynamic> get getPeriodTwo => periodTwo;
  void updatePeriodTwo(String newPeriodTwo) {
    if (periodTwo.isEmpty) {
      periodTwo['period'] = newPeriodTwo;
    } else {
      periodTwo.clear();
    }
    notifyListeners();
  }

  Map<String, dynamic> periodThree = {};
  Map<String, dynamic> get getPeriodThree => periodThree;
  void updatePeriodThree(String newPeriodThree) {
    if (periodThree.isEmpty) {
      periodThree['period'] = newPeriodThree;
    } else {
      periodThree.clear();
    }
    notifyListeners();
  }

  Map<String, dynamic> periodFour = {};
  Map<String, dynamic> get getPeriodFour => periodFour;
  void updatePeriodFour(String newPeriodFour) {
    if (periodFour.isEmpty) {
      periodFour['period'] = newPeriodFour;
    } else {
      periodFour.clear();
    }
    notifyListeners();
  }

  void updatePeriodOneType(String s) {
    switch (s) {
      case '+Regular':
        periodOne['reg'] = true;
        break;
      case '-Regular':
        periodOne['reg'] = false;
        break;
      case '+Evening':
        periodOne['eve'] = true;
        break;
      case '-Evening':
        periodOne['eve'] = false;
        break;
      case '+Weekend':
        periodOne['week'] = true;
        break;
      case '-Weekend':
        periodOne['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updatePeriodTwoType(String s) {
    switch (s) {
      case '+Regular':
        periodTwo['reg'] = true;
        break;
      case '-Regular':
        periodTwo['reg'] = false;
        break;
      case '+Evening':
        periodTwo['eve'] = true;
        break;
      case '-Evening':
        periodTwo['eve'] = false;
        break;
      case '+Weekend':
        periodTwo['week'] = true;
        break;
      case '-Weekend':
        periodTwo['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updatePeriodThreeType(String s) {
    switch (s) {
      case '+Regular':
        periodThree['reg'] = true;
        break;
      case '-Regular':
        periodThree['reg'] = false;
        break;
      case '+Evening':
        periodThree['eve'] = true;
        break;
      case '-Evening':
        periodThree['eve'] = false;
        break;
      case '+Weekend':
        periodThree['week'] = true;
        break;
      case '-Weekend':
        periodThree['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void updatePeriodFourType(String s) {
    switch (s) {
      case '+Regular':
        periodFour['reg'] = true;
        break;
      case '-Regular':
        periodFour['reg'] = false;
        break;
      case '+Evening':
        periodFour['eve'] = true;
        break;
      case '-Evening':
        periodFour['eve'] = false;
        break;
      case '+Weekend':
        periodFour['week'] = true;
        break;
      case '-Weekend':
        periodFour['week'] = false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void setPeriodOneStart(value) {
    if (value != null) {
      periodOne['start'] = value;
    }
    notifyListeners();
  }

  void setPeriodOneEnd(value) {
    if (value != null) {
      periodOne['end'] = value;
    }
    notifyListeners();
  }

  void setPeriodTwoStart(value) {
    if (value != null) {
      periodTwo['start'] = value;
    }
    notifyListeners();
  }

  void setPeriodTwoEnd(value) {
    if (value != null) {
      periodTwo['end'] = value;
    }
    notifyListeners();
  }

  void setPeriodThreeStart(value) {
    if (value != null) {
      periodThree['start'] = value;
    }
    notifyListeners();
  }

  void setPeriodThreeEnd(value) {
    if (value != null) {
      periodThree['end'] = value;
    }
    notifyListeners();
  }

  void setPeriodFourStart(value) {
    if (value != null) {
      periodFour['start'] = value;
    }
    notifyListeners();
  }

  void setPeriodFourEnd(value) {
    if (value != null) {
      periodFour['end'] = value;
    }
    notifyListeners();
  }

  void saveConfig() {
    if (monday.isEmpty &&
        tuesday.isEmpty &&
        wednesday.isEmpty &&
        thursday.isEmpty &&
        friday.isEmpty &&
        saturday.isEmpty &&
        sunday.isEmpty) {
     CustomDialog.showError(message: 'Please select at least one day');
    } else if (periodOne.isEmpty &&
        periodTwo.isEmpty &&
        periodThree.isEmpty &&
        periodFour.isEmpty) {
      CustomDialog.showError(message: 'Please select at least one period');
    } else if(periodOne.isNotEmpty && periodOne['start'] == null){
      CustomDialog.showError(message: 'Please select start time for period one');
    } else if(periodOne.isNotEmpty && periodOne['end'] == null){
      CustomDialog.showError(message: 'Please select end time for period one');
    } else if(periodTwo.isNotEmpty && periodTwo['start'] == null){
      CustomDialog.showError(message: 'Please select start time for period two');
    } else if(periodTwo.isNotEmpty && periodTwo['end'] == null){
      CustomDialog.showError(message: 'Please select end time for period two');
    } else if(periodThree.isNotEmpty && periodThree['start'] == null){
      CustomDialog.showError(message: 'Please select start time for period three');
    } else if(periodThree.isNotEmpty && periodThree['end'] == null){
      CustomDialog.showError(message: 'Please select end time for period three');
    } else if(periodFour.isNotEmpty && periodFour['start'] == null){
      CustomDialog.showError(message: 'Please select start time for period four');
    } else if(periodFour.isNotEmpty && periodFour['end'] == null){
      CustomDialog.showError(message: 'Please select end time for period four');
    } else if(monday.isNotEmpty&&(monday['reg']==null||monday['reg']==false)&&
        (monday['eve']==null||monday['eve']==false)&&
        (monday['week']==null||monday['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for Monday');
    } else if(tuesday.isNotEmpty&&(tuesday['reg']==null||tuesday['reg']==false)&&
        (tuesday['eve']==null||tuesday['eve']==false)&&
        (tuesday['week']==null||tuesday['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for Tuesday');
    } else if(wednesday.isNotEmpty&&(wednesday['reg']==null||wednesday['reg']==false)&&
        (wednesday['eve']==null||wednesday['eve']==false)&&
        (wednesday['week']==null||wednesday['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for Wednesday');
    } else if(thursday.isNotEmpty&&(thursday['reg']==null||thursday['reg']==false)&&
        (thursday['eve']==null||thursday['eve']==false)&&
        (thursday['week']==null||thursday['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for Thursday');
    } else if(friday.isNotEmpty&&(friday['reg']==null||friday['reg']==false)&&
        (friday['eve']==null||friday['eve']==false)&&
        (friday['week']==null||friday['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for Friday');
    } else if(saturday.isNotEmpty&&(saturday['reg']==null||saturday['reg']==false)&&
        (saturday['eve']==null||saturday['eve']==false)&&
        (saturday['week']==null||saturday['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for Saturday');
    } else if(sunday.isNotEmpty&&(sunday['reg']==null||sunday['reg']==false)&&
        (sunday['eve']==null||sunday['eve']==false)&&
        (sunday['week']==null||sunday['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for Sunday');
    } else if(periodOne.isNotEmpty&&(periodOne['reg']==null||periodOne['reg']==false)&&
        (periodOne['eve']==null||periodOne['eve']==false)&&
        (periodOne['week']==null||periodOne['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for period one');
    } else if(periodTwo.isNotEmpty&&(periodTwo['reg']==null||periodTwo['reg']==false)&&
        (periodTwo['eve']==null||periodTwo['eve']==false)&&
        (periodTwo['week']==null||periodTwo['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for period two');
    } else if(periodThree.isNotEmpty&&(periodThree['reg']==null||periodThree['reg']==false)&&
        (periodThree['eve']==null||periodThree['eve']==false)&&
        (periodThree['week']==null||periodThree['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for period three');
    } else if(periodFour.isNotEmpty&&(periodFour['reg']==null||periodFour['reg']==false)&&
        (periodFour['eve']==null||periodFour['eve']==false)&&
        (periodFour['week']==null||periodFour['week']==false)){
      CustomDialog.showError(message: 'Please select at least one group of students for period four');
    } else {
      configurations.days =[monday, tuesday, wednesday, thursday, friday, saturday, sunday];
      configurations.periods = [periodOne, periodTwo, periodThree, periodFour];
    }
  }
}
