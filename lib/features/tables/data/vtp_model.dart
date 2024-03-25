import 'dart:convert';

import 'package:flutter/foundation.dart';


class VTPModel {
  String? id;
  String? venueName;
  String? venueId;
  int? venueCapacity;
  bool? dissabledAccess;
  Map<String, dynamic>? periodMap;
  String? day;
  String? studyMode;
  String? period;
  String? year;
  String? semester;
  bool? isSpecialVenue;
  bool isBooked;
  VTPModel({
    this.id,
    this.venueName,
    this.venueId,
    this.venueCapacity,
    this.dissabledAccess,
    this.periodMap,
    this.day,
    this.studyMode,
    this.period,
    this.year,
    this.semester,
    this.isSpecialVenue,
    required this.isBooked,
  });

  VTPModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? venueName,
    ValueGetter<String?>? venueId,
    ValueGetter<int?>? venueCapacity,
    ValueGetter<bool?>? dissabledAccess,
    ValueGetter<Map<String, dynamic>?>? periodMap,
    ValueGetter<String?>? day,
    ValueGetter<String?>? studyMode,
    ValueGetter<String?>? period,
    ValueGetter<String?>? year,
    ValueGetter<String?>? semester,
    ValueGetter<bool?>? isSpecialVenue,
    bool? isBooked,
  }) {
    return VTPModel(
      id: id != null ? id() : this.id,
      venueName: venueName != null ? venueName() : this.venueName,
      venueId: venueId != null ? venueId() : this.venueId,
      venueCapacity: venueCapacity != null ? venueCapacity() : this.venueCapacity,
      dissabledAccess: dissabledAccess != null ? dissabledAccess() : this.dissabledAccess,
      periodMap: periodMap != null ? periodMap() : this.periodMap,
      day: day != null ? day() : this.day,
      studyMode: studyMode != null ? studyMode() : this.studyMode,
      period: period != null ? period() : this.period,
      year: year != null ? year() : this.year,
      semester: semester != null ? semester() : this.semester,
      isSpecialVenue: isSpecialVenue != null ? isSpecialVenue() : this.isSpecialVenue,
      isBooked: isBooked ?? this.isBooked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'venueName': venueName,
      'venueId': venueId,
      'venueCapacity': venueCapacity,
      'dissabledAccess': dissabledAccess,
      'periodMap': periodMap,
      'day': day,
      'studyMode': studyMode,
      'period': period,
      'year': year,
      'semester': semester,
      'isSpecialVenue': isSpecialVenue,
      'isBooked': isBooked,
    };
  }

  factory VTPModel.fromMap(Map<String, dynamic> map) {
    return VTPModel(
      id: map['id'],
      venueName: map['venueName'],
      venueId: map['venueId'],
      venueCapacity: map['venueCapacity']?.toInt(),
      dissabledAccess: map['dissabledAccess'],
      periodMap: Map<String, dynamic>.from(map['periodMap']),
      day: map['day'],
      studyMode: map['studyMode'],
      period: map['period'],
      year: map['year'],
      semester: map['semester'],
      isSpecialVenue: map['isSpecialVenue'],
      isBooked: map['isBooked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory VTPModel.fromJson(String source) => VTPModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VTPModel(id: $id, venueName: $venueName, venueId: $venueId, venueCapacity: $venueCapacity, dissabledAccess: $dissabledAccess, periodMap: $periodMap, day: $day, studyMode: $studyMode, period: $period, year: $year, semester: $semester, isSpecialVenue: $isSpecialVenue, isBooked: $isBooked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is VTPModel &&
      other.id == id &&
      other.venueName == venueName &&
      other.venueId == venueId &&
      other.venueCapacity == venueCapacity &&
      other.dissabledAccess == dissabledAccess &&
      mapEquals(other.periodMap, periodMap) &&
      other.day == day &&
      other.studyMode == studyMode &&
      other.period == period &&
      other.year == year &&
      other.semester == semester &&
      other.isSpecialVenue == isSpecialVenue &&
      other.isBooked == isBooked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      venueName.hashCode ^
      venueId.hashCode ^
      venueCapacity.hashCode ^
      dissabledAccess.hashCode ^
      periodMap.hashCode ^
      day.hashCode ^
      studyMode.hashCode ^
      period.hashCode ^
      year.hashCode ^
      semester.hashCode ^
      isSpecialVenue.hashCode ^
      isBooked.hashCode;
  }
}
