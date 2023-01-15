import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:aamusted_timetable_generator/SateManager/NavigationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Styles/colors.dart';
import 'Pages/VenuePage/VenuePage.dart';
import 'Components/SideBar.dart';
import 'Components/TopView.dart';
import 'Pages/AboutPage.dart';
import 'Pages/ClassPage/ClassesPage.dart';
import 'Pages/ConfigPage/Configurations.dart';
import 'Pages/CoursePage/CoursesPage.dart';
import 'Pages/HelpPage.dart';
import 'Pages/LiberalPage/LiberalPage.dart';
import 'Pages/NewAcademic.dart';
import 'Pages/TimetablePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<NavigationProvider>(builder: (context, nav, child) {
      return SizedBox(
        width: double.infinity,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopView(),
            Row(
              children: [
                const SideBard(),
                Consumer<HiveListener>(builder: (context, hive, child) {
                  return Expanded(
                    child: Card(
                      elevation: 10,
                      color: background,
                      child: Container(
                          height: size.height - 135,
                          margin: const EdgeInsets.only(
                              left: 10, top: 10, right: 5, bottom: 5),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20))),
                          child: hive.getAcademicList.isNotEmpty
                              ? IndexedStack(
                                  index: nav.page,
                                  children: const [
                                    Configuration(),
                                    CoursesPage(),
                                    ClassesPage(),
                                    LiberalPage(),
                                    VenuePage(),
                                    TimeTablePage(),
                                  ],
                                )
                              : const NewAcademic()),
                    ),
                  );
                })
              ],
            )
          ],
        ),
      );
    });
  }
}
