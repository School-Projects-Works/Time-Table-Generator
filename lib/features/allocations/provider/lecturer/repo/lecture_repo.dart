import 'package:aamusted_timetable_generator/features/allocations/data/lecturers/lecturer_model.dart';

abstract class LectureRepo{
  Future<List<LecturerModel>> getLectures(String year, String semester);
  Future<List<LecturerModel>> addLectures(List<LecturerModel> lecturers);
}