class ClassCoursePairModel {
  String? id;

  String? courseTitle;

  String? creditHours;

  String? specialVenue;

  String? lecturerName;

  String? lecturerEmail;

  String? department;

  String? courseId;

  String? academicYear;

  List<String>? venues;

  String? courseCode;

  String? classId;

  String? classLevel;

  String? targetStudents;

  String? className;

  String? classSize;

  String? classHasDisability;

  List? classCourses;

  bool isAssigned;

  ClassCoursePairModel({
    this.id,
    this.courseTitle,
    this.creditHours,
    this.specialVenue,
    this.lecturerName,
    this.lecturerEmail,
    this.department,
    this.courseId,
    this.academicYear,
    this.venues,
    this.courseCode,
    this.classId,
    this.classLevel,
    this.targetStudents,
    this.className,
    this.classSize,
    this.classHasDisability,
    this.classCourses,
    this.isAssigned = false,
  });
}
