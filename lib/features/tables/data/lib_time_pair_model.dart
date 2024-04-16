import 'dart:convert';

class LibTimePairModel {
  String id;
  String day;
  bool isAsigned;
  String period;
  int periodPosition;
  String periodStart;
  String periodEnd;
  String courseCode;
  String lecturerName;
  String lecturerId;
  String courseTitle;
  String courseId;
  String year;
  String level;
  String studyMode;
  String semester;
  LibTimePairModel({
    required this.id,
    required this.day,
    required this.isAsigned,
    required this.period,
    required this.periodPosition,
    required this.periodStart,
    required this.periodEnd,
    required this.courseCode,
    required this.lecturerName,
    required this.lecturerId,
    required this.courseTitle,
    required this.courseId,
    required this.year,
    required this.level,
    required this.studyMode,
    required this.semester,
  });

  LibTimePairModel copyWith({
    String? id,
    String? day,
    bool? isAsigned,
    String? period,
    int? periodPosition,
    String? periodStart,
    String? periodEnd,
    String? courseCode,
    String? lecturerName,
    String? lecturerId,
    String? courseTitle,
    String? courseId,
    String? year,
    String? level,
    String? studyMode,
    String? semester,
  }) {
    return LibTimePairModel(
      id: id ?? this.id,
      day: day ?? this.day,
      isAsigned: isAsigned ?? this.isAsigned,
      period: period ?? this.period,
      periodPosition: periodPosition ?? this.periodPosition,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      courseCode: courseCode ?? this.courseCode,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturerId: lecturerId ?? this.lecturerId,
      courseTitle: courseTitle ?? this.courseTitle,
      courseId: courseId ?? this.courseId,
      year: year ?? this.year,
      level: level ?? this.level,
      studyMode: studyMode ?? this.studyMode,
      semester: semester ?? this.semester,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'isAsigned': isAsigned,
      'period': period,
      'periodPosition': periodPosition,
      'periodStart': periodStart,
      'periodEnd': periodEnd,
      'courseCode': courseCode,
      'lecturerName': lecturerName,
      'lecturerId': lecturerId,
      'courseTitle': courseTitle,
      'courseId': courseId,
      'year': year,
      'level': level,
      'studyMode': studyMode,
      'semester': semester,
    };
  }

  factory LibTimePairModel.fromMap(Map<String, dynamic> map) {
    return LibTimePairModel(
      id: map['id'] ?? '',
      day: map['day'] ?? '',
      isAsigned: map['isAsigned'] ?? false,
      period: map['period'] ?? '',
      periodPosition: map['periodPosition']?.toInt() ?? 0,
      periodStart: map['periodStart'] ?? '',
      periodEnd: map['periodEnd'] ?? '',
      courseCode: map['courseCode'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      courseTitle: map['courseTitle'] ?? '',
      courseId: map['courseId'] ?? '',
      year: map['year'] ?? '',
      level: map['level'] ?? '',
      studyMode: map['studyMode'] ?? '',
      semester: map['semester'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LibTimePairModel.fromJson(String source) => LibTimePairModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LibTimePairModel(id: $id, day: $day, isAsigned: $isAsigned, period: $period, periodPosition: $periodPosition, periodStart: $periodStart, periodEnd: $periodEnd, courseCode: $courseCode, lecturerName: $lecturerName, lecturerId: $lecturerId, courseTitle: $courseTitle, courseId: $courseId, year: $year, level: $level, studyMode: $studyMode, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LibTimePairModel &&
      other.id == id &&
      other.day == day &&
      other.isAsigned == isAsigned &&
      other.period == period &&
      other.periodPosition == periodPosition &&
      other.periodStart == periodStart &&
      other.periodEnd == periodEnd &&
      other.courseCode == courseCode &&
      other.lecturerName == lecturerName &&
      other.lecturerId == lecturerId &&
      other.courseTitle == courseTitle &&
      other.courseId == courseId &&
      other.year == year &&
      other.level == level &&
      other.studyMode == studyMode &&
      other.semester == semester;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      day.hashCode ^
      isAsigned.hashCode ^
      period.hashCode ^
      periodPosition.hashCode ^
      periodStart.hashCode ^
      periodEnd.hashCode ^
      courseCode.hashCode ^
      lecturerName.hashCode ^
      lecturerId.hashCode ^
      courseTitle.hashCode ^
      courseId.hashCode ^
      year.hashCode ^
      level.hashCode ^
      studyMode.hashCode ^
      semester.hashCode;
  }
}
