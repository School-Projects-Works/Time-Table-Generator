import 'package:aamusted_timetable_generator/features/configurations/data/config/config_model.dart';
import 'package:aamusted_timetable_generator/features/configurations/provider/config_provider.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/ltp_model.dart';

final ltpProvider =
    StateNotifierProvider<LTPProvider, List<LTPModel>>((ref) => LTPProvider());

class LTPProvider extends StateNotifier<List<LTPModel>> {
  LTPProvider() : super([]);

  void generateLTP(WidgetRef ref) {
    var config = ref.watch(configurationProvider);
    var data = StudyModeModel.fromMap(config.regular);
    var libs = ref.watch(liberalsDataProvider);
    var regLibs = libs
        .where((element) =>
            element.studyMode!.toLowerCase().replaceAll(' ', '') ==
            'regular'.toLowerCase())
        .toList();
    var evenLibs = libs
        .where((element) =>
            element.studyMode!.toLowerCase().replaceAll(' ', '') ==
            'evening'.toLowerCase())
        .toList();

    List<LTPModel> ltp = [];
    for (var regLib in regLibs) {
      var id = '${regLib.id}${regLib.studyMode}'.trim().replaceAll(' ', '').toLowerCase().hashCode.toString();
      LTPModel ltpm = LTPModel(
        id: id,
        lecturerId: regLib.lecturerId!,
        lecturerName: regLib.lecturerName!,
        courseId: regLib.id!,
        courseCode: regLib.code!,
        courseTitle: regLib.title!,
        period: data.regLibPeriod!['period'],
        periodMap: data.regLibPeriod!,
        day: data.regLibDay!,
        level: data.regLibLevel!,
        studyMode: regLib.studyMode!,
        year: config.year!,
        semester: config.semester!,
      );
      ltp.add(ltpm);
    }
    for(var evenLib in evenLibs){
      var id = '${evenLib.id}${evenLib.studyMode}'.trim().replaceAll(' ', '').toLowerCase().hashCode.toString();
      LTPModel ltpm = LTPModel(
        id: id,
        lecturerId: evenLib.lecturerId!,
        lecturerName: evenLib.lecturerName!,
        courseId: evenLib.id!,
        courseCode: evenLib.code!,
        courseTitle: evenLib.title!,
        period: 'period 5',
        periodMap: {},
        day: data.evenLibDay!,
        level: data.evenLibLevel!,
        studyMode: evenLib.studyMode!,
        year: config.year!,
        semester: config.semester!,
      );
      ltp.add(ltpm);
    }
   // print('Total LTP: ${ltp.length}');
    state = [...ltp];
  }

}
