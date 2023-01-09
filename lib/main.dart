import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'Pages/ContainerPage.dart';
import 'SateManager/ConfigDataFlow.dart';
import 'SateManager/HiveCache.dart';
import 'SateManager/HiveListener.dart';
import 'SateManager/NavigationProvider.dart';
import 'Styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await HiveCache.init();
  HiveCache.createAdmin();
  await windowManager.maximize();
  WindowOptions windowOptions = const WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    minimumSize: Size(800, 600),
    titleBarStyle: TitleBarStyle.hidden,
    fullScreen: false,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.maximize();
    await windowManager.setAsFrameless();
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
    ),
    ChangeNotifierProvider(create: (context) => ConfigDataFlow()),
    ChangeNotifierProvider(create: (context) => HiveListener()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'AAMUSTED TIMETABLE GENERATOR',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.white,
        indicatorColor: primaryColor,
        iconTheme: const IconThemeData(color: primaryColor),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 5,
          margin: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black87),
        canvasColor: primaryColor,
      ),
      builder: FlutterSmartDialog.init(),
      home: const ContainerPage(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
