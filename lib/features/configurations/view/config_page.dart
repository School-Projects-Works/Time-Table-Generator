import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/configurations/view/components/liberal_section.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/config_provider.dart';
import 'components/day_section.dart';
import 'components/period_sections.dart';

class ConfigPage extends ConsumerStatefulWidget {
  const ConfigPage({super.key});
  @override
  ConsumerState<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends ConsumerState<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    var currentConfig = ref.watch(configurationProvider);
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
                            fontSize: 35, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    //check if configuration is loaded
                    if (currentConfig.days.isNotEmpty &&
                        currentConfig.periods
                            .where((element) => element['period'] != 'Break')
                            .toList()
                            .isNotEmpty &&
                        (currentConfig.periods
                            .where((element) =>
                                element['startTime'] == null ||
                                element['endTime'] == null)
                            .toList()
                            .isEmpty))
                      FilledButton(
                        onPressed: () {
                          CustomDialog.showInfo(
                              message:
                                  'Are you sure you want to save this configuration?',
                              buttonText: 'Yes',
                              onPressed: () {
                                ref
                                    .read(configurationProvider.notifier)
                                    .saveConfiguration(context, ref);
                               
                              });
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          child: Text('Save Configuration'),
                        ),
                      ),
                    const SizedBox(width: 10),
                    Button(
                        style: ButtonStyle(
                          shape: ButtonState.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(currentConfig.id != null
                            ? 'Delete Configurations'
                            : 'Clear Configurations'),
                        onPressed: () {
                          if (currentConfig.id != null) {
                            CustomDialog.showInfo(
                                message:
                                    'Are you sure you want to delete this configuration?',
                                buttonText: 'Yes',
                                onPressed: () {
                                  ref
                                      .read(configurationProvider.notifier)
                                      .deleteConfiguration(context, ref);
                                  CustomDialog.dismiss();
                                });
                          } else {
                            CustomDialog.showInfo(
                                message:
                                    'Are you sure you want to clear this configuration?',
                                buttonText: 'Yes',
                                onPressed: () {
                                  ref
                                      .read(configurationProvider.notifier)
                                      .clearConfig(context);
                                  CustomDialog.dismiss();
                                });
                          }
                        })
                  ],
                ),
              ),
              const Expanded(
                child: Row(
                  children: [
                    //?create a card for days
                    DaySection(),
                    //?create a card for periods
                    PeriodsSection(),
                    //?create a card for Liberal course settings
                    LiberalSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }, loading: () {
      return Container(
        color: Colors.grey.withOpacity(.1),
        child: const Center(
          child: ProgressRing(),
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
