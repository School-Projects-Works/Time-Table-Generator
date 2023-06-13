import 'package:aamusted_timetable_generator/Components/smart_dialog.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../Models/Table/table_item_model.dart';
import '../../../../../SateManager/hive_listener.dart';

class TableItem extends StatefulWidget {
  const TableItem({super.key, this.venue, this.table, this.metaData});
  final String? venue;
  final TableItemModel? table;
  final Map<String, dynamic>? metaData;

  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<HiveListener>(builder: (context, hive, child) {
      return InkWell(
        onTap: widget.venue == null ? () {} : null,
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        child: Container(
            width: 260,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            child: Stack(
              children: [
                if (widget.table != null ||
                    (widget.table == null &&
                        widget.venue == null &&
                        hive.selectedItem != null))
                  if (widget.venue == null &&
                      isHovered &&
                      (hive.getSelectItem == null ||
                          hive.getSelectItem != widget.table))
                    Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 260,
                          alignment: Alignment.topRight,
                          child: Row(
                            children: [
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Tooltip(
                                  message: 'Swap',
                                  child: InkWell(
                                    onTap: () {
                                      if (hive.getSelectItem == null) {
                                        hive.setSelectedItem(widget.table);
                                      } else {
                                        TableItemModel temp = TableItemModel();
                                        if (widget.table == null) {
                                          temp.venue =
                                              widget.metaData!['venue'];
                                          temp.day = widget.metaData!['day'];
                                          temp.period =
                                              widget.metaData!['period'];
                                          temp.periodMap =
                                              widget.metaData!['periodMap'];
                                          temp.venueId =
                                              widget.metaData!['venueId'];
                                        } else {
                                          temp = widget.table!;
                                        }
                                        CustomDialog.showInfo(
                                            message:
                                                'Are you sure you want to swap ${hive.getSelectItem!.courseCode} with ${temp.courseCode ?? 'the Blank sport'}? ',
                                            buttonText: 'Swap',
                                            onPressed: () {
                                              hive.swapTableItems(
                                                  hive.getSelectItem!, temp);
                                              hive.setSelectedItem(null);
                                              CustomDialog.dismiss();
                                            });
                                      }
                                    },
                                    child: const Icon(
                                      Icons.swap_horiz,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                Container(
                  width: 260,
                  alignment: widget.table == null
                      ? Alignment.centerLeft
                      : Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
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
                    ),
                  ),
                ),
                if ((hive.getSelectItem != null &&
                    hive.getSelectItem == widget.table))
                  Container(
                    width: 260,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
              ],
            )),
      );
    });
  }
}
