// ignore_for_file: file_names

import 'dart:io';

import 'package:aamusted_timetable_generator/Constants/Constant.dart';
import 'package:aamusted_timetable_generator/Models/Venue/VenueModel.dart';
import 'package:aamusted_timetable_generator/SateManager/ConfigDataFlow.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CustomButton.dart';
import '../../../../Components/CustomTable.dart';
import '../../../../Components/SmartDialog.dart';
import '../../../../Components/TextInputs.dart';
import '../../../../SateManager/HiveCache.dart';
import '../../../../SateManager/HiveListener.dart';
import '../../../../Services/FileService.dart';
import '../../../../Styles/colors.dart';
import 'VenueDataSource.dart';

class VenuePage extends StatefulWidget {
  const VenuePage({super.key});

  @override
  State<VenuePage> createState() => _VenuePageState();
}

class _VenuePageState extends State<VenuePage> {
  final _scrollController = ScrollController();
  final _scrollController2 = ScrollController();
  final List<String> columns = [
    '',
    'Room',
    'Capacity',
    'Disability Accessible'
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, hive, child) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'VENUES',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Search Venue',
                          color: Colors.white,
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          onChanged: (value) {
                            hive.filterVenue(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 25),
                      CustomButton(
                        onPressed: viewTemplate,
                        text: 'View Template',
                        radius: 10,
                        color: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: () => importData(hive),
                        text: 'Import Venues',
                        radius: 10,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            if (hive.getFilteredVenue.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Text(
                    'No Venue Found',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: size.height - 216,
                child: CustomTable(
                  bottomAction: Row(
                    children: [
                      if (hive.getSelectedVenues.isNotEmpty)
                        CustomButton(
                          onPressed: () =>
                              deleteSelected(hive.getSelectedVenues),
                          text: 'Delete Selected',
                          color: Colors.red,
                          radius: 10,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                        ),
                      const SizedBox(width: 10),
                      CustomButton(
                        onPressed: clearVenues,
                        text: 'Clear Venues',
                        color: Colors.black,
                        radius: 10,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                      ),
                    ],
                  ),
                  arrowHeadColor: Colors.black,
                  dragStartBehavior: DragStartBehavior.start,
                  controller: _scrollController,
                  controller2: _scrollController2,
                  border: hive.getFilteredVenue.isNotEmpty
                      ? const TableBorder(
                          horizontalInside:
                              BorderSide(color: Colors.grey, width: 1),
                          top: BorderSide(color: Colors.grey, width: 1),
                          bottom: BorderSide(color: Colors.grey, width: 1))
                      : const TableBorder(),
                  dataRowHeight: 45,
                  source: VenueDataSource(context),
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  columnSpacing: 0,
                  horizontalMargin: 10,
                  columns: columns
                      .map((e) => DataColumn(
                            label: e.isEmpty
                                ? ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        minWidth: 50, maxWidth: 50),
                                    child: IconButton(
                                        onPressed: () {
                                          hive.addSelectedVenues(
                                              hive.getFilteredVenue);
                                        },
                                        icon: Icon(
                                          hive.getSelectedVenues.isEmpty
                                              ? Icons.check_box_outline_blank
                                              : hive.getFilteredVenue.length ==
                                                      hive.getSelectedVenues
                                                          .length
                                                  ? FontAwesomeIcons
                                                      .solidSquareCheck
                                                  : FontAwesomeIcons
                                                      .solidSquareMinus,
                                        )),
                                  )
                                : Text(
                                    e,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      );
    });
  }

  void importData(HiveListener hive) async {
    var excel = await ExcelService.readExcelFile();
    if (excel != null) {
      bool isFIleValid = ExcelService.validateExcelFIleByColumns(
        excel,
        Constant.venueExcelHeaderOrder,
      );
      if (isFIleValid) {
        CustomDialog.showLoading(message: 'Importing Data...Please Wait');
        try {
          ImportServices.importVenues(excel).then((value) {
            if (value == null) {
              CustomDialog.dismiss();
              CustomDialog.showError(message: 'Error Importing Data');
              return;
            } else if (value.isNotEmpty) {
              for (var element in value) {
                element.academicYear = hive.currentAcademicYear;
                HiveCache.addVenue(element);
              }
              var data = HiveCache.getVenues(hive.currentAcademicYear);
              hive.setVenueList(data);
              Provider.of<ConfigDataFlow>(context, listen: false)
                  .updateHasVenue(data);
              CustomDialog.dismiss();
              CustomDialog.showSuccess(message: 'Data Imported Successfully');
            } else {
              CustomDialog.dismiss();
              CustomDialog.showError(message: 'Error Importing Data');
            }
          });
        } catch (e) {
          CustomDialog.dismiss();
          CustomDialog.showError(message: 'Error Importing Data');
        }
      } else {
        CustomDialog.showError(message: 'Invalid Excel File Selected');
      }
    }
  }

  void viewTemplate() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fileName = '${appDocDir.path}/venues.xlsx';
    if (File(fileName).existsSync()) {
      CustomDialog.showInfo(
        onPressed: () => viewFile(fileName),
        message:
            'File with the name venues.xlsx already exist. Do you want to view it or overwrite it ?',
        buttonText: 'View Template',
        buttonText2: 'Overwrite',
        onPressed2: () => createTemplate(File(fileName)),
      );
    } else {
      createTemplate(File(fileName));
    }
  }

  deleteSelected(List<VenueModel> getSelectedVenues) {
    CustomDialog.showInfo(
        onPressed: () => delete(getSelectedVenues),
        message:
            'Are you sure you want to delete the selected Courses ? Note: This action is not reversible',
        buttonText: 'Yes|Delete');
  }

  delete(List<VenueModel> getSelectedVenues) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Deleting Venue...Please Wait');
    Provider.of<HiveListener>(context, listen: false)
        .deleteVenues(getSelectedVenues, context);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(message: 'Selected Venues Deleted Successfully');
  }

  void clearVenues() {
    CustomDialog.showInfo(
        onPressed: () => clear(),
        message:
            'Are you sure you want to clear all Venues ? Note: This action is not reversible',
        buttonText: 'Yes|Clear');
  }

  clear() {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Clearing Venues...Please Wait');
    Provider.of<HiveListener>(context, listen: false).clearVenues(context);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(message: 'Venues Cleared Successfully');
  }

  viewFile(String fileName) {
    try {
      CustomDialog.dismiss();
      OpenAppFile.open(fileName);
    } catch (e) {
      CustomDialog.showError(message: 'Error Opening File');
    }
  }

  createTemplate(File existingFile) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Creating Template...Please Wait');
    try {
      existingFile.createSync();
      var file = await ImportServices.templateClasses(existingFile);
      if (await file.exists()) {
        OpenAppFile.open(file.path);
        CustomDialog.dismiss();
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(message: 'Error Creating Template');
      }
    } catch (e) {
      CustomDialog.dismiss();
      CustomDialog.showError(message: 'Error Creating Template');
    }
  }
}
