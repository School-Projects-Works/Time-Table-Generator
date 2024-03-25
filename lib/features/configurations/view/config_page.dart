import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/configurations/view/components/regular/provider/regular_config_provider.dart';
import 'package:aamusted_timetable_generator/features/configurations/view/components/regular/regular_section.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/config_provider.dart';

class ConfigPage extends ConsumerStatefulWidget {
  const ConfigPage({super.key});
  @override
  ConsumerState<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends ConsumerState<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    var config = ref.watch(configFutureProvider);
    return config.when(data: (data) {
      return Container(
        color: Colors.grey.withOpacity(.1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text('Configurations'.toUpperCase(),
                        style: getTextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    //check if configuration is loaded
                    if (ref.watch(regularConfigProvider).periods.isNotEmpty)
                      FilledButton(
                        style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            backgroundColor: primaryColor),
                        onPressed: () {
                          var regularConfig = ref.watch(regularConfigProvider);

                          if ((regularConfig.days.isNotEmpty &&
                                  regularConfig.periods.isEmpty) ||
                              (regularConfig.periods.isNotEmpty &&
                                  regularConfig.days.isEmpty)) {
                            CustomDialog.showError(
                                message:
                                    'Regular configuration is not complete. Days or periods are missing');
                          } else {
                            //get regular periods with no start or end time
                            var regularPeriods = regularConfig.periods
                                .where((element) =>
                                    element['startTime'] == null ||
                                    element['endTime'] == null)
                                .toList();
                            //get evening periods with no start or end time

                            if (regularPeriods.isNotEmpty) {
                              CustomDialog.showError(
                                  message:
                                      'Regular configuration is not complete. Some periods have no start or end time');
                            } else {
                              CustomDialog.showInfo(
                                  message:
                                      'Are you sure you want to save this configuration?',
                                  buttonText: 'Yes',
                                  onPressed: () {
                                    ref
                                        .read(configurationProvider.notifier)
                                        .studyMode(regularConfig);

                                    ref
                                        .read(configurationProvider.notifier)
                                        .saveConfiguration(context, ref);
                                  });
                            }
                          }
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          child: Text('Save Configuration'),
                        ),
                      ),
                    // const SizedBox(width: 10),
                    // fluent.Button(
                    //     style: fluent.ButtonStyle(
                    //       backgroundColor: fluent.ButtonState.all(
                    //           Colors.red.withOpacity(.8)),
                    //       shape: fluent.ButtonState.all(
                    //         RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //       ),
                    //     ),
                    //     child: fluent.Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 8, horizontal: 10),
                    //       child: Text(
                    //         currentConfig.id != null
                    //             ? 'Delete Configurations'
                    //             : 'Clear Configurations',
                    //         style: getTextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //     onPressed: () {
                    //       if (currentConfig.id != null) {
                    //         CustomDialog.showInfo(
                    //             message:
                    //                 'Are you sure you want to delete this configuration?',
                    //             buttonText: 'Yes',
                    //             onPressed: () {
                    //               ref
                    //                   .read(configurationProvider.notifier)
                    //                   .deleteConfiguration(context, ref);
                    //               CustomDialog.dismiss();
                    //             });
                    //       } else {
                    //         CustomDialog.showInfo(
                    //             message:
                    //                 'Are you sure you want to clear this configuration?',
                    //             buttonText: 'Yes',
                    //             onPressed: () {
                    //               ref
                    //                   .read(configurationProvider.notifier)
                    //                   .clearConfig(context);
                    //               CustomDialog.dismiss();
                    //             });
                    //       }
                    //     })
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Expanded(
                child: RegularConfigSection(),
              )
            ],
          ),
        ),
      );
    }, loading: () {
      return Container(
        color: Colors.grey.withOpacity(.1),
        child: const Center(
          child: fluent.ProgressRing(),
        ),
      );
    }, error: (e, s) {
      return Container(
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(.1),
        child: const Center(
          child: Text('Error loading configurations'),
        ),
      );
    });
  }
}



