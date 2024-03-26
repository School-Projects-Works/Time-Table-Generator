import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import '../../features/allocations/views/allocations_page.dart';
import '../../features/configurations/view/config_page.dart';
import '../../features/liberal/views/liberal_course_page.dart';
import '../../features/main/views/home_container.dart';
import '../../features/tables/views/tables_main_page.dart';
import '../../features/venues/views/venue_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(navigatorKey: rootNavigatorKey, routes: [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return MainPage(
        shellContext: _shellNavigatorKey.currentContext,
        child: child,
      );
    },
    routes: [
      /// config
      GoRoute(path: '/', builder: (context, state) => const ConfigPage()),

      /// data
      GoRoute(
          path: '/allocations',
          builder: (context, state) => const AllocationPage()),
      //liberal course
      //  GoRoute(path: '/liberal', builder: (context, state) =>  const LiberalCoursesPage()),
      // /// venues
      GoRoute(path: '/venues', builder: (context, state) => const VenuePage()),

      /// tables
      GoRoute(path: '/tables', builder: (context, state) => const TablesMainPage()),
      //liberal courses
      GoRoute(
          path: '/liberal', builder: (context, state) => const LiberalPage()),
      GoRoute(
          path: '/special_venues/:id',
          name: 'special_venue_page',
          builder: (context, state) {
           // var id = state.pathParameters['id'];
            return Container();
          }),
    ],
  ),
]);
