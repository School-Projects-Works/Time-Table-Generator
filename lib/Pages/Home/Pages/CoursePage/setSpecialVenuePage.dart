import 'package:aamusted_timetable_generator/Models/Course/CourseModel.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveListener.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CustomDropDown.dart';
import '../../../../Styles/colors.dart';

class SetSpecialVenue extends StatefulWidget {
  const SetSpecialVenue({super.key, required this.course});
  final CourseModel course;

  @override
  State<SetSpecialVenue> createState() => _SetSpecialVenueState();
}

class _SetSpecialVenueState extends State<SetSpecialVenue> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, hive, child) {
      var venues = hive.getVenues;
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            width: size.width,
            height: size.height,
            child: Center(
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 500,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      Text(
                        'Select Venue for this course\n (${widget.course.code} - ${widget.course.title})',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      if (venues.isEmpty)
                        Text(
                          'No Venue Found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      if (venues.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CustomDropDown(
                              onChanged: (p0) => setVal(p0),
                              items: venues
                                  .map((e) => DropdownMenuItem(
                                      value: e.name,
                                      child: Text(
                                        e.name!,
                                        style: GoogleFonts.nunito(),
                                      )))
                                  .toList(),
                              color: Colors.white),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }

  setVal(p0) {
    Provider.of<HiveListener>(context, listen: false)
        .setSpecialVenue(widget.course, p0);
    Navigator.pop(context);
  }
}
