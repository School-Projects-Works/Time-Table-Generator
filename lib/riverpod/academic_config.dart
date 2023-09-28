import 'package:aamusted_timetable_generator/global/constants/academic_years.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final academicYearProvider = StateProvider<String>((ref) => academicYears.first);
final semesterProvider = StateProvider<String>((ref) => 'Semester One');
final studentTypeProvider = StateProvider<String>((ref) => 'Reguler (inc Masters)');