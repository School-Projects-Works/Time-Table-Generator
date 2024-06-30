import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class VenueTimePairModel {
  String? id;
  String? venueName;
  String? venueId;
  int? venueCapacity;
  bool? dissabledAccess;
  String startTime;
  String endTime;
  String day;
  String studyMode;
  String period;
  String year;
  String semester;
  bool? isSpecialVenue;
  bool isBooked;
  int position;
  VenueTimePairModel({
    this.id,
    this.venueName,
    this.venueId,
    this.venueCapacity,
    this.dissabledAccess,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.studyMode,
    required this.period,
    required this.year,
    required this.semester,
    this.isSpecialVenue,
    required this.isBooked,
    required this.position,
  });

  VenueTimePairModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? venueName,
    ValueGetter<String?>? venueId,
    ValueGetter<int?>? venueCapacity,
    ValueGetter<bool?>? dissabledAccess,
    String? startTime,
    String? endTime,
    String? day,
    String? studyMode,
    String? period,
    String? year,
    String? semester,
    ValueGetter<bool?>? isSpecialVenue,
    bool? isBooked,
    int? position,
  }) {
    return VenueTimePairModel(
      id: id != null ? id() : this.id,
      venueName: venueName != null ? venueName() : this.venueName,
      venueId: venueId != null ? venueId() : this.venueId,
      venueCapacity:
          venueCapacity != null ? venueCapacity() : this.venueCapacity,
      dissabledAccess:
          dissabledAccess != null ? dissabledAccess() : this.dissabledAccess,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      day: day ?? this.day,
      studyMode: studyMode ?? this.studyMode,
      period: period ?? this.period,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      isSpecialVenue:
          isSpecialVenue != null ? isSpecialVenue() : this.isSpecialVenue,
      isBooked: isBooked ?? this.isBooked,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'venueName': venueName,
      'venueId': venueId,
      'venueCapacity': venueCapacity,
      'dissabledAccess': dissabledAccess,
      'startTime': startTime,
      'endTime': endTime,
      'day': day,
      'studyMode': studyMode,
      'period': period,
      'year': year,
      'semester': semester,
      'isSpecialVenue': isSpecialVenue,
      'isBooked': isBooked,
      'position': position,
    };
  }

  factory VenueTimePairModel.fromMap(Map<String, dynamic> map) {
    return VenueTimePairModel(
      id: map['id'],
      venueName: map['venueName'],
      venueId: map['venueId'],
      venueCapacity: map['venueCapacity']?.toInt(),
      dissabledAccess: map['dissabledAccess'],
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      day: map['day'] ?? '',
      studyMode: map['studyMode'] ?? '',
      period: map['period'] ?? '',
      year: map['year'] ?? '',
      semester: map['semester'] ?? '',
      isSpecialVenue: map['isSpecialVenue'],
      isBooked: map['isBooked'] ?? false,
      position: map['position']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VenueTimePairModel.fromJson(String source) =>
      VenueTimePairModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VTPModel(id: $id, venueName: $venueName, venueId: $venueId, venueCapacity: $venueCapacity, dissabledAccess: $dissabledAccess, startTime: $startTime, endTime: $endTime, day: $day, studyMode: $studyMode, period: $period, year: $year, semester: $semester, isSpecialVenue: $isSpecialVenue, isBooked: $isBooked, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VenueTimePairModel &&
        other.id == id &&
        other.venueName == venueName &&
        other.venueId == venueId &&
        other.venueCapacity == venueCapacity &&
        other.dissabledAccess == dissabledAccess &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.day == day &&
        other.studyMode == studyMode &&
        other.period == period &&
        other.year == year &&
        other.semester == semester &&
        other.isSpecialVenue == isSpecialVenue &&
        other.isBooked == isBooked &&
        other.position == position;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        venueName.hashCode ^
        venueId.hashCode ^
        venueCapacity.hashCode ^
        dissabledAccess.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        day.hashCode ^
        studyMode.hashCode ^
        period.hashCode ^
        year.hashCode ^
        semester.hashCode ^
        isSpecialVenue.hashCode ^
        isBooked.hashCode ^
        position.hashCode;
  }
}
