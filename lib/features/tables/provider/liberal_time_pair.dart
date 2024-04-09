//! generate a liberal course time pair
//? for each liberal course i add a time pair(Day and period)

import 'package:aamusted_timetable_generator/features/tables/data/ltp_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../configurations/data/config/config_model.dart';
import '../../configurations/provider/config_provider.dart';
import '../../main/provider/main_provider.dart';

final liberalTimePairProvider= StateNotifierProvider<LiberalTimePairProvider,List<LTPModel>>((ref)=>LiberalTimePairProvider());


class LiberalTimePairProvider extends StateNotifier<List<LTPModel>>{
  LiberalTimePairProvider():super([]);

  void generateLTP(WidgetRef ref){
    //! get the configuration data
    var config = ref.watch(configurationProvider);
    //! here i extract the data from the config (days, period)
    var data = StudyModeModel.fromMap(config.regular);
    var libs = ref.watch(liberalsDataProvider);
    //! i filter the regular and evening libs
    var regLibs = libs
        .where((element) =>
            element.studyMode!.toLowerCase().replaceAll(' ', '') ==
            'regular'.toLowerCase())
        .toList();
        //? only evening liberal course
    var evenLibs = libs
        .where((element) =>
            element.studyMode!.toLowerCase().replaceAll(' ', '') ==
            'evening'.toLowerCase())
        .toList();
//? i create a list of LTPModel for regular 
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
    //? i create a list of LTPModel for evening
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
    state = ltp;
  }
}