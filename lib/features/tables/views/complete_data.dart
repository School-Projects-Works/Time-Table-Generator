import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:badges/badges.dart' as badges;
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/table_gen_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/views/componenets/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import '../../../config/theme/theme.dart';
import '../provider/lib_gen_provider.dart';
import '../provider/table_generation_provider.dart';
import 'export/export_page.dart';
import 'filter_box.dart';

class CompleteDataPage extends ConsumerStatefulWidget {
  const CompleteDataPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompleteDataPageState();
}

class _CompleteDataPageState extends ConsumerState<CompleteDataPage> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var table = ref.watch(filteredTableProvider);
    var size = MediaQuery.of(context).size;

    return Container(
      color: Colors.grey.withOpacity(.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Generated Tables'.toUpperCase(),
                    style: getTextStyle(
                        fontSize: size.width * .018,
                        fontWeight: FontWeight.bold)),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //filter combo box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Filter by: ',
                              style: getTextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              value: ref.watch(filterProvider),
                              onChanged: (newValue) {
                                ref.read(filterProvider.notifier).state =
                                    newValue!;
                                if (newValue == 'All') {
                                  ref
                                      .read(filteredTableProvider.notifier)
                                      .filter('', ref);
                                } else {
                                  CustomDialog.showCustom(
                                      width: 400,
                                      height: 250,
                                      ui: TableFilterBox(newValue.toString()));
                                }
                              },
                              items: <String>[
                                'All',
                                'Lecturer',
                                'Class',
                                'Course',
                                'Venue',
                                'Day'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: getTextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {},
                    child: Card(
                      elevation: 6,
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: -10, end: -12),
                            showBadge: true,
                            ignorePointer: false,
                            onTap: () {},
                            badgeContent: Text('40',
                                style: getTextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal)),
                            badgeAnimation:
                                const badges.BadgeAnimation.rotation(
                              animationDuration: Duration(seconds: 1),
                              colorChangeAnimationDuration:
                                  Duration(seconds: 1),
                              loopAnimation: false,
                              curve: Curves.fastOutSlowIn,
                              colorChangeAnimationCurve: Curves.easeInCubic,
                            ),
                            badgeStyle: badges.BadgeStyle(
                              shape: badges.BadgeShape.square,
                              badgeColor: Colors.red,
                              padding: const EdgeInsets.all(2),
                              borderRadius: BorderRadius.circular(4),
                              elevation: 0,
                            ),
                            child: Text('Unasigned',
                                style: getTextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomButton(
                    text: 'Generate Table',
                    radius: 10,
                    color: primaryColor,
                    onPressed: () {
                      // check if venue, class, course, lecturer, and day is not empty
                      if (ref.watch(venuesDataProvider).isEmpty) {
                        CustomDialog.showError(
                          message: 'There is no venues in the system',
                        );
                        return;
                      } else if (ref.watch(liberalsDataProvider).isEmpty &&
                          (ref.watch(coursesDataProvider).isEmpty ||
                              ref.watch(lecturersDataProvider).isEmpty)) {
                        CustomDialog.showError(
                          message:
                              'There is no courses or lecturers in the system',
                        );
                        return;
                      } else if (ref.watch(classesDataProvider).isEmpty) {
                        CustomDialog.showError(
                          message: 'There is no classes in the system',
                        );
                        return;
                      } else {
                        //show warning message to generate table
                        CustomDialog.showInfo(
                            message:
                                'This will generate a new table and overwrite any existing one. Do you want to proceed?',
                            buttonText: 'Generate',
                            onPressed: () {
                              ref.read(vtpProvider.notifier).generateVTP(ref);
                              ref.read(lccProvider.notifier).generateLCC(ref);
                              ref.read(ltpProvider.notifier).generateLTP(ref);
                              ref
                                  .read(tableGenProvider.notifier)
                                  .generateTables(ref);
                            });
                      }
                    }),
                const SizedBox(
                  width: 10,
                ),
                if (ref.watch(tableDataProvider).isNotEmpty)
                  CustomButton(
                      text: 'Export Table',
                      radius: 10,
                      color: secondaryColor,
                      onPressed: () {
                        CustomDialog.showCustom(
                            width: MediaQuery.of(context).size.width * .9,
                            height: MediaQuery.of(context).size.height * .9,
                            ui: const ExportPage());
                      }),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Column(children: [
                Expanded(
                    child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: table.isEmpty
                            ? Text(
                                'Notable generated yet',
                                style: GoogleFonts.nunito(),
                              )
                            : const TableWidget()))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
