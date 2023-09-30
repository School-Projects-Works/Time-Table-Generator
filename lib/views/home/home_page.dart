import 'package:aamusted_timetable_generator/global/widgets/custom_dialog.dart';
import 'package:aamusted_timetable_generator/global/widgets/side_bar.dart';
import 'package:aamusted_timetable_generator/global/widgets/window_buttons.dart';
import 'package:aamusted_timetable_generator/riverpod/academic_config.dart';
import 'package:aamusted_timetable_generator/utils/theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../../config/routes/routes.dart';
import '../../global/constants/constant_list.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({
    super.key,
    required this.child,
    required this.shellContext,
  });

  final Widget child;
  final BuildContext? shellContext;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with WindowListener {
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
    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    if (widget.shellContext != null) {
      if (router.canPop() == false) {
        setState(() {});
      }
    }
    return NavigationView(
        key: viewKey,
        appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          actions: DragToMoveArea(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        if(year!=null){
                          ref.read(academicYearProvider.notifier).state=year;
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
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          ref.read(semesterProvider.notifier).state = semester;
                        }
                      },
                      items: ['Semester One', 'Semester Two']
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
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    const Text('Student Type:'),
                    const SizedBox(
                      width: 5,
                    ),
                    ComboBox(
                      elevation: 0,
                      value: ref.watch(studentTypeProvider),
                      onChanged: (year) {
                        if (year != null) {
                          ref.read(studentTypeProvider.notifier).state = year;
                        }
                      },
                      items: [
                        'Reguler (inc Masters)',
                        'Week End (inc Masters)',
                        'Sandwich (inc Masters)'
                      ]
                          .map((e) => ComboBoxItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: ToggleSwitch(
                    content: Text(appTheme.mode == ThemeMode.dark
                        ? 'Dark Mode'
                        : 'Light Mode'),
                    checked: FluentTheme.of(context).brightness.isDark,
                    onChanged: (v) {
                      if (v) {
                        appTheme.mode = ThemeMode.dark;
                      } else {
                        appTheme.mode = ThemeMode.light;
                      }
                    },
                  ),
                ),
              ),
              const WindowButtons(),
            ]),
          ),
        ),
        paneBodyBuilder: (item, child) {
          final name =
              item?.key is ValueKey ? (item!.key as ValueKey).value : null;
          return FocusTraversalGroup(
            key: ValueKey('body$name'),
            child: widget.child,
          );
        },
        pane: NavigationPane(
          size: const NavigationPaneSize(compactWidth: 60, openWidth: 150),
          selected: SideBar(context: context).calculateSelectedIndex(),
          header: SizedBox(
            height: 120,
            child: ShaderMask(
              shaderCallback: (rect) {
                final color = appTheme.color.defaultBrushFor(
                  theme.brightness,
                );
                return LinearGradient(
                  colors: [
                    color,
                    color,
                  ],
                ).createShader(rect);
              },
              child: Image.asset(
                appTheme.logo,
                fit: BoxFit.contain,

              )
            ),
          ),
          displayMode: appTheme.displayMode,
          indicator: const StickyNavigationIndicator(),
          items: SideBar(context: context).getItems(),
        ));
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && mounted) {
      MyDialog(
          context: context,
          title: 'Confirm close',
          message: 'Are you sure you want to close this window?',
          confirmButtonText: 'Yes',
          confirmButtonPress: () {
            windowManager.destroy();
          }).confirmation();
    }
  }
}
