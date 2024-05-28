import 'package:aamusted_timetable_generator/features/departments/views/Data/class_tab.dart';
import 'package:aamusted_timetable_generator/features/departments/views/Data/course_tab.dart';
import 'package:aamusted_timetable_generator/features/departments/views/Data/lecturer_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class DataSection extends ConsumerStatefulWidget {
  const DataSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DataSectionState();
}

class _DataSectionState extends ConsumerState<DataSection> {
  List<fluent.Tab> tabs = [
    fluent.Tab(
      text: const Text('Clases'),
      semanticLabel: '',
      icon: const Icon(FontAwesomeIcons.chalkboardUser),
      body:  const ClassTab(),
    ),
    fluent.Tab(
      text: const Text('Courses'),
      semanticLabel: '',
      icon: const Icon(fluent.FluentIcons.book_answers),
      body: const CourseTab(),
    ),
    fluent.Tab(
      text: const Text('Lecturers'),
      semanticLabel: '',
      icon: const Icon(fluent.FluentIcons.user_clapper),
      body: const LecturerTab(),
    ),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return fluent.TabView(
      tabs: tabs,
      currentIndex: currentIndex,
      onChanged: (index) => setState(() => currentIndex = index),
      tabWidthBehavior: fluent.TabWidthBehavior.equal,
      closeButtonVisibility: fluent.CloseButtonVisibilityMode.never,
      showScrollButtons: true,
    );
  }



}