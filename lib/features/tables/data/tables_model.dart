import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'tables_model.g.dart';
@HiveType(typeId: 7)
class TablesModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? year;

  @HiveField(2)
  String day;
  @HiveField(3)
  String period;
  @HiveField(4)
  String studyMode;
  @HiveField(5)
  Map<String, dynamic>? periodMap;

  @HiveField(6)
  String? courseCode;
  @HiveField(7)
  String courseId;
  @HiveField(8)
  String lecturerName;
  @HiveField(9)
  String? lecturerEmail;
  @HiveField(10)
  String courseTitle;
  @HiveField(11)
  String? creditHours;
  @HiveField(12)
  List<Map<String, dynamic>>? specialVenues;

  @HiveField(13)
  String venueName;
  @HiveField(14)
  String venueId;
  @HiveField(15)
  int venueCapacity;
  @HiveField(16)
  bool? disabilityAccess;
  @HiveField(17)
  bool? isSpecial;

  @HiveField(18)
  String classLevel;
  @HiveField(19)
  String className;
  @HiveField(20)
  String department;
  @HiveField(21)
  String classSize;
  @HiveField(22)
  bool? hasDisable;
  @HiveField(23)
  String semester;

  @HiveField(24)
  String classId;
  @HiveField(25)
  String lecturerId;

  TablesModel({
    this.id,
    this.year,
    required this.day,
    required this.period,
    required this.studyMode,
    this.periodMap,
    this.courseCode,
    required this.courseId,
    required this.lecturerName,
    this.lecturerEmail,
    required this.courseTitle,
    this.creditHours,
    this.specialVenues,
    required this.venueName,
    required this.venueId,
    required this.venueCapacity,
    this.disabilityAccess,
    this.isSpecial,
    required this.classLevel,
    required this.className,
    required this.department,
    required this.classSize,
    this.hasDisable,
    required this.semester,
    required this.classId,
    required this.lecturerId,
  });

  TablesModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? year,
    String? day,
    String? period,
    String? studyMode,
    ValueGetter<Map<String, dynamic>?>? periodMap,
    ValueGetter<String?>? courseCode,
    String? courseId,
    String? lecturerName,
    ValueGetter<String?>? lecturerEmail,
    String? courseTitle,
    ValueGetter<String?>? creditHours,
    ValueGetter<List<Map<String, dynamic>>?>? specialVenues,
    String? venueName,
    String? venueId,
    int? venueCapacity,
    ValueGetter<bool?>? disabilityAccess,
    ValueGetter<bool?>? isSpecial,
    String? classLevel,
    String? className,
    String? department,
    String? classSize,
    ValueGetter<bool?>? hasDisable,
    String? semester,
    String? classId,
    String? lecturerId,
  }) {
    return TablesModel(
      id: id != null ? id() : this.id,
      year: year != null ? year() : this.year,
      day: day ?? this.day,
      period: period ?? this.period,
      studyMode: studyMode ?? this.studyMode,
      periodMap: periodMap != null ? periodMap() : this.periodMap,
      courseCode: courseCode != null ? courseCode() : this.courseCode,
      courseId: courseId ?? this.courseId,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturerEmail: lecturerEmail != null ? lecturerEmail() : this.lecturerEmail,
      courseTitle: courseTitle ?? this.courseTitle,
      creditHours: creditHours != null ? creditHours() : this.creditHours,
      specialVenues: specialVenues != null ? specialVenues() : this.specialVenues,
      venueName: venueName ?? this.venueName,
      venueId: venueId ?? this.venueId,
      venueCapacity: venueCapacity ?? this.venueCapacity,
      disabilityAccess: disabilityAccess != null ? disabilityAccess() : this.disabilityAccess,
      isSpecial: isSpecial != null ? isSpecial() : this.isSpecial,
      classLevel: classLevel ?? this.classLevel,
      className: className ?? this.className,
      department: department ?? this.department,
      classSize: classSize ?? this.classSize,
      hasDisable: hasDisable != null ? hasDisable() : this.hasDisable,
      semester: semester ?? this.semester,
      classId: classId ?? this.classId,
      lecturerId: lecturerId ?? this.lecturerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'day': day,
      'period': period,
      'studyMode': studyMode,
      'periodMap': periodMap,
      'courseCode': courseCode,
      'courseId': courseId,
      'lecturerName': lecturerName,
      'lecturerEmail': lecturerEmail,
      'courseTitle': courseTitle,
      'creditHours': creditHours,
      'specialVenues': specialVenues,
      'venueName': venueName,
      'venueId': venueId,
      'venueCapacity': venueCapacity,
      'disabilityAccess': disabilityAccess,
      'isSpecial': isSpecial,
      'classLevel': classLevel,
      'className': className,
      'department': department,
      'classSize': classSize,
      'hasDisable': hasDisable,
      'semester': semester,
      'classId': classId,
      'lecturerId': lecturerId,
    };
  }

  factory TablesModel.fromMap(Map<String, dynamic> map) {
    return TablesModel(
      id: map['id'],
      year: map['year'],
      day: map['day'] ?? '',
      period: map['period'] ?? '',
      studyMode: map['studyMode'] ?? '',
      periodMap: Map<String, dynamic>.from(map['periodMap']),
      courseCode: map['courseCode'],
      courseId: map['courseId'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturerEmail: map['lecturerEmail'],
      courseTitle: map['courseTitle'] ?? '',
      creditHours: map['creditHours'],
      specialVenues: map['specialVenues'] != null ? List<Map<String, dynamic>>.from(map['specialVenues']?.map((x) => Map<String, dynamic>.from(x))) : null,
      venueName: map['venueName'] ?? '',
      venueId: map['venueId'] ?? '',
      venueCapacity: map['venueCapacity']?.toInt() ?? 0,
      disabilityAccess: map['disabilityAccess'],
      isSpecial: map['isSpecial'],
      classLevel: map['classLevel'] ?? '',
      className: map['className'] ?? '',
      department: map['department'] ?? '',
      classSize: map['classSize'] ?? '',
      hasDisable: map['hasDisable'],
      semester: map['semester'] ?? '',
      classId: map['classId'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TablesModel.fromJson(String source) => TablesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TablesModel(id: $id, year: $year, day: $day, period: $period, studyMode: $studyMode, periodMap: $periodMap, courseCode: $courseCode, courseId: $courseId, lecturerName: $lecturerName, lecturerEmail: $lecturerEmail, courseTitle: $courseTitle, creditHours: $creditHours, specialVenues: $specialVenues, venueName: $venueName, venueId: $venueId, venueCapacity: $venueCapacity, disabilityAccess: $disabilityAccess, isSpecial: $isSpecial, classLevel: $classLevel, className: $className, department: $department, classSize: $classSize, hasDisable: $hasDisable, semester: $semester, classId: $classId, lecturerId: $lecturerId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TablesModel &&
      other.id == id &&
      other.year == year &&
      other.day == day &&
      other.period == period &&
      other.studyMode == studyMode &&
      mapEquals(other.periodMap, periodMap) &&
      other.courseCode == courseCode &&
      other.courseId == courseId &&
      other.lecturerName == lecturerName &&
      other.lecturerEmail == lecturerEmail &&
      other.courseTitle == courseTitle &&
      other.creditHours == creditHours &&
      listEquals(other.specialVenues, specialVenues) &&
      other.venueName == venueName &&
      other.venueId == venueId &&
      other.venueCapacity == venueCapacity &&
      other.disabilityAccess == disabilityAccess &&
      other.isSpecial == isSpecial &&
      other.classLevel == classLevel &&
      other.className == className &&
      other.department == department &&
      other.classSize == classSize &&
      other.hasDisable == hasDisable &&
      other.semester == semester &&
      other.classId == classId &&
      other.lecturerId == lecturerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      year.hashCode ^
      day.hashCode ^
      period.hashCode ^
      studyMode.hashCode ^
      periodMap.hashCode ^
      courseCode.hashCode ^
      courseId.hashCode ^
      lecturerName.hashCode ^
      lecturerEmail.hashCode ^
      courseTitle.hashCode ^
      creditHours.hashCode ^
      specialVenues.hashCode ^
      venueName.hashCode ^
      venueId.hashCode ^
      venueCapacity.hashCode ^
      disabilityAccess.hashCode ^
      isSpecial.hashCode ^
      classLevel.hashCode ^
      className.hashCode ^
      department.hashCode ^
      classSize.hashCode ^
      hasDisable.hashCode ^
      semester.hashCode ^
      classId.hashCode ^
      lecturerId.hashCode;
  }
}
