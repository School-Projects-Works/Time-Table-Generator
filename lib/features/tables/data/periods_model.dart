import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodsModel {
  String period;
  TimeOfDay startTime;
  TimeOfDay endTime;
  PeriodsModel({
    required this.period,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'period': period,
      'startTime': startTime,
      'endTime': endTime,
    };
  }


  factory PeriodsModel.fromMap(Map<String, dynamic> map) {
    return PeriodsModel(
      period: map['period'] ?? '',
      startTime: stringToTimeOfDay(map['startTime']),
      endTime: stringToTimeOfDay(map['endTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PeriodsModel.fromJson(String source) => PeriodsModel.fromMap(json.decode(source));
}
TimeOfDay stringToTimeOfDay(String time) {
  int hh = 0;
  if (time.endsWith('PM')) hh = 12;
  time = time.split(' ')[0];
  return TimeOfDay(
    hour: hh +
        int.parse(time.split(":")[0]) %
            24, // in case of a bad time format entered manually by the user
    minute: int.parse(time.split(":")[1]) % 60,
  );
  
}
