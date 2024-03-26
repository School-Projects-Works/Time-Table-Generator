import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_input.dart';
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
                            child: SizedBox(
                              width: 110,
                              child: DropdownButton<String>(
                                dropdownColor: Colors.white,
                                value: ref.watch(filterProvider),
                                onChanged: (newValue) {
                                  ref.read(filterProvider.notifier).state =
                                      newValue!;
                                      ref
                                      .read(filteredTableProvider.notifier)
                                      .filter('', ref);
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
                          ),
                          if (ref.watch(filterProvider) != null &&
                              ref.watch(filterProvider) != 'All')
                            SizedBox(
                              width: 300,
                              child: CustomTextFields(
                                hintText: ref.watch(filterProvider) ==
                                        'Lecturer'
                                    ? 'Enter Lecturer ID or Name'
                                    : ref.watch(filterProvider) == 'Class'
                                        ? 'Enter Class ID or Name'
                                        : ref.watch(filterProvider) == 'Course'
                                            ? 'Enter Course Code or Title'
                                            : ref.watch(filterProvider) ==
                                                    'Venue'
                                                ? 'Enter Venue ID or Name'
                                                : ref.watch(filterProvider) ==
                                                        'Day'
                                                    ? 'Enter Day'
                                                    : '',
                                onChanged: (value) {
                                  if(value.isNotEmpty){
                                    ref.read(filteredTableProvider.notifier).filter(value,ref);
                                  }
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                )),
                const SizedBox(
                  width: 10,
                ),
                CustomButton(
                    text: 'Generate Table',
                    radius: 10,
                    color: primaryColor,
                    onPressed: () {
                      ref.read(vtpProvider.notifier).generateVTP(ref);
                      ref.read(lccProvider.notifier).generateLCC(ref);
                      ref.read(ltpProvider.notifier).generateLTP(ref);
                      ref.read(tableGenProvider.notifier).generateTables(ref);
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
