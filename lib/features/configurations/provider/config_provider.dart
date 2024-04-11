import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/database/provider/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main/provider/main_provider.dart';
import '../data/config/config_model.dart';
import '../usecase/config_usecase.dart';
import '../view/components/regular/provider/regular_config_provider.dart';

final configFutureProvider = FutureProvider<ConfigModel>((ref) async {
  String academicYear = ref.watch(academicYearProvider);
  String academicSemester = ref.watch(semesterProvider);
  var id = '$academicYear-$academicSemester'
      .trim()
      .replaceAll(' ', '')
      .toLowerCase()
      .replaceAll('/', '-');
  var configs = await ConfigUsecase(db: ref.watch(dbProvider)).getConfigurations();
  var config = configs
      .where((element) =>element.id == id&&
          element.year == academicYear && element.semester == academicSemester)
      .toList();
  if (config.isNotEmpty) {
    var currentConfig = config[0];
    var regularConfig = currentConfig.regular;
    ref.read(regularConfigProvider.notifier).mode(regularConfig);
    ref.read(configurationProvider.notifier).setConfig(currentConfig);
    return currentConfig;
  } else {
    ref.read(regularConfigProvider.notifier).mode({});
    ref
        .read(configurationProvider.notifier)
        .setConfig(ConfigModel(regular: {}));
    return ConfigModel(regular: {});
  }
});

final configurationProvider =
    StateNotifierProvider<ConfigurationNotifier, ConfigModel>((ref) {
  return ConfigurationNotifier();
});

class ConfigurationNotifier extends StateNotifier<ConfigModel> {
  ConfigurationNotifier() : super(ConfigModel(regular: {},));

  void saveConfiguration(BuildContext context, WidgetRef ref) async {
    try {
      CustomDialog.dismiss();
      CustomDialog.showLoading(message: 'Saving configuration..');
      var year = ref.watch(academicYearProvider);
      var semester = ref.watch(semesterProvider);
      var id = '$year-$semester'
          .trim()
          .replaceAll(' ', '')
          .toLowerCase()
          .replaceAll('/', '-');
      state = state.copyWith(
        id: () => id,
        year: () => year,
        semester: () => semester,
      );
      var (success, _, message) =
          await ConfigUsecase(db: ref.watch(dbProvider)).addConfigurations(state);
      if (success) {
        ref.invalidate(configFutureProvider);
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: message ?? 'Configuration saved successfully');
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: message ?? 'An error occurred');
      }
    } catch (error) {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'An error occurred');
    }
  }

  void deleteConfiguration(BuildContext context, WidgetRef ref) async {
    try {
      CustomDialog.dismiss();
      CustomDialog.showLoading(message: 'Deleting configuration..');
      var existingConfig = ref.watch(configurationProvider);
      var (success, _, message) =
          await ConfigUsecase(db:ref.watch(dbProvider)).deleteConfigurations(existingConfig.id!);
      if (!success) {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message:
                message ?? 'An error occurred while deleting configuration');
      } else {
        ref.invalidate(configFutureProvider);
        state = ConfigModel(regular: {});
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: message ?? 'Configuration deleted successfully');
      }
    } catch (error) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          message: 'An error occurred while deleting configuration');
    }
  }

  void clearConfig(BuildContext context) {
    state = ConfigModel(
      regular: {},
    );
  }

  void setConfig(ConfigModel config) {
    state = config;
  }

  void studyMode(StudyModeModel? regularConfig) {
  
    state = state.copyWith(
      regular: regularConfig != null && regularConfig.days.isNotEmpty
          ? regularConfig.toMap()
          : {},
    );
  }
}
