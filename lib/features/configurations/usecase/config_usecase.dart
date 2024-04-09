import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/repo/config_repo.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfigUsecase extends ConfigRepo {
  @override
  Future<(bool, ConfigModel?, String?)> addConfigurations(
      ConfigModel configurations) async {
    try {
      await Hive.openBox<ConfigModel>('config');
      final box = Hive.box<ConfigModel>('config');
      box.put(configurations.id, configurations);
      return Future.value(
          (true, configurations, 'Configurations added successfully'));
    } catch (e) {
      //print(e);
      return Future.value((false, null, e.toString()));
    }
  }

  @override
  Future<(bool, ConfigModel?, String?)> deleteConfigurations(String id) async {
    try {
      await Hive.openBox<ConfigModel>('config');
      final box = Hive.box<ConfigModel>('config');
      await box.delete(id);
      return Future.value((true, null, 'Configurations deleted successfully'));
    } catch (e) {
      //print(e);
      return Future.value((false, null, e.toString()));
    }
  }

  @override
  Future<List<ConfigModel>> getConfigurations() async {
    try {
      await Hive.openBox<ConfigModel>('config');
      final box = Hive.box<ConfigModel>('config');
      //open box
      //  box.open();
      List<ConfigModel> config = box.values.toList();
      return Future.value(config);
    } catch (e) {
      //print(e);
      return Future.value([]);
    }
  }

  @override
  Future<(bool, ConfigModel?, String?)> updateConfigurations(
      ConfigModel configurations) {
    try {
      Hive.openBox<ConfigModel>('config');
      final box = Hive.box<ConfigModel>('config');
      box.put(configurations.id, configurations);
      return Future.value(
          (true, configurations, 'Configurations updated successfully'));
    } catch (e) {
      //print(e);
      return Future.value((false, null, e.toString()));
    }
  }
}
