// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
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
      var venues = hive.getVenues
          .where((element) => element.isSpecialVenue!.toLowerCase() == 'yes')
          .toList();
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
                        'Select Venues where this course can be offered\n (${widget.course.code} - ${widget.course.title})',
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
                              onChanged: (p0) {
                                setState(() {
                                  if (!widget.course.venues!.contains(p0)) {
                                    widget.course.venues!.add(p0);
                                  }
                                });
                              },
                              items: venues
                                  .map((e) => DropdownMenuItem(
                                      value: e.name,
                                      child: Text(
                                        e.name!,
                                        style: GoogleFonts.nunito(),
                                      )))
                                  .toList(),
                              color: Colors.white),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: widget.course.venues!.length,
                            itemBuilder: ((context, index) {
                              return ListTile(
                                title: Text(
                                  widget.course.venues![index],
                                  style:
                                      GoogleFonts.nunito(color: Colors.white),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.course.venues!.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              );
                            }),
                          )),
                      const SizedBox(height: 20),
                      if (widget.course.venues!.isNotEmpty)
                        CustomButton(
                            onPressed: saveCourse, text: 'Save Changes')
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }

  void saveCourse() {
    Provider.of<HiveListener>(context, listen: false)
        .setSpecialVenue(widget.course);
    Navigator.pop(context);
  }
}
