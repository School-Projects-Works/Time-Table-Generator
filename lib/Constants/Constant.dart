// ignore_for_file: file_names

class Constant {
  static String courseCode = "Course Code";
  static String courseTitle = "Course Title";
  static String creditHours = "Credit Hours";
  static String lecturerName = "Lecturer Name";
  static String specialVenue =
      "Special Venue(Specify Venue,eg:Wood Lab,Computer Lab)";
  static String lecturerEmail = "Lecturer Email";
  static String department = "Department";

  static String level = "Level";
  static String className = "Class Name";
  static String classSize = "Class Size";
  static String hasDisability = "Has Disable(Yes/No)";
  static String courses = "Course (Course Code Only) [Separate with (,)]";
  static String type = "Type(Regular/Evening/Weekend)";

  static String roomName = "Room";
  static String capacity = "Capacity";
  static String disability = "Disability Friendly(Yes/No)";
  static String isSpecial = "Special/Lab (Yes/No)";

  static List<String> courseExcelHeaderOrder = [
    courseCode,
    courseTitle,
    creditHours,
    specialVenue,
    lecturerName,
    lecturerEmail,
    department
  ];

  static List<String> classExcelHeaderOrder = [
    level,
    type,
    className,
    classSize,
    hasDisability,
    courses,
    // department,
  ];

  static List<String> venueExcelHeaderOrder = [
    roomName,
    capacity,
    disability,
    isSpecial
  ];

  static List<String> liberalExcelHeaderOrder = [
    courseCode,
    courseTitle,
    lecturerName,
    lecturerEmail
  ];
}
