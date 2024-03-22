import 'package:aamusted_timetable_generator/core/data/constants/constant_data.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/evening_config_provider.dart';

class EveningDaySection extends ConsumerStatefulWidget {
  const EveningDaySection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EveningDaySectionState();
}

class _EveningDaySectionState extends ConsumerState<EveningDaySection> {
  @override
  Widget build(BuildContext context) {
    var currentEveningConfig = ref.watch(eveningConfigProvider);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Evening Days'.toUpperCase(),
              style: FluentTheme.of(context).typography.subtitle,
            ),
            Text(
              'Check the days you want to schedule classes for evening students',
              style: FluentTheme.of(context).typography.body,
            ),
            const SizedBox(height: 10),
            const Divider(
              style: DividerThemeData(
                thickness: 10,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runAlignment: WrapAlignment.start,
              runSpacing: 20,
              children: daysList
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Checkbox(
                            checked: currentEveningConfig.days.contains(e),
                            content: Text(e),
                            onChanged: (value) {
                              if (value!) {
                                ref
                                    .read(eveningConfigProvider.notifier)
                                    .addDay(e);
                              } else {
                                ref
                                    .read(eveningConfigProvider.notifier)
                                    .removeDay(e);
                              }
                            }),
                      ))
                  .toList(),
            ),
          ]),
    );
  }
}
