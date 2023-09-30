import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import '../../views/config_page/config_page.dart';
import '../../views/data_page/data_page.dart';
import '../../views/home/home_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(navigatorKey: rootNavigatorKey, routes: [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return MyHomePage(
        shellContext: _shellNavigatorKey.currentContext,
        child: child,
      );
    },
    routes: [
      /// config
      GoRoute(path: '/', builder: (context, state) =>  const ConfigPage()),

      /// data
      GoRoute(path: '/data', builder: (context, state) =>  const DataPage()),
      /// venues
      GoRoute(path: '/venues', builder: (context, state) =>  Container()),
      /// tables
      GoRoute(path: '/tables', builder: (context, state) =>  Container()),

     
    ],
  ),
]);