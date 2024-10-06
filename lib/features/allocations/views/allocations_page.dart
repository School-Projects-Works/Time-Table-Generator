import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../config/theme/theme.dart';
import '../../../core/widget/custom_button.dart';
import '../../main/provider/main_provider.dart';
import '../provider/allocation_template_provider.dart';
import 'tabs/classes_section.dart';
import 'tabs/courses_tabs.dart';
import 'tabs/lecturers_tab.dart';

class AllocationPage extends ConsumerStatefulWidget {
  const AllocationPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllocationPageState();
}

class _AllocationPageState extends ConsumerState<AllocationPage> {
  List<fluent.Tab> tabs = [
    fluent.Tab(
      text: const Text('Clases'),
      semanticLabel: '',
      icon: const Icon(FontAwesomeIcons.chalkboardUser),
      body: const ClassesTab(),
    ),
    fluent.Tab(
      text: const Text('Courses'),
      semanticLabel: '',
      icon: const Icon(fluent.FluentIcons.book_answers),
      body: const CoursesTabs(),
    ),
    fluent.Tab(
      text: const Text('Lecturers'),
      semanticLabel: '',
      icon: const Icon(fluent.FluentIcons.user_clapper),
      body: const LecturersTab(),
    ),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var classes = ref.watch(classesDataProvider);
    //get unique departments
    var departments = classes.map((e) => e.department).toSet().toList();
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
                      style: getTextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  CustomButton(
                      icon: fluent.FluentIcons.import,
                      color: Colors.green,
                      radius: 10,
                      text: 'Import Allocations',
                      onPressed: () {
                        ref
                            .read(allocationTemplateProvider.notifier)
                            .importAllocations(ref);
                      }),
                  const SizedBox(width: 10),
                  CustomButton(
                      icon: fluent.FluentIcons.file_template,
                      radius: 10,
                      text: 'Download Template',
                      onPressed: () {
                        ref
                            .read(allocationTemplateProvider.notifier)
                            .downloadTemplate();
                      }),
                  const SizedBox(width: 10),
                  //pop up menu
                  PopupMenuButton(
                    itemBuilder: (_) => ['All', ...departments]
                        .map((e) => PopupMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onSelected: (value) {
                      //clear all allocations
                      CustomDialog.showInfo(
                          message:
                              'Are you sure you want to clear all allocations? This action cannot be undone',
                          buttonText: 'Yes| Clear All',
                          onPressed: () {
                            //clear all allocations
                            ref
                                .read(allocationTemplateProvider.notifier)
                                .clearAllAllocations(ref, value);
                          });
                    },
                    child: CustomButton(
                        //red button
                        color: Colors.red,
                        text: 'Clear All Allocations',
                        radius: 10,
                        onPressed: () {}),
                  ),

                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //tab view

            Expanded(
              child: fluent.TabView(
                tabs: tabs,
                currentIndex: currentIndex,
                onChanged: (index) => setState(() => currentIndex = index),
                tabWidthBehavior: fluent.TabWidthBehavior.equal,
                closeButtonVisibility: fluent.CloseButtonVisibilityMode.never,
                showScrollButtons: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
