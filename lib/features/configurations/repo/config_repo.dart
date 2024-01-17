import '../data/config/config_model.dart';

abstract class ConfigRepo {
  Future<
      (
        bool,
        ConfigModel?,
        String?,
      )> addConfigurations(ConfigModel configurations);
  Future<List<ConfigModel>> getConfigurations();
  Future<
      (
        bool,
        ConfigModel?,
        String?,
      )> deleteConfigurations(String id);
  Future<
      (
        bool,
        ConfigModel?,
        String?,
      )> updateConfigurations(ConfigModel configurations);
}
