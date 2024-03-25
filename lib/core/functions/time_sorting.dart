import 'package:flutter/material.dart';

int compareTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
  var totalMinutes1 = time1.hour * 60 + time1.minute;
  var totalMinutes2 = time2.hour * 60 + time2.minute;
  return totalMinutes1.compareTo(totalMinutes2);
}
