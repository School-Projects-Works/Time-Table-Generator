import 'package:aamusted_timetable_generator/features/configurations/provider/config_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/data/constants/constant_data.dart';

class DaySection extends ConsumerStatefulWidget {
  const DaySection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegularDaySectionState();
}

class _RegularDaySectionState extends ConsumerState<DaySection> {
  @override
  Widget build(BuildContext context) {
    var currentConfig = ref.watch(configProvider);
    var currentConfigNotifier = ref.read(configProvider.notifier);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Days Setup'.toUpperCase(),
              style: FluentTheme.of(context).typography.subtitle,
            ),
            Text(
              'Check the days you want to schedule classes for regular students',
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
                            checked: currentConfig.days.contains(e),
                            content: Text(e),
                            onChanged: (value) {
                              if (value!) {
                                currentConfigNotifier.addDay(e);
                              } else {
                                currentConfigNotifier.removeDay(e);
                              }
                            }),
                      ))
                  .toList(),
            ),
          ]),
    );
  }
}
