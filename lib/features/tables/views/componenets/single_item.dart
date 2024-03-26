import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';
import '../../provider/table_manupulation.dart';

// ignore: must_be_immutable
class SingleItem extends ConsumerStatefulWidget implements pw.Widget {
  SingleItem({
    Key? key,
    this.venue,
    this.table,
  }) : super(key: key);
  final String? venue;
  final TablesModel? table;

  @override
  ConsumerState<SingleItem> createState() => _SingleItemState();

  @override
  PdfRect? box;

  @override
  void debugPaint(pw.Context context) {
    // TODO: implement debugPaint
  }

  @override
  void layout(pw.Context context, pw.BoxConstraints constraints,
      {bool parentUsesSize = false}) {
    // TODO: implement layout
  }

  @override
  void paint(pw.Context context) {
    // TODO: implement paint
  }
}

class _SingleItemState extends ConsumerState<SingleItem> {
  bool onHover = false;
  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var pair = ref.watch(tablePairProvider);
    return InkWell(
      onHover: (value) {
        setState(() {
          onHover = value;
        });
      },
      onDoubleTap: widget.table == null
          ? null
          : () {
              ref.read(tablePairProvider.notifier).setTable1(null);
              ref.read(tablePairProvider.notifier).setTable2(null, ref);
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
                                            table: widget.table,
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
        if (pair.table1 == null || pair.table1 == widget.table) {
          if (pair.table1 == widget.table) {
            ref.read(tablePairProvider.notifier).setTable1(null);
          } else {
            ref.read(tablePairProvider.notifier).setTable1(widget.table);
          }
        } else if (pair.table2 == null || pair.table2 == widget.table) {
          if (pair.table2 == widget.table) {
            ref.read(tablePairProvider.notifier).setTable2(null, ref);
          } else {
            ref.read(tablePairProvider.notifier).setTable2(widget.table, ref);
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
                  alignment: widget.table == null
                      ? Alignment.centerLeft
                      : Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: widget.table == null
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      if (widget.venue != null)
                        Text(
                          widget.venue!,
                          textAlign: widget.table == null
                              ? TextAlign.start
                              : TextAlign.center,
                          style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      if (widget.table != null)
                        Text(
                          widget.table!.classId.isEmpty
                              ? "Liberal/African Studies (${widget.table!.classLevel})"
                              : '${widget.table!.className} (${widget.table!.classLevel})',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      if (widget.table != null)
                        Text(
                          widget.table!.courseCode!,
                          style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      if (widget.table != null)
                        Text(
                          '(${widget.table!.courseTitle})',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                              fontSize: 9,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      if (widget.table != null)
                        Text(
                          '(${widget.table!.lecturerName})',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                    ],
                  )),
            ),
            if (widget.table != null)
              Positioned(
                right: 0,
                top: 0,
                left: 0,
                bottom: 0,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: onHover && pair.table1 != widget.table
                          ? Colors.black38
                          : pair.table1 == widget.table
                              ? Colors.black87
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: pair.table1 == widget.table
                        ? Center(
                            child: Text(
                              'Click on another table itme to swap',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          )
                        : null),
              ),
          ],
        ),
      ),
    );
  }
}
