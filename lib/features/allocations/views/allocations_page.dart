
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widget/custom_button.dart';
import 'tabs/classes_section.dart';
import 'tabs/courses_tabs.dart';
import 'tabs/lecturers_tab.dart';

class AllocationPage extends ConsumerStatefulWidget {
  const AllocationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllocationPageState();
}

class _AllocationPageState extends ConsumerState<AllocationPage> {

  List<Tab> tabs = [
    Tab(
      text: const Text('Clases'),
      semanticLabel: '',
      icon: const Icon(FontAwesomeIcons.chalkboardUser),
      body: const ClassesTab(),
    ),
    Tab(
      text: const Text('Courses'),
      semanticLabel: '',
      icon:  const Icon(FluentIcons.book_answers),
      body: const CoursesTabs(),
    ),
     Tab(
      text: const Text('Lecturers'),
      semanticLabel: '',
      icon:  const Icon(FluentIcons.user_clapper),
      body: const LecturersTab(),
    ),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text('Course Allocations'.toUpperCase(),
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  CustomButton(
                    icon: FluentIcons.import,
                    text: 'Import Allocations' ,                                       
                      onPressed: () {
                        //Todo import allocations
                      }),
                  const SizedBox(width: 10),
                  CustomButton(
                    icon: FluentIcons.file_template,
                    text: 'Download Template' ,
                      onPressed: () {
                        // ref
                        //     .read(excelFileProvider.notifier)
                        //     .generateAllocationExcelFile(context);
                      }),
                  const SizedBox(width: 10),
                  FilledButton(
                      //red button
                      style: ButtonStyle(
                          backgroundColor:
                              ButtonState.all(Colors.red.withOpacity(.8))),
                      child: const Text('Clear All'),
                      onPressed: () {
                        //Todo clear all
                      }),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //tab view

            Expanded(
              child: TabView(
                tabs: tabs,
                currentIndex: currentIndex,
                onChanged: (index) => setState(() => currentIndex = index),
                tabWidthBehavior: TabWidthBehavior.equal,
                closeButtonVisibility: CloseButtonVisibilityMode.never,
                showScrollButtons: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}