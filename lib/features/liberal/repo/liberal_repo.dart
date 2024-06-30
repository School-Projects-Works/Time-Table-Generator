import 'package:aamusted_timetable_generator/features/liberal/data/liberal/liberal_model.dart';

abstract class LiberalRepo {
  Future<(bool, String, List<LiberalModel>?)> importLiberal(
      {required String path,
      required String academicYear,
      required String semester});
  Future<(bool, String?)> downloadTemplate();
  Future<(bool, String)> addLiberals(List<LiberalModel> liberals);
  Future<(bool, String, LiberalModel?)> deleteLiberal(String id);
  Future<(bool, String)> deleteLiberals(
      {required String academicYear, required String semester});
  Future<(bool, String, LiberalModel?)> updateLiberal(LiberalModel venue);
  Future<List<LiberalModel>> getLiberals(
      {required String year, required String sem});
}
