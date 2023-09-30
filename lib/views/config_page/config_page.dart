import 'package:aamusted_timetable_generator/global/widgets/custom_dialog.dart';
import 'package:aamusted_timetable_generator/riverpod/configuration_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global/constants/constant_list.dart';
import '../../riverpod/academic_config.dart';
import '../../riverpod/period_time_provider.dart';

class ConfigPage extends ConsumerStatefulWidget {
  const ConfigPage({super.key});

  @override
  ConsumerState<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends ConsumerState<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    var currentConfig = ref.watch(configurationProvider);
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
                      style: FluentTheme.of(context).typography.title),
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
                        MyDialog(
                          context: context,
                          title: 'Confirm',
                          message:
                              'Are you sure you want to save this configuration?',
                          confirmButtonText: 'Yes',
                          otherButtonText: 'No',
                          confirmButtonPress: () {
                            ref
                                .read(configurationProvider.notifier)
                                .saveConfiguration(context);
                          },
                        ).confirmation();
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
                        border: ButtonState.all(
                          BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      child: Text(currentConfig.id != null
                          ? 'Delete Configurations'
                          : 'Clear Configurations'),
                      onPressed: () {
                        if (currentConfig.id != null) {
                          MyDialog(
                              context: context,
                              title: 'Confirm',
                              message:
                                  'Are you sure you want to delete this configuration?',
                              confirmButtonText: 'Yes',
                              otherButtonText: 'No',
                              confirmButtonPress: () {
                                ref
                                    .read(configurationProvider.notifier)
                                    .deleteConfiguration(context);
                              }).confirmation();
                        } else {
                          MyDialog(
                              context: context,
                              title: 'Confirm',
                              message:
                                  'Are you sure you want to clear this configuration?',
                              confirmButtonText: 'Yes',
                              otherButtonText: 'No',
                              confirmButtonPress: () {
                               ref
                              .read(configurationProvider.notifier)
                              .clearConfig(context);
                              }).confirmation();
                        }
                      })
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  //?create a card for days
                  _DaysCard(),
                  //?create a card for periods
                  _PeriodsCard(),
                  //?create a card for Liberal course settings
                  _LiberalCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _DaysCard() {
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

  Widget _LiberalCard() {
    var configs = ref.watch(configurationProvider);
    return Expanded(
      flex: 1,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Leberial Courses'.toUpperCase(),
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
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
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
                              style:
                                  FluentTheme.of(context).typography.bodyStrong,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: ComboBox(
                                  elevation: 10,
                                  value: configs.liberalLevel,
                                  onChanged: (value) {
                                    ref
                                        .read(configurationProvider.notifier)
                                        .setLiberalLevel(value);
                                  },
                                  placeholder: const Text('Select Level'),
                                  items: levelList
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
                              style:
                                  FluentTheme.of(context).typography.bodyStrong,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: ComboBox(
                                  elevation: 10,
                                  value: configs.liberalCourseDay,
                                  onChanged: (value) {
                                    ref
                                        .read(configurationProvider.notifier)
                                        .setLiberalDay(value);
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
                              style:
                                  FluentTheme.of(context).typography.bodyStrong,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: ComboBox(
                                  elevation: 10,
                                  value: configs.liberalCoursePeriod != null
                                      ? configs.liberalCoursePeriod!['period']
                                      : null,
                                  onChanged: (value) {
                                    ref
                                        .read(configurationProvider.notifier)
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
                      ],
                    );
                  }
                }),
              )
            ]),
      ),
    );
  }

  Widget _PeriodsCard() {
    var configs = ref.watch(configurationProvider);
    return Expanded(
      flex: 2,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Periods'.toUpperCase(),
                style: FluentTheme.of(context).typography.subtitle,
              ),
              Text(
                'Check the periods and set start and end time on which classes will be taken for this targeted Students:(${ref.watch(studentTypeProvider)})',
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
                    children: periodList
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          checked: configs.periods
                                              .where((element) =>
                                                  element['period'] == e)
                                              .isNotEmpty,
                                          content: Text(e),
                                          onChanged: (value) {
                                            //check which period is checked
                                            switch (e) {
                                              case 'Period 1':
                                                if (value!) {
                                                  ref
                                                      .read(
                                                          configurationProvider
                                                              .notifier)
                                                      .addPeriod(e);
                                                } else {
                                                  ref
                                                      .read(
                                                          configurationProvider
                                                              .notifier)
                                                      .removePeriod(e);
                                                }
                                                break;
                                              case 'Period 2':
                                                //check if period 1 is checked
                                                var list = configs.periods
                                                    .where((element) =>
                                                        element['period'] ==
                                                        'Period 1')
                                                    .toList();
                                                if (list.isNotEmpty &&
                                                    list[0]['startTime'] !=
                                                        null &&
                                                    list[0]['endTime'] !=
                                                        null) {
                                                  if (value!) {
                                                    ref
                                                        .read(
                                                            configurationProvider
                                                                .notifier)
                                                        .addPeriod(e);
                                                  } else {
                                                    ref
                                                        .read(
                                                            configurationProvider
                                                                .notifier)
                                                        .removePeriod(e);
                                                  }
                                                } else {
                                                  MyDialog(
                                                    context: context,
                                                    title: 'Error',
                                                    message:
                                                        'Please set up Period 1 before you proceed',
                                                  ).error();
                                                }
                                                break;
                                              case 'Period 3':
                                                //check if period 2 is checked
                                                var list = configs.periods
                                                    .where((element) =>
                                                        element['period'] ==
                                                        'Period 2')
                                                    .toList();
                                                if (list.isNotEmpty &&
                                                    list[0]['startTime'] !=
                                                        null &&
                                                    list[0]['endTime'] !=
                                                        null) {
                                                  if (value!) {
                                                    ref
                                                        .read(
                                                            configurationProvider
                                                                .notifier)
                                                        .addPeriod(e);
                                                  } else {
                                                    ref
                                                        .read(
                                                            configurationProvider
                                                                .notifier)
                                                        .removePeriod(e);
                                                  }
                                                } else {
                                                  MyDialog(
                                                    context: context,
                                                    title: 'Error',
                                                    message:
                                                        'Please set up Period 2 before you proceed',
                                                  ).error();
                                                }
                                                break;
                                              case 'Period 4':
                                                //check if period 3 is checked
                                                var list = configs.periods
                                                    .where((element) =>
                                                        element['period'] ==
                                                        'Period 3')
                                                    .toList();
                                                if (list.isNotEmpty &&
                                                    list[0]['startTime'] !=
                                                        null &&
                                                    list[0]['endTime'] !=
                                                        null) {
                                                  if (value!) {
                                                    ref
                                                        .read(
                                                            configurationProvider
                                                                .notifier)
                                                        .addPeriod(e);
                                                  } else {
                                                    ref
                                                        .read(
                                                            configurationProvider
                                                                .notifier)
                                                        .removePeriod(e);
                                                  }
                                                } else {
                                                  MyDialog(
                                                    context: context,
                                                    title: 'Error',
                                                    message:
                                                        'Please set up Period 3 before you proceed',
                                                  ).error();
                                                }
                                                break;
                                              case 'Break':
                                                //check if period 4 is checked
                                                if (value!) {
                                                  ref
                                                      .read(
                                                          configurationProvider
                                                              .notifier)
                                                      .addPeriod(e);
                                                } else {
                                                  ref
                                                      .read(
                                                          configurationProvider
                                                              .notifier)
                                                      .removePeriod(e);
                                                }
                                                break;
                                            }
                                          }),
                                      const SizedBox(width: 60),
                                      if (configs.periods
                                          .where((element) =>
                                              element['period'] == e)
                                          .isNotEmpty)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('Start Time'),
                                            ComboBox(
                                              value: () {
                                                var period = configs.periods
                                                    .where((element) =>
                                                        element['period'] == e)
                                                    .toList()[0];
                                                var startList = ref
                                                    .watch(e == 'Period 1'
                                                        ? periodOneStartProvider
                                                        : e == 'Period 2'
                                                            ? periodTwoStartProvider
                                                            : e == 'Period 3'
                                                                ? periodThreeStartProvider
                                                                : e ==
                                                                        'Period 4'
                                                                    ? periodFourStartProvider
                                                                    : breakStartProvider)
                                                    .where((element) =>
                                                        element ==
                                                        period['startTime'])
                                                    .toList();
                                                return startList.isNotEmpty
                                                    ? startList[0]
                                                    : null;
                                              }(),
                                              items: ref
                                                  .watch(e == 'Period 1'
                                                      ? periodOneStartProvider
                                                      : e == 'Period 2'
                                                          ? periodTwoStartProvider
                                                          : e == 'Period 3'
                                                              ? periodThreeStartProvider
                                                              : e == 'Period 4'
                                                                  ? periodFourStartProvider
                                                                  : breakStartProvider)
                                                  .map((e) => ComboBoxItem(
                                                        value: e,
                                                        child: Text(e),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                ref
                                                    .read(configurationProvider
                                                        .notifier)
                                                    .setPeriodStartTime(
                                                        e, value);
                                              },
                                            ),
                                          ],
                                        ),
                                      const SizedBox(width: 25),
                                      if (ref
                                          .watch(configurationProvider)
                                          .periods
                                          .where((element) =>
                                              element['period'] == e)
                                          .isNotEmpty)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('End Time'),
                                            ComboBox(
                                              value: () {
                                                var period = configs.periods
                                                    .where((element) =>
                                                        element['period'] == e)
                                                    .toList()[0];
                                                var startList = ref
                                                    .watch(e == 'Period 1'
                                                        ? periodOneEndProvider
                                                        : e == 'Period 2'
                                                            ? periodTwoEndProvider
                                                            : e == 'Period 3'
                                                                ? periodThreeEndProvider
                                                                : e ==
                                                                        'Period 4'
                                                                    ? periodFourEndProvider
                                                                    : breakEndProvider)
                                                    .where((element) =>
                                                        element ==
                                                        period['endTime'])
                                                    .toList();
                                                return startList.isNotEmpty
                                                    ? startList[0]
                                                    : null;
                                              }(),
                                              items: ref
                                                  .watch(e == 'Period 1'
                                                      ? periodOneEndProvider
                                                      : e == 'Period 2'
                                                          ? periodTwoEndProvider
                                                          : e == 'Period 3'
                                                              ? periodThreeEndProvider
                                                              : e == 'Period 4'
                                                                  ? periodFourEndProvider
                                                                  : breakEndProvider)
                                                  .map((e) => ComboBoxItem(
                                                        value: e,
                                                        child: Text(e),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                ref
                                                    .read(configurationProvider
                                                        .notifier)
                                                    .setPeriodEndTime(e, value);
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(
                                    style: DividerThemeData(
                                      thickness: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList()),
              )
            ]),
      ),
    );
  }
}
