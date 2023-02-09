// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TableItemModel {
  String? id;
  String? academicYear;

  String? day;
  String? period;
  String? targetStudents;
  Map<dynamic, dynamic>? periodMap;

  String? courseCode;
  String? courseId;
  String? lecturerName;
  String? lecturerEmail;
  String? courseTitle;

  String? creditHours;
  List<String>? specialVenues;
  String? venue;
  String? venueId;
  String? venueCapacity;
  String? venueHasDisability;
  String? isSpecialVenue;

  String? classLevel;
  String? className;
  String? department;
  String? classSize;
  String? classHasDisability;
  String? classId;

  TableItemModel({
    this.id,
    this.academicYear,
    this.day,
    this.period,
    this.targetStudents,
    this.periodMap,
    this.courseCode,
    this.courseId,
    this.lecturerName,
    this.lecturerEmail,
    this.courseTitle,
    this.creditHours,
    this.specialVenues,
    this.venue,
    this.venueId,
    this.venueCapacity,
    this.venueHasDisability,
    this.isSpecialVenue,
    this.classLevel,
    this.className,
    this.department,
    this.classSize,
    this.classHasDisability,
    this.classId,
  });

  TableItemModel copyWith({
    String? id,
    String? academicYear,
    String? day,
    String? period,
    String? targetStudents,
    Map<dynamic, dynamic>? periodMap,
    String? courseCode,
    String? courseId,
    String? lecturerName,
    String? lecturerEmail,
    String? courseTitle,
    String? creditHours,
    List<String>? specialVenues,
    String? venue,
    String? venueId,
    String? venueCapacity,
    String? venueHasDisability,
    String? isSpecialVenue,
    String? classLevel,
    String? className,
    String? department,
    String? classSize,
    String? classHasDisability,
    String? classId,
  }) {
    return TableItemModel(
      id: id ?? this.id,
      academicYear: academicYear ?? this.academicYear,
      day: day ?? this.day,
      period: period ?? this.period,
      targetStudents: targetStudents ?? this.targetStudents,
      periodMap: periodMap ?? this.periodMap,
      courseCode: courseCode ?? this.courseCode,
      courseId: courseId ?? this.courseId,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturerEmail: lecturerEmail ?? this.lecturerEmail,
      courseTitle: courseTitle ?? this.courseTitle,
      creditHours: creditHours ?? this.creditHours,
      specialVenues: specialVenues ?? this.specialVenues,
      venue: venue ?? this.venue,
      venueId: venueId ?? this.venueId,
      venueCapacity: venueCapacity ?? this.venueCapacity,
      venueHasDisability: venueHasDisability ?? this.venueHasDisability,
      isSpecialVenue: isSpecialVenue ?? this.isSpecialVenue,
      classLevel: classLevel ?? this.classLevel,
      className: className ?? this.className,
      department: department ?? this.department,
      classSize: classSize ?? this.classSize,
      classHasDisability: classHasDisability ?? this.classHasDisability,
      classId: classId ?? this.classId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id ?? '',
      'academicYear': academicYear ?? '',
      'day': day ?? '',
      'period': period ?? '',
      'targetStudents': targetStudents ?? '',
      'periodMap': periodMap as Map<String, dynamic>,
      'courseCode': courseCode ?? '',
      'courseId': courseId ?? '',
      'lecturerName': lecturerName ?? '',
      'lecturerEmail': lecturerEmail ?? '',
      'courseTitle': courseTitle ?? '',
      'creditHours': creditHours ?? '',
      'specialVenues': specialVenues ?? <String>[],
      'venue': venue ?? '',
      'venueId': venueId ?? '',
      'venueCapacity': venueCapacity ?? '',
      'venueHasDisability': venueHasDisability ?? '',
      'isSpecialVenue': isSpecialVenue ?? '',
      'classLevel': classLevel ?? '',
      'className': className ?? '',
      'department': department ?? '',
      'classSize': classSize ?? '',
      'classHasDisability': classHasDisability ?? '',
      'classId': classId ?? '',
    };
  }

  factory TableItemModel.fromMap(Map<String, dynamic> map) {
    return TableItemModel(
      id: map['id'] ?? '',
      academicYear: map['academicYear'] ?? '',
      day: map['day'] ?? '',
      period: map['period'] ?? '',
      targetStudents: map['targetStudents'] ?? '',
      periodMap: map['periodMap'],
      courseCode: map['courseCode'] ?? '',
      courseId: map['courseId'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturerEmail: map['lecturerEmail'] ?? '',
      courseTitle: map['courseTitle'] ?? '',
      creditHours: map['creditHours'] ?? '',
      specialVenues: map['specialVenues'] ?? [],
      venue: map['venue'] ?? '',
      venueId: map['venueId'] ?? '',
      venueCapacity: map['venueCapacity'] ?? '',
      venueHasDisability: map['venueHasDisability'] ?? '',
      isSpecialVenue: map['isSpecialVenue'] ?? '',
      classLevel: map['classLevel'] ?? '',
      className: map['className'] ?? '',
      department: map['department'] ?? '',
      classSize: map['classSize'] ?? '',
      classHasDisability: map['classHasDisability'] ?? '',
      classId: map['classId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TableItemModel.fromJson(String source) =>
      TableItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TableModel(id: $id, academicYear: $academicYear, day: $day, period: $period, targetStudents: $targetStudents, periodMap: $periodMap, courseCode: $courseCode, courseId: $courseId, lecturerName: $lecturerName, lecturerEmail: $lecturerEmail, courseTitle: $courseTitle, creditHours: $creditHours, specialVenues: $specialVenues, venue: $venue, venueId: $venueId, venueCapacity: $venueCapacity, venueHasDisability: $venueHasDisability, isSpecialVenue: $isSpecialVenue, classLevel: $classLevel, className: $className, department: $department, classSize: $classSize, classHasDisability: $classHasDisability, classId: $classId)';
  }

  @override
  bool operator ==(covariant TableItemModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.academicYear == academicYear &&
        other.day == day &&
        other.period == period &&
        other.targetStudents == targetStudents &&
        mapEquals(other.periodMap, periodMap) &&
        other.courseCode == courseCode &&
        other.courseId == courseId &&
        other.lecturerName == lecturerName &&
        other.lecturerEmail == lecturerEmail &&
        other.courseTitle == courseTitle &&
        other.creditHours == creditHours &&
        listEquals(other.specialVenues, specialVenues) &&
        other.venue == venue &&
        other.venueId == venueId &&
        other.venueCapacity == venueCapacity &&
        other.venueHasDisability == venueHasDisability &&
        other.isSpecialVenue == isSpecialVenue &&
        other.classLevel == classLevel &&
        other.className == className &&
        other.department == department &&
        other.classSize == classSize &&
        other.classHasDisability == classHasDisability &&
        other.classId == classId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        academicYear.hashCode ^
        day.hashCode ^
        period.hashCode ^
        targetStudents.hashCode ^
        periodMap.hashCode ^
        courseCode.hashCode ^
        courseId.hashCode ^
        lecturerName.hashCode ^
        lecturerEmail.hashCode ^
        courseTitle.hashCode ^
        creditHours.hashCode ^
        specialVenues.hashCode ^
        venue.hashCode ^
        venueId.hashCode ^
        venueCapacity.hashCode ^
        venueHasDisability.hashCode ^
        isSpecialVenue.hashCode ^
        classLevel.hashCode ^
        className.hashCode ^
        department.hashCode ^
        classSize.hashCode ^
        classHasDisability.hashCode ^
        classId.hashCode;
  }
}
