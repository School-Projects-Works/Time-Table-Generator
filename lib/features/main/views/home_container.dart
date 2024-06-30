import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/main/views/components/window_buttons.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import '../../../core/data/constants/constant_data.dart';
import '../../database/provider/database_provider.dart';
import '../provider/main_provider.dart';
import 'components/side_bar.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({
    super.key,
    required this.child,
    required this.shellContext,
  });

  final Widget child;
  final BuildContext? shellContext;

  @override
  ConsumerState<MainPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MainPage> with WindowListener {
  bool value = false;

  // int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dataFuture = ref.watch(dbDataFutureProvider);
    var dbProvider = ref.watch(dbFutureProvider);
    return dbProvider.when(
        error: ((error, stackTrace) {
          return const Scaffold(
              body: Center(child: Text('Error connecting to database')));
        }),
        loading: () => const Scaffold(
              body: Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: fluent_ui.ProgressRing(),
                ),
              ),
            ),
        data: (data) {
          return fluent_ui.NavigationView(
              key: viewKey,
              appBar: fluent_ui.NavigationAppBar(
                automaticallyImplyLeading: false,
                actions: DragToMoveArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  children: [
                                    const Text('Academic Year:'),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    fluent_ui.ComboBox(
                                      value: ref.watch(academicYearProvider),
                                      elevation: 0,
                                      onChanged: (year) {
                                        if (year != null) {
                                          ref
                                              .read(
                                                  academicYearProvider.notifier)
                                              .state = year;
                                        }
                                      },
                                      items: academicYears
                                          .map((e) => fluent_ui.ComboBoxItem(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  children: [
                                    const Text('Semester:'),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    fluent_ui.ComboBox(
                                      value: ref.watch(semesterProvider),
                                      elevation: 0,
                                      onChanged: (semester) {
                                        if (semester != null) {
                                          ref
                                              .read(semesterProvider.notifier)
                                              .state = semester;
                                        }
                                      },
                                      items: semesters
                                          .map((e) => fluent_ui.ComboBoxItem(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      const WindowButtons(),
                    ],
                  ),
                ),
              ),
              paneBodyBuilder: (item, child) {
                final name = item?.key is ValueKey
                    ? (item!.key as ValueKey).value
                    : null;
                return dataFuture.when(
                    data: (data) {
                      return FocusTraversalGroup(
                        key: ValueKey('body$name'),
                        child: widget.child,
                      );
                    },
                    loading: () => const Center(
                          child: SizedBox(
                              width: 50,
                              height: 50,
                              child: fluent_ui.ProgressRing()),
                        ),
                    error: (error, statck) {
                      return const Text('Error getting data from datatbase');
                    });
              },
              pane: fluent_ui.NavigationPane(
                size: const fluent_ui.NavigationPaneSize(
                    compactWidth: 60, openWidth: 150),
                selected: SideBar(context: context,ref: ref).calculateSelectedIndex(),
                header: SizedBox(
                  height: 150,
                  child: fluent_ui.Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.indigo.shade500, width: 3),
                        ),
                        child: Container(
                          height: 50,
                          width: 200,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade900,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ref.watch(cuurentTimeStreamProvider).when(
                              data: (data) {
                                return Text(data,
                                    style: getTextStyle(
                                        fontSize: 35, color: Colors.white));
                              },
                              error: (error, stack) {
                                return Text(
                                  'Loading..',
                                  style: getTextStyle(
                                      fontSize: 10, color: Colors.white),
                                );
                              },
                              loading: () => const fluent_ui.SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: fluent_ui.ProgressRing(
                                    activeColor: Colors.white,
                                  ))),
                        ),
                      ),
                      Container(
                        height: 15,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade900,
                          borderRadius: BorderRadius.circular(2),
                          //border: Border.all(color: primaryColor, width: 2),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -10),
                        child: fluent_ui.Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: 0.5,
                              child: Container(
                                height: 40,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade900,
                                  borderRadius: BorderRadius.circular(5),
                                  //border: Border.all(color: primaryColor, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Transform.rotate(
                              angle: -0.5,
                              child: Container(
                                height: 40,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade900,
                                  borderRadius: BorderRadius.circular(5),
                                  //border: Border.all(color: primaryColor, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                indicator: const fluent_ui.StickyNavigationIndicator(),
                items: SideBar(context: context,ref: ref).getItems(),
              ));
        });
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      CustomDialog.showInfo(
          message: 'Are you sure you want to close this window?',
          buttonText: 'Yes',
          onPressed: () {
            windowManager.destroy();
            CustomDialog.dismiss();
          });
    }
  }
}
