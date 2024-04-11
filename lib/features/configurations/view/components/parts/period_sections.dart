import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/configurations/view/components/provider/config_period_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/data/constants/constant_data.dart';
import '../../../provider/config_provider.dart';

class PeriodsSection extends ConsumerStatefulWidget {
  const PeriodsSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegularPeriodsSectionState();
}

class _RegularPeriodsSectionState extends ConsumerState<PeriodsSection> {
  @override
  Widget build(BuildContext context) {
    var configPeriods = ref.watch(configProvider).periods.map((e) => PeriodModel.fromMap(e)).toList();
    var configPeriodsNotifier = ref.read(configProvider.notifier);
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    offset: const Offset(0, 2),
                    blurRadius: 3)
              ]),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Periods Setup'.toUpperCase(),
                  style: fluent.FluentTheme.of(context).typography.subtitle,
                ),
                Text(
                  'Check the periods and set start and end time on which classes will be taken for regular students',
                  style: fluent.FluentTheme.of(context).typography.body,
                ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 10,
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: ListView(children: [
                  for (int i = 0; i < periodList.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              fluent.Checkbox(
                                  checked: configPeriods
                                      .where((element) =>
                                          element.period == periodList[i])
                                      .isNotEmpty,
                                  content: Text(periodList[i]),
                                  onChanged: (value) {
                                    //check which period is checked
                                    switch (periodList[i]) {
                                      case 'Period 1':
                                        if (value!) {
                                          configPeriodsNotifier.addPeriod(
                                              name: periodList[i], position: i);
                                        } else {
                                          configPeriodsNotifier
                                              .removePeriod(periodList[i]);
                                        }
                                        break;
                                      case 'Period 2':
                                        //check if period 1 is checked
                                        if (value!) {
                                          var list = configPeriods
                                              .where((element) =>
                                                  element.period == 'Period 1')
                                              .toList();
                                          if (list.isNotEmpty &&
                                              list[0].startTime.isNotEmpty &&
                                              list[0].endTime.isNotEmpty) {
                                            configPeriodsNotifier.addPeriod(
                                                name: periodList[i],
                                                position: i);
                                          } else {
                                            CustomDialog.showError(
                                                message:
                                                    'Please set up Period 1 before you proceed');
                                          }
                                        } else {
                                          configPeriodsNotifier
                                              .removePeriod(periodList[i]);
                                        }
                                        break;
                                      case 'Period 3':
                                        //check if period 2 is checked
                                        if (value!) {
                                          var list = configPeriods
                                              .where((element) =>
                                                  element.period == 'Period 2')
                                              .toList();
                                          if (list.isNotEmpty &&
                                              list[0].startTime.isNotEmpty &&
                                              list[0].endTime.isNotEmpty) {
                                            configPeriodsNotifier.addPeriod(
                                                name: periodList[i],
                                                position: i);
                                          } else {
                                            CustomDialog.showError(
                                                message:
                                                    'Please set up Period 2 before you proceed');
                                          }
                                        } else {
                                          configPeriodsNotifier
                                              .removePeriod(periodList[i]);
                                        }
                                        break;
                                      case 'Period 4':
                                        //check if period 3 is checked
                                        if (value!) {
                                          var list = configPeriods
                                              .where((element) =>
                                                  element.period == 'Period 3')
                                              .toList();
                                          if (list.isNotEmpty &&
                                              list[0].startTime.isNotEmpty &&
                                              list[0].endTime.isNotEmpty) {
                                            configPeriodsNotifier.addPeriod(
                                                name: periodList[i],
                                                position: i);
                                          } else {
                                            CustomDialog.showError(
                                                message:
                                                    'Please set up Period 3 before you proceed');
                                          }
                                        } else {
                                          configPeriodsNotifier
                                              .removePeriod(periodList[i]);
                                        }
                                        break;
                                      case 'Period 5':
                                        //check if period 2 is checked
                                        if (value!) {
                                          var list = configPeriods
                                              .where((element) =>
                                                  element.period == 'Period 4')
                                              .toList();
                                          if (list.isNotEmpty &&
                                              list[0].startTime.isNotEmpty &&
                                              list[0].endTime.isNotEmpty) {
                                            configPeriodsNotifier.addPeriod(
                                                name: periodList[i],
                                                position: i);
                                          } else {
                                            CustomDialog.showError(
                                                message:
                                                    'Please set up Period 4 before you proceed');
                                          }
                                        } else {
                                          configPeriodsNotifier
                                              .removePeriod(periodList[i]);
                                        }
                                        break;
                                    }
                                  }),
                              const SizedBox(width: 40),
                              if (configPeriods
                                  .where((element) =>
                                      element.period == periodList[i])
                                  .isNotEmpty)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Start Time'),
                                    fluent.ComboBox(
                                      value: () {
                                        var period = configPeriods
                                            .where((element) =>
                                                element.period == periodList[i])
                                            .toList()[0];
                                        var startList = ref
                                            .watch(periodList[i] == 'Period 1'
                                                ? periodOneStartTimeProvider
                                                : periodList[i] == 'Period 2'
                                                    ? periodTwoStartTimeProvider
                                                    : periodList[i] ==
                                                            'Period 3'
                                                        ? periodThreeStartTimeProvider
                                                        : periodList[i] ==
                                                                'Period 4'
                                                            ? periodFourStartTimeProvider
                                                            : periodFiveStartTimeProvider)
                                            .where((element) =>
                                                element == period.startTime)
                                            .toList();
                                        return startList.isNotEmpty
                                            ? startList[0]
                                            : null;
                                      }(),
                                      items: ref
                                          .watch(periodList[i] == 'Period 1'
                                              ? periodOneStartTimeProvider
                                              : periodList[i] == 'Period 2'
                                                  ? periodTwoStartTimeProvider
                                                  : periodList[i] == 'Period 3'
                                                      ? periodThreeStartTimeProvider
                                                      : periodList[i] ==
                                                              'Period 4'
                                                          ? periodFourStartTimeProvider
                                                          : periodFiveStartTimeProvider)
                                          .map((e) => fluent.ComboBoxItem(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        configPeriodsNotifier
                                            .setPeriodStartTime(
                                                period: periodList[i],
                                                startTime: value!);
                                      },
                                    ),
                                  ],
                                ),
                              const SizedBox(width: 25),
                              if (configPeriods
                                  .where((element) =>
                                      element.period == periodList[i])
                                  .isNotEmpty)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('End Time'),
                                    fluent.ComboBox(
                                      value: () {
                                        var period = configPeriods
                                            .where((element) =>
                                                element.period == periodList[i])
                                            .toList()[0];
                                        var startList = ref
                                            .watch(periodList[i] == 'Period 1'
                                                ? periodOneEndTimeProvider
                                                : periodList[i] == 'Period 2'
                                                    ? periodTwoEndTimeProvider
                                                    : periodList[i] ==
                                                            'Period 3'
                                                        ? periodThreeEndTimeProvider
                                                        : periodList[i] ==
                                                                'Period 4'
                                                            ? periodFourEndTimeProvider
                                                            : periodFiveEndTimeProvider)
                                            .where((element) =>
                                                element == period.endTime)
                                            .toList();
                                        return startList.isNotEmpty
                                            ? startList[0]
                                            : null;
                                      }(),
                                      items: ref
                                          .watch(periodList[i] == 'Period 1'
                                              ? periodOneStartTimeProvider
                                              : periodList[i] == 'Period 2'
                                                  ? periodTwoStartTimeProvider
                                                  : periodList[i] == 'Period 3'
                                                      ? periodThreeStartTimeProvider
                                                      : periodList[i] ==
                                                              'Period 4'
                                                          ? periodFourStartTimeProvider
                                                          : periodFiveStartTimeProvider)
                                          .map((e) => fluent.ComboBoxItem(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        configPeriodsNotifier.setPeriodEndTime(
                                            period: periodList[i],
                                            endTime: value!);
                                      },
                                    ),
                                  ],
                                ),
                              const SizedBox(width: 15),
                              if (configPeriods
                                  .where((element) =>
                                      element.period == periodList[i])
                                  .isNotEmpty)
                                fluent.Checkbox(
                                  content: Text('Is Break?',
                                      style: fluent.FluentTheme.of(context)
                                          .typography
                                          .body),
                                  checked:ref.watch(configProvider).breakTime!=null? ref.watch(configProvider).breakTime!['period'] ==
                                      periodList[i]:false,
                                  onChanged: (value) {
                                    configPeriodsNotifier.setPeriodAsBreak(
                                        isBreak: value!,
                                        ref: ref,
                                        name: periodList[i]);                                   
                                  },
                                )
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            thickness: 10,
                          ),
                        ],
                      ),
                    )
                ])),
              ]),
        ),
      ),
    );
  }
}
