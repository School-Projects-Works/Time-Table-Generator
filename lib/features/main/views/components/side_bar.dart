// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../configurations/provider/config_provider.dart';

class SideBar {
  BuildContext context;
  WidgetRef ref;
  SideBar({required this.context, required this.ref});

  List<NavigationPaneItem> getItems() {
    var config = ref.watch(configProvider);
    bool configExists = config.id != null &&
        config.days.isNotEmpty &&
        config.periods.isNotEmpty &&
        config.year != null &&
        config.semester != null;
    return [
      PaneItem(
        key: const ValueKey('/'),
        icon: const Icon(FluentIcons.settings),
        title: const Text('Config'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (GoRouterState.of(context).uri.toString() != '/') {
            context.go('/');
          }
        },
      ),
      PaneItem(
        key: const ValueKey('/allocations'),
        icon: const Icon(FluentIcons.list),
        title: const Text('Allocations'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (GoRouterState.of(context).uri.toString() != '/allocations') {
            if (configExists) {
              context.go('/allocations');
            } else {
              CustomDialog.showError(message: 'Please set configuration first');
            }
          }
        },
      ),
      PaneItem(
        key: const ValueKey('/liberal'),
        icon: const Icon(FluentIcons.book_answers),
        title: const Text('Liberal Courses'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (GoRouterState.of(context).uri.toString() != '/liberal') {
            if (configExists) {
              context.go('/liberal');
            } else {
              CustomDialog.showError(message: 'Please set configuration first');
            }
          }
        },
      ),
      PaneItem(
        key: const ValueKey('/venues'),
        icon: const Icon(FluentIcons.room),
        title: const Text('Venues'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (GoRouterState.of(context).uri.toString() != '/venues') {
            if (configExists) {
              context.go('/venues');
            } else {
              CustomDialog.showError(message: 'Please set configuration first');
            }
          }
        },
      ),
      PaneItem(
        key: const ValueKey('/tables'),
        icon: const Icon(FluentIcons.table),
        title: const Text('Tables'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (GoRouterState.of(context).uri.toString() != '/tables') {
            if (configExists) {
              context.go('/tables');
            } else {
              CustomDialog.showError(message: 'Please set configuration first');
            }
          }
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
        key: const ValueKey('/help'),
        icon: const Icon(FluentIcons.help),
        title: const Text('Help'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (GoRouterState.of(context).uri.toString() != '/help') {
            context.go('/help');
          }
        },
      ),
      PaneItem(
        key: const ValueKey('/about'),
        icon: const Icon(FluentIcons.user_gauge),
        title: const Text('About'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (GoRouterState.of(context).uri.toString() != '/about') {
            context.go('/about');
          }
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
