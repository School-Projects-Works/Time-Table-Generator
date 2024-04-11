import 'dart:convert';

import 'package:flutter/material.dart';

class PeriodsModel {
  String period;
  String startTime;
  String endTime;
  int position;
  PeriodsModel({
    required this.period,
    required this.startTime,
    required this.endTime,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'period': period,
      'startTime': startTime,
      'endTime': endTime,
      'position': position,
    };
  }

  factory PeriodsModel.fromMap(Map<String, dynamic> map) {
    return PeriodsModel(
      period: map['period'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      position: map['position']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PeriodsModel.fromJson(String source) =>
      PeriodsModel.fromMap(json.decode(source));

  PeriodsModel copyWith({
    String? period,
    String? startTime,
    String? endTime,
    int? position,
  }) {
    return PeriodsModel(
      period: period ?? this.period,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      position: position ?? this.position,
    );
  }

  @override
  String toString() {
    return 'PeriodsModel(period: $period, startTime: $startTime, endTime: $endTime, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PeriodsModel &&
      other.period == period &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.position == position;
  }

  @override
  int get hashCode {
    return period.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      position.hashCode;
  }
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
