import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'config_model.g.dart';

@HiveType(typeId: 0)
class ConfigModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? year;
  @HiveField(2)
  String? semester;
  @HiveField(3)
  Map<String, dynamic> regular;
  ConfigModel({
    this.id,
    this.year,
    this.semester,
    required this.regular,
  });

  ConfigModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? year,
    ValueGetter<String?>? semester,
    Map<String, dynamic>? regular,
  }) {
    return ConfigModel(
      id: id != null ? id() : this.id,
      year: year != null ? year() : this.year,
      semester: semester != null ? semester() : this.semester,
      regular: regular ?? this.regular,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'semester': semester,
      'regular': regular,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      id: map['id'],
      year: map['year'],
      semester: map['semester'],
      regular: Map<String, dynamic>.from(map['regular']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) =>
      ConfigModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConfigModel(id: $id, year: $year, semester: $semester, regular: $regular)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConfigModel &&
        other.id == id &&
        other.year == year &&
        other.semester == semester &&
        mapEquals(other.regular, regular);
  }

  @override
  int get hashCode {
    return id.hashCode ^ year.hashCode ^ semester.hashCode ^ regular.hashCode;
  }
}

class StudyModeModel {
  List<String> days;
  List<Map<String, dynamic>> periods;
  String? regLibDay;
  String? evenLibDay;
  Map<String, dynamic>? regLibPeriod;
  String? regLibLevel;
  String? evenLibLevel;
  List<Map<String, dynamic>> breakTime;
  StudyModeModel({
    this.days = const [],
    this.periods = const [],
    this.regLibDay,
    this.evenLibDay,
    this.regLibPeriod,
    this.regLibLevel,
    this.evenLibLevel,
    this.breakTime = const [],
  });

  StudyModeModel copyWith({
    List<String>? days,
    List<Map<String, dynamic>>? periods,
    ValueGetter<String?>? regLibDay,
    ValueGetter<String?>? evenLibDay,
    ValueGetter<Map<String, dynamic>?>? regLibPeriod,
    ValueGetter<String?>? regLibLevel,
    ValueGetter<String?>? evenLibLevel,
    List<Map<String, dynamic>>? breakTime,
  }) {
    return StudyModeModel(
      days: days ?? this.days,
      periods: periods ?? this.periods,
      regLibDay: regLibDay != null ? regLibDay() : this.regLibDay,
      evenLibDay: evenLibDay != null ? evenLibDay() : this.evenLibDay,
      regLibPeriod: regLibPeriod != null ? regLibPeriod() : this.regLibPeriod,
      regLibLevel: regLibLevel != null ? regLibLevel() : this.regLibLevel,
      evenLibLevel: evenLibLevel != null ? evenLibLevel() : this.evenLibLevel,
      breakTime: breakTime ?? this.breakTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'days': days,
      'periods': periods,
      'regLibDay': regLibDay,
      'evenLibDay': evenLibDay,
      'regLibPeriod': regLibPeriod,
      'regLibLevel': regLibLevel,
      'evenLibLevel': evenLibLevel,
      'breakTime': breakTime,
    };
  }

  factory StudyModeModel.fromMap(Map<String, dynamic> map) {
    return StudyModeModel(
      days: List<String>.from(map['days']),
      periods: List<Map<String, dynamic>>.from(map['periods']?.map((x) => Map<String, dynamic>.from(x))),
      regLibDay: map['regLibDay'],
      evenLibDay: map['evenLibDay'],
      regLibPeriod: Map<String, dynamic>.from(map['regLibPeriod']),
      regLibLevel: map['regLibLevel'],
      evenLibLevel: map['evenLibLevel'],
      breakTime: List<Map<String, dynamic>>.from(map['breakTime']?.map((x) => Map<String, dynamic>.from(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory StudyModeModel.fromJson(String source) =>
      StudyModeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StudyModeModel(days: $days, periods: $periods, regLibDay: $regLibDay, evenLibDay: $evenLibDay, regLibPeriod: $regLibPeriod, regLibLevel: $regLibLevel, evenLibLevel: $evenLibLevel, breakTime: $breakTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StudyModeModel &&
      listEquals(other.days, days) &&
      listEquals(other.periods, periods) &&
      other.regLibDay == regLibDay &&
      other.evenLibDay == evenLibDay &&
      mapEquals(other.regLibPeriod, regLibPeriod) &&
      other.regLibLevel == regLibLevel &&
      other.evenLibLevel == evenLibLevel &&
      listEquals(other.breakTime, breakTime);
  }

  @override
  int get hashCode {
    return days.hashCode ^
      periods.hashCode ^
      regLibDay.hashCode ^
      evenLibDay.hashCode ^
      regLibPeriod.hashCode ^
      regLibLevel.hashCode ^
      evenLibLevel.hashCode ^
      breakTime.hashCode;
  }
}
