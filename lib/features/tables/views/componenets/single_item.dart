import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:aamusted_timetable_generator/features/tables/data/tables_model.dart';

// ignore: must_be_immutable
class SingleItem extends StatefulWidget implements pw.Widget {
  SingleItem({
    Key? key,
    this.venue,
    this.table,
  }) : super(key: key);
  final String? venue;
  final TablesModel? table;

  @override
  State<SingleItem> createState() => _SingleItemState();
  
  @override
  PdfRect? box;
  
  @override
  void debugPaint(pw.Context context) {
    // TODO: implement debugPaint
  }
  
  @override
  void layout(pw.Context context, pw.BoxConstraints constraints, {bool parentUsesSize = false}) {
    // TODO: implement layout
  }
  
  @override
  void paint(pw.Context context) {
    // TODO: implement paint
  }

}

class _SingleItemState extends State<SingleItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 260,
        height: 100,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        alignment:
            widget.table == null ? Alignment.centerLeft : Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: widget.table == null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            if (widget.venue != null)
              Text(
                widget.venue!,
                textAlign:
                    widget.table == null ? TextAlign.start : TextAlign.center,
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            if (widget.table != null)
              Text(
                widget.table!.className.isEmpty
                    ? "Liberal/African Studies (${widget.table!.classLevel })"
                    : '${widget.table!.className} (${widget.table!.classLevel })',
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
        ));
  }
}
