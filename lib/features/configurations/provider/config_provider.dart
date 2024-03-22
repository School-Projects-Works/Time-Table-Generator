import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main/provider/main_provider.dart';
import '../data/config/config_model.dart';
import '../usecase/config_usecase.dart';
import '../view/components/evening/provider/evening_config_provider.dart';
import '../view/components/regular/provider/regular_config_provider.dart';

final configFutureProvider = FutureProvider<ConfigModel>((ref) async {
  String academicYear = ref.watch(academicYearProvider);
  String academicSemester = ref.watch(semesterProvider);
  var configs = await ConfigUsecase().getConfigurations();
  var config = configs
      .where((element) =>
          element.year == academicYear && element.semester == academicSemester)
      .toList();
  if (config.isNotEmpty) {
    var currentConfig = config[0];
    var regularConfig = currentConfig.regular;
    var eveningConfig = currentConfig.evening;
    ref.read(regularConfigProvider.notifier).mode(regularConfig);
    ref.read(eveningConfigProvider.notifier).mode(eveningConfig);
    ref.read(configurationProvider.notifier).setConfig(currentConfig);
    return currentConfig;
  } else {
    return ConfigModel(regular: {}, evening: {});
  }
});

final configurationProvider =
    StateNotifierProvider<ConfigurationNotifier, ConfigModel>((ref) {
  return ConfigurationNotifier();
});

class ConfigurationNotifier extends StateNotifier<ConfigModel> {
  ConfigurationNotifier() : super(ConfigModel(regular: {}, evening: {}));

  void saveConfiguration(BuildContext context, WidgetRef ref) async {
    try {
      CustomDialog.dismiss();
      CustomDialog.showLoading(message: 'Saving configuration..');
      state = state.copyWith(
        id: () => AppUtils.getId(),
        year: () => ref.watch(academicYearProvider),
        semester: () => ref.watch(semesterProvider),
      );
      var (success, _, message) =
          await ConfigUsecase().addConfigurations(state);
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

      var (success, _, message) =
          await ConfigUsecase().deleteConfigurations(state.id!);
      if (!success) {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message:
                message ?? 'An error occurred while deleting configuration');
      } else {
        ref.invalidate(configFutureProvider);
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
      evening: {},
    );
  }

  void setConfig(ConfigModel config) {
    state = config;
  }

  void studyMode(StudyModeModel regularConfig, StudyModeModel eveningConfig) {
    state = state.copyWith(
      regular: regularConfig.toMap(),
      evening: eveningConfig.toMap(),
    );
  }
}
