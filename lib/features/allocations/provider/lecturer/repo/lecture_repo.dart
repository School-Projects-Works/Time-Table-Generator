import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';

abstract class LectureRepo{
  Future<List<LecturerModel>> getLectures(String academicYear, String academicSemester, String targetedStudents);
  Future<bool> addLectures(List<LecturerModel> lecturers);
  //delete all lectures
  Future<bool> deleteAllLectures(String academicYear, String academicSemester,String targetedStudents,String department);
  Future<bool> deleteLecture(String id);
}