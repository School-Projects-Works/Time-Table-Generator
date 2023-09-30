import 'package:flutter/material.dart';

int compareTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
  if (time1.hour < time2.hour) {
    return -1;
  } else if (time1.hour > time2.hour) {
    return 1;
  } else {
    // Hours are the same, compare minutes
    if (time1.minute < time2.minute) {
      return -1;
    } else if (time1.minute > time2.minute) {
      return 1;
    } else {
      // Minutes are the same, the times are equal
      return 0;
    }
  }
}






