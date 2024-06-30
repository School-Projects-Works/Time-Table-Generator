import 'dart:convert';
import 'package:flutter/foundation.dart';

class ConfigModel {
  String? id;
  String? year;
  String? semester;
  List<String> days;
  List<Map<String, dynamic>> periods;
  String? regLibDay;
  String? evenLibDay;
  String? regLibLevel;
  String? evenLibLevel;
  Map<String, dynamic>? breakTime;
  Map<String, dynamic>? regLibPeriod;
  Map<String, dynamic>? evenLibPeriod;
  int? createdAt;
  ConfigModel({
    this.id,
    this.year,
    this.semester,
    this.days = const [],
    this.periods = const [],
    this.regLibDay,
    this.evenLibDay,
    this.regLibLevel,
    this.evenLibLevel,
    this.breakTime,
    this.regLibPeriod,
    this.evenLibPeriod,
    this.createdAt,
  });

  ConfigModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? year,
    ValueGetter<String?>? semester,
    List<String>? days,
    List<Map<String, dynamic>>? periods,
    ValueGetter<String?>? regLibDay,
    ValueGetter<String?>? evenLibDay,
    ValueGetter<String?>? regLibLevel,
    ValueGetter<String?>? evenLibLevel,
    ValueGetter<Map<String, dynamic>?>? breakTime,
    ValueGetter<Map<String, dynamic>?>? regLibPeriod,
    ValueGetter<Map<String, dynamic>?>? evenLibPeriod,
    int? createdAt,
  }) {
    return ConfigModel(
      id: id != null ? id() : this.id,
      year: year != null ? year() : this.year,
      semester: semester != null ? semester() : this.semester,
      days: days ?? this.days,
      periods: periods ?? this.periods,
      regLibDay: regLibDay != null ? regLibDay() : this.regLibDay,
      evenLibDay: evenLibDay != null ? evenLibDay() : this.evenLibDay,
      regLibLevel: regLibLevel != null ? regLibLevel() : this.regLibLevel,
      evenLibLevel: evenLibLevel != null ? evenLibLevel() : this.evenLibLevel,
      breakTime: breakTime != null ? breakTime() : this.breakTime,
      regLibPeriod: regLibPeriod != null ? regLibPeriod() : this.regLibPeriod,
      evenLibPeriod:
          evenLibPeriod != null ? evenLibPeriod() : this.evenLibPeriod,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'semester': semester,
      'days': days,
      'periods': periods,
      'regLibDay': regLibDay,
      'evenLibDay': evenLibDay,
      'regLibLevel': regLibLevel,
      'evenLibLevel': evenLibLevel,
      'breakTime': breakTime,
      'regLibPeriod': regLibPeriod,
      'evenLibPeriod': evenLibPeriod,
      'createdAt': createdAt,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      id: map['id'],
      year: map['year'],
      semester: map['semester'],
      days: List<String>.from(map['days']),
      periods: List<Map<String, dynamic>>.from(
          map['periods']?.map((x) => Map<String, dynamic>.from(x))),
      regLibDay: map['regLibDay'],
      evenLibDay: map['evenLibDay'],
      regLibLevel: map['regLibLevel'],
      evenLibLevel: map['evenLibLevel'],
      breakTime: Map<String, dynamic>.from(map['breakTime']),
      regLibPeriod: Map<String, dynamic>.from(map['regLibPeriod']),
      evenLibPeriod: Map<String, dynamic>.from(map['evenLibPeriod']),
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) =>
      ConfigModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConfigModel(id: $id, year: $year, semester: $semester, days: $days, periods: $periods, regLibDay: $regLibDay, evenLibDay: $evenLibDay, regLibLevel: $regLibLevel, evenLibLevel: $evenLibLevel, breakTime: $breakTime, regLibPeriod: $regLibPeriod, evenLibPeriod: $evenLibPeriod, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConfigModel &&
        other.id == id &&
        other.year == year &&
        other.semester == semester &&
        listEquals(other.days, days) &&
        listEquals(other.periods, periods) &&
        other.regLibDay == regLibDay &&
        other.evenLibDay == evenLibDay &&
        other.regLibLevel == regLibLevel &&
        other.evenLibLevel == evenLibLevel &&
        mapEquals(other.breakTime, breakTime) &&
        mapEquals(other.regLibPeriod, regLibPeriod) &&
        mapEquals(other.evenLibPeriod, evenLibPeriod) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        year.hashCode ^
        semester.hashCode ^
        days.hashCode ^
        periods.hashCode ^
        regLibDay.hashCode ^
        evenLibDay.hashCode ^
        regLibLevel.hashCode ^
        evenLibLevel.hashCode ^
        breakTime.hashCode ^
        regLibPeriod.hashCode ^
        evenLibPeriod.hashCode ^
        createdAt.hashCode;
  }
}
