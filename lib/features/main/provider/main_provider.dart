import 'package:aamusted_timetable_generator/features/configurations/usecase/config_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/constants/constant_data.dart';
import '../../configurations/provider/config_provider.dart';


final academicYearProvider = StateProvider<String>((ref) => academicYears.first);
final semesterProvider = StateProvider<String>((ref) => semesters.first);
final studentTypeProvider = StateProvider<String>((ref) => studentTypes.first);


final dbDataFutureProvider = FutureProvider<void>((ref) async {
   String academicYear = ref.watch(academicYearProvider);
  String academicSemester = ref.watch(semesterProvider);
  String targetedStudents = ref.watch(studentTypeProvider);

  
 
});


