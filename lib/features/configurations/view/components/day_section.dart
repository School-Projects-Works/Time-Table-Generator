import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/constants/constant_data.dart';
import '../../../main/provider/main_provider.dart';
import '../../provider/config_provider.dart';

class DaySection extends ConsumerStatefulWidget {
  const DaySection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DaySectionState();
}

class _DaySectionState extends ConsumerState<DaySection> {

  @override
  Widget build(BuildContext context) {
       var currentConfig = ref.watch(configurationProvider);
    return Expanded(
        child: Card(
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Days'.toUpperCase(),
              style: FluentTheme.of(context).typography.subtitle,
            ),
            Text(
              'Check the days you want to schedule classes for this targeted Students (${ref.watch(studentTypeProvider)})',
              style: FluentTheme.of(context).typography.body,
            ),
            const SizedBox(height: 10),
            const Divider(
              style: DividerThemeData(
                thickness: 10,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: daysList
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Checkbox(
                              checked: currentConfig.days.contains(e),
                              content: Text(e),
                              onChanged: (value) {
                                if (value!) {
                                  ref
                                      .read(configurationProvider.notifier)
                                      .addDay(e);
                                } else {
                                  ref
                                      .read(configurationProvider.notifier)
                                      .removeDay(e);
                                }
                              }),
                        ))
                    .toList(),
              ),
            )
          ]),
    ));
 
 
  }
}