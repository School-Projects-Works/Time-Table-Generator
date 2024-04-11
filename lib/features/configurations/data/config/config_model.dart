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
  ConfigModel({
    this.id,
    this.year,
    this.semester,
     this.days=const[],
     this.periods=const[],
    this.regLibDay,
    this.evenLibDay,
    this.regLibLevel,
    this.evenLibLevel,
    this.breakTime,
    this.regLibPeriod,
    this.evenLibPeriod,
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
      evenLibPeriod: evenLibPeriod != null ? evenLibPeriod() : this.evenLibPeriod,
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
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      id: map['id'],
      year: map['year'],
      semester: map['semester'],
      days:map['days']!=null? List<String>.from(map['days']):[],
      periods:map['periods']!=null? List<Map<String, dynamic>>.from(map['periods']?.map((x) => Map<String, dynamic>.from(x))):[],
      regLibDay: map['regLibDay'],
      evenLibDay: map['evenLibDay'],
      regLibLevel: map['regLibLevel'],
      evenLibLevel: map['evenLibLevel'],
      breakTime:map['breakTime']!=null? Map<String, dynamic>.from(map['breakTime']):null,
      regLibPeriod:map['regLibPeriod']!=null? Map<String, dynamic>.from(map['regLibPeriod']):null,
      evenLibPeriod:map['evenLibPeriod']!=null? Map<String, dynamic>.from(map['evenLibPeriod']):null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigModel.fromJson(String source) =>
      ConfigModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConfigModel(id: $id, year: $year, semester: $semester, days: $days, periods: $periods, regLibDay: $regLibDay, evenLibDay: $evenLibDay, regLibLevel: $regLibLevel, evenLibLevel: $evenLibLevel, breakTime: $breakTime, regLibPeriod: $regLibPeriod, evenLibPeriod: $evenLibPeriod)';
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
      mapEquals(other.evenLibPeriod, evenLibPeriod);
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
      evenLibPeriod.hashCode;
  }
}

// class StudyModeModel {
//   List<String> days;
//   List<Map<String, dynamic>> periods;
//   String? regLibDay;
//   String? evenLibDay;
//   Map<String, dynamic>? regLibPeriod;
//   String? regLibLevel;
//   String? evenLibLevel;
//   List<Map<String, dynamic>> breakTime;
//   StudyModeModel({
//     this.days = const [],
//     this.periods = const [],
//     this.regLibDay,
//     this.evenLibDay,
//     this.regLibPeriod,
//     this.regLibLevel,
//     this.evenLibLevel,
//     this.breakTime = const [],
//   });

//   StudyModeModel copyWith({
//     List<String>? days,
//     List<Map<String, dynamic>>? periods,
//     ValueGetter<String?>? regLibDay,
//     ValueGetter<String?>? evenLibDay,
//     ValueGetter<Map<String, dynamic>?>? regLibPeriod,
//     ValueGetter<String?>? regLibLevel,
//     ValueGetter<String?>? evenLibLevel,
//     List<Map<String, dynamic>>? breakTime,
//   }) {
//     return StudyModeModel(
//       days: days ?? this.days,
//       periods: periods ?? this.periods,
//       regLibDay: regLibDay != null ? regLibDay() : this.regLibDay,
//       evenLibDay: evenLibDay != null ? evenLibDay() : this.evenLibDay,
//       regLibPeriod: regLibPeriod != null ? regLibPeriod() : this.regLibPeriod,
//       regLibLevel: regLibLevel != null ? regLibLevel() : this.regLibLevel,
//       evenLibLevel: evenLibLevel != null ? evenLibLevel() : this.evenLibLevel,
//       breakTime: breakTime ?? this.breakTime,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'days': days,
//       'periods': periods,
//       'regLibDay': regLibDay,
//       'evenLibDay': evenLibDay,
//       'regLibPeriod': regLibPeriod,
//       'regLibLevel': regLibLevel,
//       'evenLibLevel': evenLibLevel,
//       'breakTime': breakTime,
//     };
//   }

//   factory StudyModeModel.fromMap(Map<String, dynamic> map) {
//     return StudyModeModel(
//       days: List<String>.from(map['days']),
//       periods: List<Map<String, dynamic>>.from(
//           map['periods']?.map((x) => Map<String, dynamic>.from(x))),
//       regLibDay: map['regLibDay'],
//       evenLibDay: map['evenLibDay'],
//       regLibPeriod: map['regLibPeriod'] != null
//           ? Map<String, dynamic>.from(map['regLibPeriod'])
//           : null,
//       regLibLevel: map['regLibLevel'],
//       evenLibLevel: map['evenLibLevel'],
//       breakTime: List<Map<String, dynamic>>.from(
//           map['breakTime']?.map((x) => Map<String, dynamic>.from(x))),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory StudyModeModel.fromJson(String source) =>
//       StudyModeModel.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'StudyModeModel(days: $days, periods: $periods, regLibDay: $regLibDay, evenLibDay: $evenLibDay, regLibPeriod: $regLibPeriod, regLibLevel: $regLibLevel, evenLibLevel: $evenLibLevel, breakTime: $breakTime)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is StudyModeModel &&
//         listEquals(other.days, days) &&
//         listEquals(other.periods, periods) &&
//         other.regLibDay == regLibDay &&
//         other.evenLibDay == evenLibDay &&
//         mapEquals(other.regLibPeriod, regLibPeriod) &&
//         other.regLibLevel == regLibLevel &&
//         other.evenLibLevel == evenLibLevel &&
//         listEquals(other.breakTime, breakTime);
//   }

//   @override
//   int get hashCode {
//     return days.hashCode ^
//         periods.hashCode ^
//         regLibDay.hashCode ^
//         evenLibDay.hashCode ^
//         regLibPeriod.hashCode ^
//         regLibLevel.hashCode ^
//         evenLibLevel.hashCode ^
//         breakTime.hashCode;
//   }
// }
