import 'package:aamusted_timetable_generator/config/routes/router_item.dart';
import 'package:aamusted_timetable_generator/features/about/view/about.dart';
import 'package:aamusted_timetable_generator/features/configurations/view/config_page.dart';
import 'package:aamusted_timetable_generator/features/help/view/help.dart';
import 'package:aamusted_timetable_generator/features/lecturers/views/lecturers_page.dart';
import 'package:aamusted_timetable_generator/features/tables/views/tables_main_page.dart';
import 'package:aamusted_timetable_generator/features/venues/views/venue_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/allocations/views/allocations_page.dart';
import '../../features/configurations/views/classes_page.dart';
import '../../features/main/views/home_container.dart';

class MyRouter {
  final WidgetRef ref;
  final BuildContext context;
  MyRouter({
    required this.ref,
    required this.context,
  });
  router() => GoRouter(initialLocation: RouterItem.venuesRoute.path, routes: [
        ShellRoute(
            builder: (context, state, child) {
              return MainPage(
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: RouterItem.configRoute.path,
                builder: (context, state) {
                  return const ConfigPage();
                },
              ),
              GoRoute(
                  path: RouterItem.venuesRoute.path,
                  builder: (context, state) {
                    return const VenuePage();
                  }),
              GoRoute(
                  path: RouterItem.lecturerRoute.path,
                  builder: (context, state) {
                    return const LecturersPage();
                  }),
              GoRoute(
                path: RouterItem.classesRoute.path,
                builder: (context, state) {
                  return const ClassesPage();
                },
              ),
              GoRoute(
                  path: RouterItem.allocationRoute.path,
                  builder: (context, state) {
                    return const AllocationPage();
                  }),
              GoRoute(
                  path: RouterItem.tableRoute.path,
                  builder: (context, state) {
                    return const TablesMainPage();
                  }),
              GoRoute(
                  path: RouterItem.helpRoute.path,
                  builder: (context, state) {
                    return const HelpPage();
                  }),
              GoRoute(
                  path: RouterItem.aboutRoute.path,
                  builder: (context, state) {
                    return const AboutPage();
                  }),
            ]),
      ]);

  void navigateToRoute(RouterItem item) {
    ref.read(routerProvider.notifier).state = item.name;
    context.go(item.path);
  }

  void navigateToNamed(
      {required Map<String, String> pathParms,
      required RouterItem item,
      Map<String, dynamic>? extra}) {
    ref.read(routerProvider.notifier).state = item.name;
    context.goNamed(item.name, pathParameters: pathParms, extra: extra);
  }
}

final routerProvider = StateProvider<String>((ref) {
  return RouterItem.configRoute.name;
});
