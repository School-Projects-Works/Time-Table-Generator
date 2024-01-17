
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import '../../features/allocations/views/allocations_page.dart';
import '../../features/configurations/view/config_page.dart';
import '../../features/main/views/home_container.dart';


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
      GoRoute(path: '/', builder: (context, state) =>  const ConfigPage()),

      /// data
      GoRoute(path: '/allocations', builder: (context, state) =>  const AllocationPage()),
      //liberal course
      //  GoRoute(path: '/liberal', builder: (context, state) =>  const LiberalCoursesPage()),
      // /// venues
      // GoRoute(path: '/venues', builder: (context, state) =>  const VenuesPage()),
      /// tables
      GoRoute(path: '/tables', builder: (context, state) =>  Container()),

     
    ],
  ),
]);