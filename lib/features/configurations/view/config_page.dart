import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/configurations/view/components/evening/evening_section.dart';
import 'package:aamusted_timetable_generator/features/configurations/view/components/evening/provider/evening_config_provider.dart';
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
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    //check if configuration is loaded
                    if (ref.watch(regularConfigProvider).periods.isNotEmpty ||
                        (ref.watch(eveningConfigProvider).periods.isNotEmpty))
                      FilledButton(
                        onPressed: () {
                          CustomDialog.showInfo(
                              message:
                                  'Are you sure you want to save this configuration?',
                              buttonText: 'Yes',
                              onPressed: () {
                                var regularConfig =
                                    ref.watch(regularConfigProvider);
                                var eveningConfig =
                                    ref.watch(eveningConfigProvider);
                                ref
                                    .read(configurationProvider.notifier)
                                    .studyMode(regularConfig, eveningConfig);

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
                    fluent.Button(
                        style: fluent.ButtonStyle(
                          shape: fluent.ButtonState.all(
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
              const SizedBox(
                height: 10,
              ),
              Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TabItem(
                        isActive: ref.watch(tabProvider) == 0,
                        text: 'Regular Setup',
                        onPress: () {
                          ref.read(tabProvider.notifier).state = 0;
                        },
                      ),
                      TabItem(
                        isActive: ref.watch(tabProvider) == 1,
                        text: 'Evening Setup',
                        onPress: () {
                          ref.read(tabProvider.notifier).state = 1;
                        },
                      ),
                    ],
                  )),
              const SizedBox(height: 5),
              if (ref.watch(tabProvider) == 0)
                const Expanded(
                  child: RegularConfigSection(),
                )
              else
                const Expanded(
                  child: EveningConfigSection(),
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

final tabProvider = StateProvider<int>((ref) => 0);

class TabItem extends StatefulWidget {
  const TabItem(
      {super.key,
      required this.text,
      required this.onPress,
      required this.isActive});
  final String text;
  final VoidCallback onPress;
  final bool isActive;

  @override
  State<TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {
        setState(() {
          _isHovered = value;
        });
      },
      onTap: widget.onPress,
      child: Container(
        color: _isHovered
            ? primaryColor.withOpacity(.5)
            : widget.isActive
                ? primaryColor
                : Colors.white24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(widget.text,
            style: getTextStyle(
                fontSize: 20,
                fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w300,
                color: widget.isActive ? Colors.white : Colors.black)),
      ),
    );
  }
}
