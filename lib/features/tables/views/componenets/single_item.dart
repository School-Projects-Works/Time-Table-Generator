import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_input.dart';
import 'package:aamusted_timetable_generator/features/tables/data/empty_model.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/class_course/lecturer_course_class_pair.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/liberay/liberal_time_pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import '../../provider/table_manupulation.dart';
import '../export/unasigned_list.dart';

// ignore: must_be_immutable
class SingleItem extends ConsumerStatefulWidget implements pw.Widget {
  SingleItem({
    super.key,
    this.venue,
    this.table,
    this.empty,
  });
  final String? venue;
  final TablesModel? table;
  final EmptyModel? empty;

  @override
  ConsumerState<SingleItem> createState() => _SingleItemState();

  @override
  PdfRect? box;

  @override
  void debugPaint(pw.Context context) {}

  @override
  void layout(pw.Context context, pw.BoxConstraints constraints,
      {bool parentUsesSize = false}) {}

  @override
  void paint(pw.Context context) {}
}

class _SingleItemState extends ConsumerState<SingleItem> {
  bool onHover = false;
  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (widget.venue != null) {
      return _buildVenueItem(venue: widget.venue);
    } else if (widget.empty != null) {
      return _buildEmptyItem(empty: widget.empty);
    } else if (widget.table != null) {
      return _buildTableItem(table: widget.table);
    } else {
      return _buildEmptyItem(empty: widget.empty);
    }
  }

  Widget _buildVenueItem({String? venue}) {
    return Container(
        width: 260,
        height: 100,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue!,
              textAlign: TextAlign.start,
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ));
  }

  Widget _buildTableItem({TablesModel? table}) {
    var pair = ref.watch(tablePairProvider);
    return InkWell(
      onHover: (value) {
        setState(() {
          onHover = value;
        });
      },
      onDoubleTap: () {
        ref.read(tablePairProvider.notifier).setTable1(null);
        ref.read(tablePairProvider.notifier).setTable2(ref: ref);
        //edit table
        CustomDialog.showCustom(
            width: 400,
            height: 285,
            ui: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text('Enter New Lecturer for this item',
                              style: getTextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                            onPressed: () {
                              CustomDialog.dismiss();
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      thickness: 3,
                      color: primaryColor,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFields(
                      hintText: 'Enter new lecturer ID',
                      controller: idController,
                      prefixIcon: FontAwesomeIcons.idCard,
                      validator: (id) {
                        if (id!.isEmpty) {
                          return 'Please enter a valid lecturer ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFields(
                      hintText: 'Enter new lecturer name',
                      controller: nameController,
                      prefixIcon: FontAwesomeIcons.user,
                      validator: (name) {
                        if (name!.isEmpty) {
                          return 'Please enter a valid lecturer name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomButton(
                          radius: 15,
                          color: primaryColor,
                          text: 'Update',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              ref
                                  .read(tablePairProvider.notifier)
                                  .changeLecturer(
                                      table: table,
                                      id: idController.text,
                                      name: nameController.text,
                                      ref: ref);
                            }
                          }),
                    )
                  ],
                ),
              ),
            ));
      },
      onTap: () {
        if (pair.table1 == null || pair.table1 == table) {
          if (pair.table1 == table) {
            ref.read(tablePairProvider.notifier).setTable1(null);
          } else {
            ref.read(tablePairProvider.notifier).setTable1(table);
          }
        } else if (pair.table2 == null || pair.table2 == table) {
          if (pair.table2 == table) {
            ref.read(tablePairProvider.notifier).setTable2(ref: ref);
          } else {
            ref
                .read(tablePairProvider.notifier)
                .setTable2(table: table, ref: ref);
          }
        }
      },
      child: SizedBox(
        width: 260,
        height: 100,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              left: 0,
              bottom: 0,
              child: Container(
                  width: 260,
                  height: 100,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            table!.classId.isEmpty
                                ? "Liberal/African Studies"
                                : table.className,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '(${table.classLevel})',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        table.courseCode!,
                        style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(${table.courseTitle})',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                            fontSize: 10,
                            color: primaryColor,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '-${table.lecturerName}-',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
            Positioned(
              right: 0,
              top: 0,
              left: 0,
              bottom: 0,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: onHover && pair.table1 != table
                        ? Colors.black38
                        : pair.table1 == table
                            ? Colors.black87
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: pair.table1 == table
                      ? Center(
                          child: Text(
                            'Click on another table itme to swap',
                            textAlign: TextAlign.center,
                            style:
                                getTextStyle(color: Colors.white, fontSize: 13),
                          ),
                        )
                      : null),
            ),
          ],
        ),
      ),
    );
  }

  bool _openEmptyMenu = false;
  Widget _buildEmptyItem({EmptyModel? empty}) {
    var pair = ref.watch(tablePairProvider);
    return InkWell(
      onTap: () {
        if (pair.table1 != null) {
          ref
              .read(tablePairProvider.notifier)
              .moveToEmpty(ref: ref, empty: empty);
        } else {
          setState(() {
            _openEmptyMenu = !_openEmptyMenu;
          });
        }
      },
      child: SizedBox(
        width: 260,
        height: 100,
        child: Stack(
          children: [
            Positioned(
                right: 0,
                top: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  width: 260,
                  height: 100,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  alignment: Alignment.center,
                )),
            if (_openEmptyMenu)
              Positioned(
                right: 0,
                top: 0,
                left: 0,
                bottom: 0,
                child: Container(
                    width: 260,
                    height: 100,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              var unAsignedLTP = ref
                                  .watch(liberalTimePairProvider)
                                  .where(
                                      (element) => element.isAsigned == false)
                                  .toList();
                              var unAssignedLCCP = ref
                                  .watch(lecturerCourseClassPairProvider)
                                  .where(
                                      (element) => element.isAsigned == false)
                                  .toList();
                              if (unAsignedLTP.isNotEmpty ||
                                  unAssignedLCCP.isNotEmpty) {
                                ref
                                    .read(enptyAssignProvider.notifier)
                                    .setEmpty(empty!);
                                CustomDialog.showCustom(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    height: 650,
                                    ui: const UnassignedList());
                              } else {
                                CustomDialog.showError(
                                    message:
                                        'No unassigned lecturer or course to available');
                              }
                            },
                            label: const Text(
                              'Assign Class',
                            ),
                            icon: const Icon(
                              FontAwesomeIcons.chalkboardUser,
                              size: 18,
                            )),
                        const SizedBox(height: 5),
                        Text(
                          'Click empty space to close menue',
                          style:
                              getTextStyle(color: secondaryColor, fontSize: 11),
                        ),
                      ],
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
