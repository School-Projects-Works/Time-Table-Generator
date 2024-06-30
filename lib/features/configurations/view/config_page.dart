import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/config_provider.dart';
import 'components/parts/day_section.dart';
import 'components/parts/liberal_section.dart';
import 'components/parts/period_sections.dart';

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
                    if (ref.watch(configProvider).periods.isNotEmpty)
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
                          var currentConfig = ref.watch(configProvider);

                          if ((currentConfig.days.isNotEmpty &&
                                  currentConfig.periods.isEmpty) ||
                              (currentConfig.periods.isNotEmpty &&
                                  currentConfig.days.isEmpty)) {
                            CustomDialog.showError(
                                message:
                                    'Regular configuration is not complete. Days or periods are missing');
                          } else {
                            //get regular periods with no start or end time
                            var regularPeriods = currentConfig.periods
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
                                        .read(configProvider.notifier)
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
                    const SizedBox(width: 10),
                    if (ref.watch(configProvider).id != null &&
                        ref.watch(configProvider).days.isNotEmpty&& ref.watch(configProvider).periods.isNotEmpty)
                      fluent.Button(
                          style: fluent.ButtonStyle(
                            backgroundColor: fluent.ButtonState.all(
                                Colors.red.withOpacity(.8)),
                            shape: fluent.ButtonState.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: fluent.Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Text(
                              'Delete Configurations',
                              style: getTextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            CustomDialog.showInfo(
                                message:
                                    'Are you sure you want to delete this configuration? This action cannot be undone',
                                buttonText: 'Yes',
                                onPressed: () {
                                  ref
                                      .read(configProvider.notifier)
                                      .deleteConfiguration(context, ref);
                                 
                                });
                          })
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
               Expanded(
                child: Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DaySection(),
                LiberalSection()
              ],
            ),
          ),
          PeriodsSection(),
        ],
      ),
    )
  ,
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
