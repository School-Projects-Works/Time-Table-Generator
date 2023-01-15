import 'package:aamusted_timetable_generator/Components/BreathingWidget.dart';
import 'package:aamusted_timetable_generator/Components/CustomDropDown.dart';
import 'package:aamusted_timetable_generator/SateManager/ConfigDataFlow.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CustomButton.dart';
import '../../../../Components/CustomTable.dart';
import '../../../../Components/SmartDialog.dart';
import '../../../../Components/TextInputs.dart';
import '../../../../Constants/Constant.dart';
import '../../../../Models/Course/LiberialModel.dart';
import '../../../../SateManager/HiveCache.dart';
import '../../../../SateManager/HiveListener.dart';
import '../../../../Services/FileService.dart';
import '../../../../Styles/colors.dart';
import 'LiberialDataScource.dart';

class LiberalPage extends StatefulWidget {
  const LiberalPage({Key? key}) : super(key: key);

  @override
  State<LiberalPage> createState() => _LiberalPageState();
}

class _LiberalPageState extends State<LiberalPage> {
  List<String> columns = [
    '',
    'Code',
    'Title',
    'Lecturer',
    'Lecturer Email',
  ];
  final _scrollController = ScrollController();
  final _scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, hive, child) {
      return Consumer<ConfigDataFlow>(builder: (context, config, child) {
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
                    'LIBERIAL/AFRICAN STUDIES',
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
                            hintText: 'Search Liberial Course',
                            color: Colors.white,
                            suffixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            onChanged: (value) {
                              hive.filterCourses(value);
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
                          text: 'Import Courses',
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
              if (hive.getLiberials.isNotEmpty)
                config.getConfigurations.liberialCourseDay == null ||
                        config.getConfigurations.liberialCoursePeriod == null
                    ? BreathingWidget(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        'Select  Day on which the Liberial/African Studies courses will be held:',
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        )),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 250,
                                      child: CustomDropDown(
                                          onChanged: changeLiberialDay,
                                          hintText: 'Select day',
                                          items: config.getConfigurations.days!
                                              .map((e) => DropdownMenuItem(
                                                  value: e['day'],
                                                  child: Text(e['day'])))
                                              .toList(),
                                          color: Colors.white))
                                ],
                              )),
                              const SizedBox(width: 20),
                              Expanded(
                                  child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        'Select  Period on which the Liberial/African Studies courses will be held:',
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        )),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 250,
                                      child: CustomDropDown(
                                          hintText: 'Select period',
                                          onChanged: changeLiberialPeriod,
                                          items: config
                                              .getConfigurations.periods!
                                              .map((e) => DropdownMenuItem(
                                                  value: e['period'],
                                                  child: Text(e['period'])))
                                              .toList(),
                                          color: Colors.white))
                                ],
                              ))
                            ],
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      'Select  Day on which the Liberial/African Studies courses will be held:',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      )),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: 250,
                                    child: CustomDropDown(
                                        onChanged: changeLiberialDay,
                                        hintText: 'Select day',
                                        items: config.getConfigurations.days!
                                            .map((e) => DropdownMenuItem(
                                                value: e['day'],
                                                child: Text(e['day'])))
                                            .toList(),
                                        color: Colors.white))
                              ],
                            )),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      'Select  Period on which the Liberial/African Studies courses will be held:',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      )),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: 250,
                                    child: CustomDropDown(
                                        hintText: 'Select period',
                                        onChanged: changeLiberialPeriod,
                                        items: config.getConfigurations.periods!
                                            .map((e) => DropdownMenuItem(
                                                value: e['period'],
                                                child: Text(e['period'])))
                                            .toList(),
                                        color: Colors.white))
                              ],
                            ))
                          ],
                        ),
                      ),
              if (hive.getLiberials.isNotEmpty) const SizedBox(height: 10),
              if (hive.getFilteredLiberial.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Text(
                      'No Liberal/African Studies Courses Found',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: size.height - 285,
                  child: CustomTable(
                      bottomAction: Row(
                        children: [
                          if (hive.getSelectedLiberials.isNotEmpty)
                            CustomButton(
                                onPressed: () =>
                                    deleteSelected(hive.getSelectedLiberials),
                                text: 'Delete Selected',
                                color: Colors.red,
                                radius: 10,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6)),
                          const SizedBox(width: 10),
                          CustomButton(
                            onPressed: () => clearCourses(),
                            text: 'Clear Courses',
                            color: Colors.black,
                            radius: 10,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 6),
                          )
                        ],
                      ),
                      arrowHeadColor: Colors.black,
                      dragStartBehavior: DragStartBehavior.start,
                      controller: _scrollController,
                      controller2: _scrollController2,
                      showFirstLastButtons: true,
                      border: hive.getFilteredLiberial.isNotEmpty
                          ? const TableBorder(
                              horizontalInside:
                                  BorderSide(color: Colors.grey, width: 1),
                              top: BorderSide(color: Colors.grey, width: 1),
                              bottom: BorderSide(color: Colors.grey, width: 1))
                          : const TableBorder(),
                      dataRowHeight: 45,
                      showCheckboxColumn: false,
                      source: LiberialDataScource(
                        context,
                      ),
                      rowsPerPage: hive.getFilteredLiberial.length > 10
                          ? 10
                          : hive.getFilteredLiberial.isEmpty
                              ? 1
                              : hive.getFilteredLiberial.length,
                      columns: columns
                          .map((e) => DataColumn(
                                label: e.isEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          hive.addSelectedLiberials(
                                              hive.getFilteredLiberial);
                                        },
                                        icon: Icon(
                                          hive.getSelectedLiberials.isEmpty
                                              ? Icons.check_box_outline_blank
                                              : hive.getFilteredLiberial
                                                          .length ==
                                                      hive.getSelectedLiberials
                                                          .length
                                                  ? FontAwesomeIcons
                                                      .solidSquareCheck
                                                  : FontAwesomeIcons
                                                      .solidSquareMinus,
                                        ))
                                    : Text(
                                        e,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                              ))
                          .toList()),
                ),
            ],
          ),
        );
      });
    });
  }

  void viewTemplate() async {
    CustomDialog.showLoading(message: 'Creating Template...Please Wait');
    try {
      var file = await ImportServices.tamplateLiberial();
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

  void importData(HiveListener hive) async {
    var excel = await ExcelService.readExcelFile();
    if (excel != null) {
      bool isFIleValid = ExcelService.validateExcelFIleByColumns(
        excel,
        Constant.liberalExcelHeaderOrder,
      );
      if (isFIleValid) {
        CustomDialog.showLoading(message: 'Importing Data...Please Wait');
        try {
          ImportServices.importLiberial(excel).then((value) {
            if (value == null) {
              CustomDialog.dismiss();
              CustomDialog.showError(message: 'Error Importing Data');
              return;
            } else if (value.isNotEmpty) {
              for (var element in value) {
                element.academicYear = hive.currentAcademicYear;
                HiveCache.addLiberial(element);
              }
              var data = HiveCache.getLiberials(hive.currentAcademicYear);
              hive.setLiberialList(data);
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

  void clearCourses() {
    CustomDialog.showInfo(
      message:
          'Are you sure yo want to delete all Liberial/African Studies Courses? Note: This action is not reversable',
      buttonText: 'Yes|Clear',
      onPressed: refresh,
    );
  }

  void refresh() {
    CustomDialog.dismiss();
    CustomDialog.showLoading(
        message: 'Deleting Liberial/African Studies Courses...Please Wait');
    Provider.of<HiveListener>(context, listen: false).clearLiberial();
    CustomDialog.dismiss();
    CustomDialog.showSuccess(
        message: 'Liberial/African Studies Courses Cleared Successfully');
  }

  deleteSelected(List<LiberialModel> getSelectedLiberials) {
    CustomDialog.showInfo(
        onPressed: () => delete(getSelectedLiberials),
        message:
            'Are you sure you want to delete the selected Liberial/African Studies Courses ? Note: This action is not reversable',
        buttonText: 'Yes|Delect');
  }

  delete(List<LiberialModel> getSelectedLiberial) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(
        message: 'Deleting Liberial/African Studies Courses...Please Wait');
    Provider.of<HiveListener>(context, listen: false)
        .deleteLiberial(getSelectedLiberial);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(
        message:
            'Selected Liberial/African Studies Courses Deleted Successfully');
  }

  changeLiberialDay(p1) {
    if (p1 != null) {
      Provider.of<ConfigDataFlow>(context, listen: false).setLiberialDay(p1);
    }
  }

  changeLiberialPeriod(p1) {
    if (p1 != null) {
      Provider.of<ConfigDataFlow>(context, listen: false).setLiberialPeriod(p1);
    }
  }
}
