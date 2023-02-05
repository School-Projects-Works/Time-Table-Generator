import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../Models/Table/TableModel.dart';

class TableItem extends StatefulWidget {
  const TableItem({super.key, this.venue, this.table});
  final String? venue;
  final TableModel? table;

  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
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
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            if (widget.table != null)
              Text(
                widget.table!.className == null ||
                        widget.table!.className!.isEmpty
                    ? "Liberal/African Studies"
                    : '${widget.table!.className ?? 'Liberal/African Studies'} (${widget.table!.classLevel ?? ''})',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            if (widget.table != null)
              Text(
                widget.table!.courseCode!,
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
            if (widget.table != null)
              Text(
                '(${widget.table!.courseTitle!})',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            if (widget.table != null)
              Text(
                '-${widget.table!.lecturerName!}-',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: secondaryColor.withOpacity(.5),
                    fontWeight: FontWeight.bold),
              ),
          ],
        ));
  }
}
