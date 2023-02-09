import 'package:aamusted_timetable_generator/SateManager/navigation_provider.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../SateManager/hive_listener.dart';
import '../CoursePage/special_venue_courses_list.dart';

class IncompleteData extends StatefulWidget {
  const IncompleteData({super.key});

  @override
  State<IncompleteData> createState() => _IncompleteDataState();
}

class _IncompleteDataState extends State<IncompleteData> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, hive, child) {
      return SizedBox(
        width: double.infinity,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: size.width * 0.6,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'The following data are requirements for the timetable generation Create or Import all the missing Data to proceed with the table generation:',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(
                            color: secondaryColor,
                          ),
                          const SizedBox(height: 20),
                          if (hive.getCurrentConfig.days == null ||
                              hive.getCurrentConfig.periods == null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Configure the days and periods on which classes will be held: ',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<NavigationProvider>(context,
                                              listen: false)
                                          .setPage(0);
                                    },
                                    child: Text(
                                      'Go to Configuration',
                                      style: GoogleFonts.nunito(
                                          color: Colors.blue, fontSize: 18),
                                    ))
                              ],
                            ),
                          const SizedBox(height: 15),
                          if (!hive.getCurrentConfig.hasCourse)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'No Courses have been Imported or Created at the moment: ',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<NavigationProvider>(context,
                                              listen: false)
                                          .setPage(1);
                                    },
                                    child: Text(
                                      'Import Courses',
                                      style: GoogleFonts.nunito(
                                          color: Colors.blue, fontSize: 18),
                                    ))
                              ],
                            ),
                          const SizedBox(height: 15),
                          if (!hive.getCurrentConfig.hasClass)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'No Students\' Classes have been Imported or Created at the moment: ',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<NavigationProvider>(context,
                                              listen: false)
                                          .setPage(2);
                                    },
                                    child: Text(
                                      'Import Classes',
                                      style: GoogleFonts.nunito(
                                          color: Colors.blue, fontSize: 18),
                                    ))
                              ],
                            ),
                          const SizedBox(height: 15),
                          if (hive.getVenues.isEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'No Venues have been Imported or Created at the moment: ',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<NavigationProvider>(context,
                                              listen: false)
                                          .setPage(4);
                                    },
                                    child: Text(
                                      'Import Venues',
                                      style: GoogleFonts.nunito(
                                          color: Colors.blue, fontSize: 18),
                                    ))
                              ],
                            ),
                          const SizedBox(height: 15),
                          if (hive.getCurrentConfig.hasLiberalCourse &&
                              (hive.getCurrentConfig.liberalCourseDay == null ||
                                  hive.getCurrentConfig.liberalCoursePeriod ==
                                      null ||
                                  hive.getCurrentConfig.liberalLevel == null))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'You have not set day and period for Liberal/African Studies Courses: ',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<NavigationProvider>(context,
                                              listen: false)
                                          .setPage(3);
                                    },
                                    child: Text(
                                      'Make Settings',
                                      style: GoogleFonts.nunito(
                                          color: Colors.blue, fontSize: 18),
                                    ))
                              ],
                            ),
                          const SizedBox(height: 15),
                          if (hive.getHasSpecialCourseError)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Some Courses require special venues: ',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          opaque: false, // set to false
                                          pageBuilder: (_, __, ___) =>
                                              const ListOfSpecialCourse(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Set Special Venues',
                                      style: GoogleFonts.nunito(
                                          color: Colors.blue, fontSize: 18),
                                    ))
                              ],
                            ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
