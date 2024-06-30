import 'package:aamusted_timetable_generator/core/data/constants/constant_data.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../provider/config_provider.dart';

class LiberalSection extends ConsumerStatefulWidget {
  const LiberalSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegularLiberalSectionState();
}

class _RegularLiberalSectionState extends ConsumerState<LiberalSection> {
  @override
  Widget build(BuildContext context) {
    var configs = ref.watch(configProvider);
    var configsNotifier = ref.read(configProvider.notifier);
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Regular/Evening Liberal Courses'.toUpperCase(),
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                  Text(
                    'Set day, period and level of students who will offer Liberal Courses if any',
                    style: FluentTheme.of(context).typography.body,
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    style: DividerThemeData(
                      thickness: 10,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(builder: (context, constraints) {
                    var periods = configs.periods
                        .where(
                          (element) => element['period'] != 'Break',
                        )
                        .toList();
                    var days = configs.days;
                    if (periods.isEmpty) {
                      return Center(
                          child: Text(
                        'Set up periods before you can make this settings',
                        style: FluentTheme.of(context).typography.bodyStrong,
                      ));
                    } else if (days.isEmpty) {
                      return Center(
                          child: Text(
                        'Set up days before you can make this settings',
                        style: FluentTheme.of(context).typography.bodyStrong,
                      ));
                    } else {
                      return Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Which Level of Students will offer Liberal Courses?',
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: ComboBox(
                                    elevation: 10,
                                    value: configs.regLibLevel,
                                    onChanged: (value) {
                                      configsNotifier.setRegLibLevel(value);
                                    },
                                    placeholder: const Text('Select Level'),
                                    items: levels
                                        .map((e) => ComboBoxItem(
                                              value: e,
                                              child: Text(e),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            style: DividerThemeData(
                              thickness: 10,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Which Day of the week will Liberal Courses be taken?',
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: ComboBox(
                                    elevation: 10,
                                    value: configs.regLibDay,
                                    onChanged: (value) {
                                      configsNotifier.setRegLibDay(value);
                                    },
                                    placeholder: const Text('Select Day'),
                                    items: configs.days
                                        .map((e) => ComboBoxItem(
                                              value: e,
                                              child: Text(e),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            style: DividerThemeData(
                              thickness: 10,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Which Period of the day will Liberal Courses be taken?',
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: ComboBox(
                                    elevation: 10,
                                    value: configs.regLibPeriod != null
                                        ? configs.regLibPeriod!['period']
                                        : null,
                                    onChanged: (value) {
                                      configsNotifier
                                          .setLiberalPeriod(value.toString());
                                    },
                                    placeholder: const Text('Select Period'),
                                    items: configs.periods
                                        .where((element) =>
                                            element['period'] != 'Break')
                                        .map((e) => ComboBoxItem(
                                              value: e['period'],
                                              child: Text(e['period']),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            style: DividerThemeData(
                              thickness: 10,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Which Level of Evening Students will offer Liberal Courses?',
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: ComboBox(
                                    elevation: 10,
                                    value: configs.evenLibLevel,
                                    onChanged: (value) {
                                      configsNotifier.setEvenLibLevel(value);
                                    },
                                    placeholder: const Text('Select Level'),
                                    items: levels
                                        .map((e) => ComboBoxItem(
                                              value: e,
                                              child: Text(e),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            style: DividerThemeData(
                              thickness: 10,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Which Day of the week will Evening Students have their Liberal Course?',
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: ComboBox(
                                    elevation: 10,
                                    value: configs.evenLibDay,
                                    onChanged: (value) {
                                      configsNotifier.setEvenLibDay(value);
                                    },
                                    placeholder: const Text('Select Day'),
                                    items: configs.days
                                        .map((e) => ComboBoxItem(
                                              value: e,
                                              child: Text(e),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  })
                ]),
          ),
        ),
      ),
    );
  }
}
