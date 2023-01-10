class Constant {
  static String courseCode = "Course Code";
  static String couseTitle = "Course Title";
  static String creaditHourse = "Credit Hours";
  static String lecturerName = "Lecturer Name";
  static String specialVenue = "Special Venue(Specify Venue)";
  static String lecturerPhone = "Lecturer Phone";
  static String lecturerEmail = "Lecturer Email";

  static String level = "Level";
  static String className = "Class Name";
  static String classSize = "Class Size";
  static String hasDisability = "Has Disable(Yes/No)";
  static String courses = "Course [Seperate with (,)]";
  static String type = "Type(Regular/Evening)";

  static String roomName = "Room";
  static String capacity = "Capacity";
  static String disbility = "Disability Frindly(Yes/No)";

  static List<String> courseExcelHeaderOrder = [
    courseCode,
    couseTitle,
    creaditHourse,
    specialVenue,
    lecturerName,
    lecturerEmail,
    lecturerPhone
  ];

  static List<String> classExcelHeaderOrder = [
    level,
    className,
    classSize,
    hasDisability,
    courses,
    type,
  ];

  static List<String> venueExcelHeaderOrder = [roomName, capacity, disbility];
}
