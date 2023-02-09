import 'dart:convert';
import 'dart:io';
import 'package:aamusted_timetable_generator/Components/custom_button.dart';
import 'package:aamusted_timetable_generator/Components/smart_dialog.dart';
import 'package:aamusted_timetable_generator/Components/text_inputs.dart';
import 'package:aamusted_timetable_generator/Constants/custom_string_functions.dart';
import 'package:aamusted_timetable_generator/Models/Table/table_model.dart';
import 'package:aamusted_timetable_generator/Services/publish_data.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import '../../Models/Config/period_model.dart';
import '../../SateManager/hive_listener.dart';
import '../../SateManager/navigation_provider.dart';
import '../../Services/file_service.dart';
import '../../Styles/diagonal_widget.dart';
import 'package:http/http.dart' as http;

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  final schoolNameController = TextEditingController(
      text:
          'AKENTEN APPIAH-MENKA UNIVERSITY OF SKILLS TRAINING AND ENTREPRENEURIAL DEVELOPMENT');
  final descriptionController = TextEditingController(
      text:
          'PROVISIONAL LECTURE TIMETABLE FOR REGULAR PROGRAMMES FOR 2022/2023 ACADEMIC YEAR ');
  final footerController = TextEditingController();
  Uint8List? signature;
  String? schoolName, tableDescription, tableFooter;

  var boldText = const TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  var headerText = const TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Consumer<HiveListener>(builder: (context, hive, child) {
        List<PeriodModel> periods = hive.getCurrentConfig.periods != null
            ? hive.getCurrentConfig.periods!
                .map((e) => PeriodModel.fromMap(e))
                .toList()
            : [];
        var tables = hive.getFilteredTableItems;
        if (hive.getCurrentConfig.breakTime != null) {
          periods.add(PeriodModel.fromMap(hive.getCurrentConfig.breakTime!));
        }
        periods.sort((a, b) => GlobalFunctions.timeFromString(a.startTime!)
            .hour
            .compareTo(GlobalFunctions.timeFromString(b.startTime!).hour));
        List<PeriodModel> firstPeriods = [];
        List<PeriodModel> secondPeriods = [];
        PeriodModel? breakPeriod;
        if (periods.isNotEmpty) {
          firstPeriods = [];
          secondPeriods = [];
          periods.sort((a, b) => GlobalFunctions.timeFromString(a.startTime!)
              .hour
              .compareTo(GlobalFunctions.timeFromString(b.startTime!).hour));
          //split periods at where breakTime is
          breakPeriod = periods.firstWhereOrNull((element) =>
              element.period!.trimToLowerCase() == 'break'.trimToLowerCase());
          if (breakPeriod != null) {
            for (PeriodModel period in periods) {
              //we check if period start time is less than break time
              if (GlobalFunctions.timeFromString(period.startTime!).hour <
                  GlobalFunctions.timeFromString(breakPeriod.startTime!).hour) {
                firstPeriods.add(period);
              } else if (GlobalFunctions.timeFromString(period.startTime!)
                      .hour >
                  GlobalFunctions.timeFromString(breakPeriod.startTime!).hour) {
                secondPeriods.add(period);
              }
            }
          } else {
            firstPeriods = periods;
          }
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //show close button
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                          onPressed: () {
                            CustomDialog.showInfo(
                                message:
                                    'Please Note that if this Table already Exist on the web, it will be overwritten.',
                                buttonText: 'Got it',
                                onPressed: () {
                                  CustomDialog.dismiss();
                                  exportTables(hive);
                                });
                          },
                          text: 'Publish to Web'),
                      const SizedBox(width: 20),
                      CustomButton(
                          color: primaryColor,
                          onPressed: () {
                            //check if school name and description is not empty
                            if (schoolNameController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty) {
                              PublishData.exportData(
                                context: context,
                                schoolName: schoolNameController.text,
                                tableDesc: descriptionController.text,
                                signature: signature,
                                tables: tables,
                                periods: periods,
                                days: hive.getCurrentConfig.days!,
                                footer: footerController.text,
                              );
                            } else {
                              CustomDialog.showError(
                                  message:
                                      'Please fill in school name and description');
                            }
                          },
                          text: 'Export to PDF')
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Provider.of<NavigationProvider>(context, listen: false)
                            .setCurrentIndex(1);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.35,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Set up Tables file header details.\n (School Name and Table Description)',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'School Name',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CustomTextFields(
                                controller: schoolNameController,
                                maxLines: 3,
                                hintText: 'Enter School Name',
                                isCapitalized: true,
                                onChanged: (value) {
                                  setState(() {
                                    schoolName = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Table Description',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CustomTextFields(
                                controller: descriptionController,
                                maxLines: 3,
                                isCapitalized: true,
                                hintText: 'Enter Table Description',
                                onChanged: (value) {
                                  setState(() {
                                    tableDescription = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Table Footer',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CustomTextFields(
                                controller: footerController,
                                maxLines: 3,
                                isCapitalized: true,
                                hintText: 'Enter Table Footer',
                                onChanged: (value) {
                                  setState(() {
                                    tableFooter = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 40),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Table Signature (Optional)',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              //upload signature
                              const SizedBox(height: 10),
                              Align(
                                  alignment: Alignment.center,
                                  child: TextButton.icon(
                                      style: TextButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: const EdgeInsets.all(16.0),
                                      ),
                                      onPressed: () => uploadSignature(),
                                      icon: const Icon(
                                        FontAwesomeIcons.upload,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Upload Signature',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      ))),
                              const SizedBox(height: 10),
                              if (signature != null)
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.memory(
                                    signature!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              if (signature != null)
                                Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => Colors.red),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      onPressed: () {
                                        setState(() {
                                          signature = null;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 30,
                                      )),
                                ),
                              //const SizedBox(height: 20),
                            ]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Preview of how the table will look like',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: SizedBox(
                                      width: size.width * 0.6,
                                      child: Column(
                                        children: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Text(
                                                    schoolName ??
                                                        schoolNameController
                                                            .text,
                                                    textAlign: TextAlign.center,
                                                    style: headerText),
                                              )),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                tableDescription ??
                                                    descriptionController.text,
                                                textAlign: TextAlign.center,
                                                style: boldText),
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Monday',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                    color: secondaryColor)),
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          width: 170,
                                                          height: 60,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          child: CustomPaint(
                                                            painter:
                                                                DiagonalLinePainter(),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                    child: Text(
                                                                        'Venue',
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                    child: Text(
                                                                        'Period',
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                      Row(
                                                        children: [
                                                          if (firstPeriods
                                                              .isNotEmpty)
                                                            Row(
                                                              children:
                                                                  firstPeriods
                                                                      .map((e) =>
                                                                          Container(
                                                                            width:
                                                                                130,
                                                                            height:
                                                                                60,
                                                                            padding:
                                                                                const EdgeInsets.all(5),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(color: Colors.black),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Text(e.period!, style: GoogleFonts.poppins(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                Text('${e.startTime} - ${e.endTime}', style: GoogleFonts.poppins(fontSize: 10, color: Colors.black)),
                                                                              ],
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                            ),
                                                          if (breakPeriod !=
                                                              null)
                                                            Container(
                                                              height: 60,
                                                              width: 90,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border: Border(
                                                                  top: BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width: 2),
                                                                ),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                      breakPeriod
                                                                          .startTime!,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                      breakPeriod
                                                                          .endTime!,
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ],
                                                              ),
                                                            ),
                                                          if (secondPeriods
                                                              .isNotEmpty)
                                                            Row(
                                                              children:
                                                                  secondPeriods
                                                                      .map((e) =>
                                                                          Container(
                                                                            width:
                                                                                130,
                                                                            height:
                                                                                60,
                                                                            padding:
                                                                                const EdgeInsets.all(5),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(color: Colors.black),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Text(e.period!, style: GoogleFonts.poppins(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                Text('${e.startTime} - ${e.endTime}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black)),
                                                                              ],
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                            ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          width: 170,
                                                          height: 80,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          child: Text(
                                                            'ROB Room 24',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          )),
                                                      Row(
                                                        children: [
                                                          if (firstPeriods
                                                              .isNotEmpty)
                                                            Row(
                                                              children:
                                                                  firstPeriods
                                                                      .map((e) =>
                                                                          Container(
                                                                            width:
                                                                                130,
                                                                            height:
                                                                                80,
                                                                            padding:
                                                                                const EdgeInsets.all(5),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(color: Colors.black),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Text(
                                                                                  'Class Name',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.nunito(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Course Code',
                                                                                  style: GoogleFonts.nunito(fontSize: 13, color: secondaryColor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  '(Course Title)',
                                                                                  textAlign: TextAlign.center,
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: GoogleFonts.nunito(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  '-Lecturer Name-',
                                                                                  textAlign: TextAlign.center,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: GoogleFonts.nunito(fontSize: 10, color: secondaryColor.withOpacity(.5), fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                            ),
                                                          if (breakPeriod !=
                                                              null)
                                                            Container(
                                                              height: 80,
                                                              width: 90,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border: Border(
                                                                  top: BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width: 2),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                'Break',
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          if (secondPeriods
                                                              .isNotEmpty)
                                                            Row(
                                                                children:
                                                                    secondPeriods
                                                                        .map((e) =>
                                                                            Container(
                                                                              width: 130,
                                                                              height: 80,
                                                                              padding: const EdgeInsets.all(5),
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                border: Border.all(color: Colors.black),
                                                                              ),
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    'Class Name',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.nunito(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    'Course Code',
                                                                                    style: GoogleFonts.nunito(fontSize: 13, color: secondaryColor, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    '(Course Title)',
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: GoogleFonts.nunito(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    '-Lecturer Name-',
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: GoogleFonts.nunito(fontSize: 10, color: secondaryColor.withOpacity(.5), fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ))
                                                                        .toList()),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          width: 170,
                                                          height: 80,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          child: Text(
                                                            'ROB Room 14',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          )),
                                                      Row(
                                                        children: [
                                                          if (firstPeriods
                                                              .isNotEmpty)
                                                            Row(
                                                              children:
                                                                  firstPeriods
                                                                      .map((e) =>
                                                                          Container(
                                                                            width:
                                                                                130,
                                                                            height:
                                                                                80,
                                                                            padding:
                                                                                const EdgeInsets.all(5),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(color: Colors.black),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Text(
                                                                                  'Class Name',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.nunito(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Course Code',
                                                                                  style: GoogleFonts.nunito(fontSize: 13, color: secondaryColor, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  '(Course Title)',
                                                                                  textAlign: TextAlign.center,
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: GoogleFonts.nunito(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  '-Lecturer Name-',
                                                                                  textAlign: TextAlign.center,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: GoogleFonts.nunito(fontSize: 10, color: secondaryColor.withOpacity(.5), fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                            ),
                                                          if (breakPeriod !=
                                                              null)
                                                            Container(
                                                              height: 80,
                                                              width: 90,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border: Border(
                                                                  top: BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width: 2),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                'Break',
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          if (secondPeriods
                                                              .isNotEmpty)
                                                            Row(
                                                                children:
                                                                    secondPeriods
                                                                        .map((e) =>
                                                                            Container(
                                                                              width: 130,
                                                                              height: 80,
                                                                              padding: const EdgeInsets.all(5),
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                border: Border.all(color: Colors.black),
                                                                              ),
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    'Class Name',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.nunito(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    'Course Code',
                                                                                    style: GoogleFonts.nunito(fontSize: 13, color: secondaryColor, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    '(Course Title)',
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: GoogleFonts.nunito(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    '-Lecturer Name-',
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: GoogleFonts.nunito(fontSize: 10, color: secondaryColor.withOpacity(.5), fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ))
                                                                        .toList()),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        tableFooter ?? '',
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (signature != null)
                                                            Text(
                                                              'Timetable Source:',
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          if (signature != null)
                                                            Image.memory(
                                                              signature!,
                                                              width: 100,
                                                              height: 100,
                                                            ),
                                                          const SizedBox(
                                                              height: 5),
                                                        ]),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  uploadSignature() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        var file = File(result.files.first.path!);
        signature = file.readAsBytesSync();
      });
    } else {
      // User canceled the picker
    }
  }

  void exportTables(HiveListener hive) async {
    CustomDialog.showLoading(message: 'Exporting Table to the Web....');
    TableModel? table = hive.getTable;
    table!.tableFooter = footerController.text;
    table.tableSchoolName = schoolNameController.text;
    table.tableDescription = descriptionController.text;

    if (signature != null) {
      Uint8List? newFile;
      if (isByteArrayTooLarge(signature!)) {
        newFile = await storeResizedImageInFirestore(signature!);
      } else {
        newFile = signature;
      }
      table.signature = uint8ListToBase64(newFile!);
    }

    //print('Table Model===${table.toMap()}');
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.parse(
            'http://127.0.0.1:5001/aamusted-timetable/us-central1/app/api/create'),
        body: table.toJson(),
      );
      CustomDialog.dismiss();
      if (response.statusCode == 200) {
        CustomDialog.showSuccess(message: 'Table exported successfully');
      } else {
        CustomDialog.showError(
            message: 'Table could not be exported\n ${response.body}');
      }
    } finally {
      client.close();
      CustomDialog.dismiss();
    }
  }

  bool isByteArrayTooLarge(Uint8List bytes) {
    int firestoreSizeLimit = 1024 * 1024;
    return bytes.length > firestoreSizeLimit;
  }

  Future<Uint8List?> storeResizedImageInFirestore(Uint8List imageBytes) async {
    final image = img.decodeImage(imageBytes);
    final resizedImage = img.copyResize(image!, width: 512, height: 512);
    final bytes = img.encodePng(resizedImage);

    return Uint8List.fromList(bytes);
  }

  String uint8ListToBase64(Uint8List uint8List) {
    String base64String = base64Encode(uint8List);
    String header = 'data:image/png;base64,';
    return header + base64String;
  }
}
