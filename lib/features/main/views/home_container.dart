
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/main/views/components/window_buttons.dart';
import 'package:aamusted_timetable_generator/generated/assets.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import '../../../config/routes/routes.dart';
import '../../../core/data/constants/constant_data.dart';
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
    if (widget.shellContext != null) {
      if (router.canPop() == false) {
        setState(() {});
      }
    }
    var dataFuture = ref.watch(dbDataFutureProvider);
    return NavigationView(
        key: viewKey,
        appBar: NavigationAppBar(
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
                              ComboBox(
                                value: ref.watch(academicYearProvider),
                                elevation: 0,
                                onChanged: (year) {
                                  if (year != null) {
                                    ref
                                        .read(academicYearProvider.notifier)
                                        .state = year;
                                  }
                                },
                                items: academicYears
                                    .map((e) => ComboBoxItem(
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
                              ComboBox(
                                value: ref.watch(semesterProvider),
                                elevation: 0,
                                onChanged: (semester) {
                                  if (semester != null) {
                                    ref.read(semesterProvider.notifier).state =
                                        semester;
                                  }
                                },
                                items: semesters
                                    .map((e) => ComboBoxItem(
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
          final name =
              item?.key is ValueKey ? (item!.key as ValueKey).value : null;
          return dataFuture.when(
              data: (data) {
                return FocusTraversalGroup(
                  key: ValueKey('body$name'),
                  child: widget.child,
                );
              },
              loading: () => const Center(
                    child:
                        SizedBox(width: 50, height: 50, child: ProgressRing()),
                  ),
              error: (error, statck) {
               
                return const Text('Error getting data from datatbase');
              });
        },
        pane: NavigationPane(
          size: const NavigationPaneSize(compactWidth: 60, openWidth: 150),
          selected: SideBar(context: context).calculateSelectedIndex(),
          header: SizedBox(
            height: 120,
            child: Image.asset(Assets.assetsLogo),
          ),
          indicator: const StickyNavigationIndicator(),
          items: SideBar(context: context).getItems(),
        ));
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
