import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/configurations/view/components/evening/provider/evening_config_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/data/constants/constant_data.dart';
import '../provider/even_period_provider.dart';

class EveningPeriodsSection extends ConsumerStatefulWidget {
  const EveningPeriodsSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EveningPeriodsSectionState();
}

class _EveningPeriodsSectionState extends ConsumerState<EveningPeriodsSection> {
  @override
  Widget build(BuildContext context) {
    var configs = ref.watch(eveningConfigProvider);
    var configsNotifier = ref.read(eveningConfigProvider.notifier);
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Evening Periods'.toUpperCase(),
                style: FluentTheme.of(context).typography.subtitle,
              ),
              Text(
                'Check the periods and set start and end time on which classes will be taken for eveing students',
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
                                                  configsNotifier.addPeriod(e);
                                                } else {
                                                  configsNotifier
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
                                                    configsNotifier
                                                        .addPeriod(e);
                                                  } else {
                                                    configsNotifier
                                                        .removePeriod(e);
                                                  }
                                                } else {
                                                  CustomDialog.showError(
                                                      message:
                                                          'Please set up Period 1 before you proceed');
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
                                                    configsNotifier
                                                        .addPeriod(e);
                                                  } else {
                                                    configsNotifier
                                                        .removePeriod(e);
                                                  }
                                                } else {
                                                  CustomDialog.showError(
                                                      message:
                                                          'Please set up Period 2 before you proceed');
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
                                                    configsNotifier
                                                        .addPeriod(e);
                                                  } else {
                                                    configsNotifier
                                                        .removePeriod(e);
                                                  }
                                                } else {
                                                  CustomDialog.showError(
                                                      message:
                                                          'Please set up Period 3 before you proceed');
                                                }
                                                break;
                                              case 'Break':
                                                //check if period 4 is checked
                                                if (value!) {
                                                  configsNotifier.addPeriod(e);
                                                } else {
                                                  configsNotifier
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
                                                        ? evePeriodOneStartProvider
                                                        : e == 'Period 2'
                                                            ? evePeriodTwoStartProvider
                                                            : e == 'Period 3'
                                                                ? evePeriodThreeStartProvider
                                                                : e ==
                                                                        'Period 4'
                                                                    ? evePeriodFourStartProvider
                                                                    : eveBreakStartProvider)
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
                                                      ? evePeriodOneStartProvider
                                                      : e == 'Period 2'
                                                          ? evePeriodTwoStartProvider
                                                          : e == 'Period 3'
                                                              ? evePeriodThreeStartProvider
                                                              : e == 'Period 4'
                                                                  ? evePeriodFourStartProvider
                                                                  : eveBreakStartProvider)
                                                  .map((e) => ComboBoxItem(
                                                        value: e,
                                                        child: Text(e),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                configsNotifier
                                                    .setPeriodStartTime(
                                                        e, value);
                                              },
                                            ),
                                          ],
                                        ),
                                      const SizedBox(width: 25),
                                      if (ref
                                          .watch(eveningConfigProvider)
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
                                                        ? evePeriodOneEndProvider
                                                        : e == 'Period 2'
                                                            ? evePeriodTwoEndProvider
                                                            : e == 'Period 3'
                                                                ? evePeriodThreeEndProvider
                                                                : e ==
                                                                        'Period 4'
                                                                    ? evePeriodFourEndProvider
                                                                    : eveBreakEndProvider)
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
                                                      ? evePeriodOneEndProvider
                                                      : e == 'Period 2'
                                                          ? evePeriodTwoEndProvider
                                                          : e == 'Period 3'
                                                              ? evePeriodThreeEndProvider
                                                              : e == 'Period 4'
                                                                  ? evePeriodFourEndProvider
                                                                  : eveBreakEndProvider)
                                                  .map((e) => ComboBoxItem(
                                                        value: e,
                                                        child: Text(e),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                configsNotifier
                                                    .setPeriodEndTime(
                                                        e, value.toString());
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
