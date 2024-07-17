// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aamusted_timetable_generator/config/routes/router.dart';
import 'package:aamusted_timetable_generator/config/routes/router_item.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class SideBar {
  BuildContext context;
  WidgetRef ref;
  SideBar({required this.context, required this.ref});

  List<NavigationPaneItem> getItems() {
    // var config = ref.watch(configProvider);
    // bool configExists = config.id != null &&
    //     config.days.isNotEmpty &&
    //     config.periods.isNotEmpty &&
    //     config.year != null &&
    //     config.semester != null;
    var myRouter = MyRouter(ref: ref, context: context);
    return [
      PaneItem(
        key: ValueKey(RouterItem.configRoute.name),
        icon: const Icon(FluentIcons.settings),
        title: const Text('Config'),
        body: const SizedBox.shrink(),
        onTap: () {
          myRouter.navigateToRoute(RouterItem.configRoute);
        },
      ),
      PaneItem(
        key: ValueKey(RouterItem.departmentRoute.name),
        icon: const Icon(FluentIcons.office_logo),
        title: const Text('Depatments'),
        body: const SizedBox.shrink(),
        onTap: () {
            myRouter.navigateToRoute(RouterItem.departmentRoute);        
        },
      ),
      PaneItem(
        key:  ValueKey(RouterItem.venuesRoute.name),
        icon: const Icon(FluentIcons.room),
        title: const Text('Venues'),
        body: const SizedBox.shrink(),
        onTap: () {
          myRouter.navigateToRoute(RouterItem.venuesRoute);
        },
      ),
       PaneItem(
        key: ValueKey(RouterItem.lecturerRoute.name),
        icon: const Icon(FluentIcons.admin),
        title: const Text('Lecturers'),
        body: const SizedBox.shrink(),
        onTap: () {
          myRouter.navigateToRoute(RouterItem.lecturerRoute);
        },
      ),
      PaneItem(
        key:  ValueKey(RouterItem.classesRoute.name),
        icon: const Icon(FluentIcons.group),
        title: const Text('Classes'),
        body: const SizedBox.shrink(),
        onTap: () {
          myRouter.navigateToRoute(RouterItem.classesRoute);
        },
      ),
      PaneItem(
        key: ValueKey(RouterItem.allocationRoute.name),
        icon: const Icon(FluentIcons.open_folder_horizontal),
        title: const Text('Allocations'),
        body: const SizedBox.shrink(),
        onTap: () {
          myRouter.navigateToRoute(RouterItem.allocationRoute);
        },
      ),
      PaneItem(
        key:  ValueKey(RouterItem.tableRoute.name),
        icon: const Icon(FluentIcons.table),
        title: const Text('Tables'),
        body: const SizedBox.shrink(),
        onTap: () {
          myRouter.navigateToRoute(RouterItem.tableRoute);
        },
      ),
      PaneItem(
        key: const ValueKey('space1'),
        icon: const SizedBox.shrink(),
        enabled: false,
        body: const SizedBox.shrink(),
      ),
      //add a divider
      PaneItemSeparator(thickness: 4),
      PaneItem(
        key: const ValueKey('space2'),
        icon: const SizedBox.shrink(),
        enabled: false,
        body: const SizedBox.shrink(),
      ),
      PaneItem(
        key:  ValueKey(RouterItem.helpRoute.name),
        icon: const Icon(FluentIcons.help),
        title: const Text('Help'),
        body: const SizedBox.shrink(),
        onTap: () {
          myRouter.navigateToRoute(RouterItem.helpRoute);
        },
      ),
      PaneItem(
        key:  ValueKey(RouterItem.aboutRoute.name),
        icon: const Icon(FluentIcons.user_gauge),
        title: const Text('About'),
        body: const SizedBox.shrink(),
        onTap: () {
          myRouter.navigateToRoute(RouterItem.aboutRoute);
        },
      ),
    ];
  }

  int calculateSelectedIndex() {
    final location = GoRouterState.of(context).uri.toString();
    var list = getItems();
    int indexOriginal = list
        .where((item) => item.key != null)
        .toList()
        .indexWhere((item) => item.key == Key(location));

    if (indexOriginal == -1) {
      return list.where((element) => element.key != null).toList().length;
    } else {
      return indexOriginal;
    }
  }
}
