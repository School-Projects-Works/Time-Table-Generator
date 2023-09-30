
import 'package:aamusted_timetable_generator/data/models/configs/configuration_model.dart';

abstract class  DatabaseRepo {
  Future<void> init();
}
abstract class ConfigRepo{
void addConfigurations(ConfigurationModel configurations);
  Future<ConfigurationModel?> getConfigurations(String academicYear, String academicSemester, String targetedStudents);
  void deleteConfigurations(String academicYear, String academicSemester, String targetedStudents);
  void updateConfigurations(ConfigurationModel configurations);
}