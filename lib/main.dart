// import 'package:flutter/gestures.dart';
import 'package:aamusted_timetable_generator/utils/theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:system_theme/system_theme.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:window_manager/window_manager.dart';

import 'config/routes/routes.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:window_manager/window_manager.dart';
// import 'Pages/container_page.dart';
// import 'SateManager/hive_cache.dart';
// import 'SateManager/hive_listener.dart';
// import 'SateManager/navigation_provider.dart';
// import 'Styles/colors.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await windowManager.ensureInitialized();

//   await HiveCache.init();
//   HiveCache.createAdmin();
//   await windowManager.maximize();
//   WindowOptions windowOptions = const WindowOptions(
//     center: true,
//     backgroundColor: Colors.transparent,
//     skipTaskbar: false,
//     minimumSize: Size(800, 600),
//     titleBarStyle: TitleBarStyle.hidden,
//     fullScreen: false,
//   );

//   windowManager.waitUntilReadyToShow(windowOptions, () async {
//     await windowManager.maximize();
//     await windowManager.setAsFrameless();
//     await windowManager.show();
//     await windowManager.focus();
//   });

//   runApp(MultiProvider(providers: [
//     ChangeNotifierProvider(
//       create: (context) => NavigationProvider(),
//     ),
//     ChangeNotifierProvider(create: (context) => HiveListener()),
//   ], child: const MyApp()));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // This widget is the root of your application.
//   Future<void> getData() async {
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       var provider = Provider.of<HiveListener>(context, listen: false);
//       provider.updateConfigList();
//       var courses = await HiveCache.getCourses();
//       provider.setCourseList(courses);
//       var classes = await HiveCache.getClasses();
//       provider.setClassList(classes);
//       var venues = await HiveCache.getVenues();
//       provider.setVenueList(venues);
//       var liberal = HiveCache.getLiberals();
//       provider.setLiberalList(liberal);
//       var tables = HiveCache.getTables();
//       provider.setTable(tables);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       scrollBehavior: const MaterialScrollBehavior().copyWith(
//         dragDevices: {
//           PointerDeviceKind.mouse,
//           PointerDeviceKind.touch,
//           PointerDeviceKind.stylus,
//           PointerDeviceKind.unknown,
//           PointerDeviceKind.trackpad,
//           PointerDeviceKind.invertedStylus
//         },
//       ),
//       title: 'AAMUSTED TIMETABLE GENERATOR',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: Colors.white,
//         indicatorColor: primaryColor,
//         iconTheme: const IconThemeData(color: primaryColor),
//         cardTheme: CardTheme(
//           color: Colors.white,
//           elevation: 5,
//           margin: const EdgeInsets.all(5),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme)
//             .apply(bodyColor: Colors.black87),
//         canvasColor: primaryColor,
//       ),
//       builder: FlutterSmartDialog.init(),
//       home: FutureBuilder(
//           future: getData(),
//           builder: (context, snapshot) {
//             return const ContainerPage();
//           }),
//     );
//   }
// }

// class MyCustomScrollBehavior extends MaterialScrollBehavior {
//   // Override behavior methods and getters like dragDevices
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//         PointerDeviceKind.touch,
//         PointerDeviceKind.mouse,
//         PointerDeviceKind.stylus,
//         PointerDeviceKind.unknown,
//       };
// }
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if it's not on the web, windows or android, load the accent color
  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    await flutter_acrylic.Window.hideWindowControls();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.setMinimumSize(const Size(800, 600));
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

  runApp(const ProviderScope(child: MyApp()));
}
final _appTheme = AppTheme();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.ChangeNotifierProvider.value(
      value: _appTheme,
      builder: (context, child) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp.router(
          title: 'AAMUSTED TIMETABLE GENERATOR',
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          color: appTheme.color,
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          theme: FluentThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}
