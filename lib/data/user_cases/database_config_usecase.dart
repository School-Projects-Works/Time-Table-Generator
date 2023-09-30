import 'package:aamusted_timetable_generator/data/models/configs/configuration_model.dart';
import 'package:aamusted_timetable_generator/data/repos/database_repo.dart';
import 'package:hive/hive.dart';

class ConfigUsecase extends ConfigRepo {
  @override
  Future<void> addConfigurations(ConfigurationModel configurations) async {
    // open box
    await Hive.openBox<ConfigurationModel>('configurations');
    // add configurations
    final box = Hive.box<ConfigurationModel>('configurations');
    box.put(configurations.id, configurations);
    // close box
    await Hive.close();
  }

  @override
  Future<void> deleteConfigurations(String academicYear, String academicSemester,
      String targetedStudents) async {
    // open box
    await Hive.openBox<ConfigurationModel>('configurations');
    //delete configurations where academicYear, academicSemester and targetedStudents are equal
    final box = Hive.box<ConfigurationModel>('configurations');
    var list =box.values.where((element) {
      return element.academicYear == academicYear &&
          element.academicSemester == academicSemester &&
          element.targetedStudents == targetedStudents;
    }).toList();
    if(list.isNotEmpty){
      //delete all configurations
      for(var i =0; i<list.length; i++){
        box.delete(list[i].id);
      }
    }
    // close box
    await Hive.close();
  }

  @override
  Future<ConfigurationModel?> getConfigurations(String academicYear,
      String academicSemester, String targetedStudents) async {
    // open box
    await Hive.openBox<ConfigurationModel>('configurations');
    // get configurations
    final box = Hive.box<ConfigurationModel>('configurations');
    var list =box.values.where((element) {
      return element.academicYear == academicYear &&
          element.academicSemester == academicSemester &&
          element.targetedStudents == targetedStudents;
    }).toList();
    if(list.isNotEmpty){
      return list[0];
    }else{
      return null;
    }
  }

  @override
  void updateConfigurations(ConfigurationModel configurations) {
    // TODO: implement updateConfigurations
  }
}
