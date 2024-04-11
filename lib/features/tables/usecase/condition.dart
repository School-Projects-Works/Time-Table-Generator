import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../configurations/provider/config_provider.dart';
import '../../main/provider/main_provider.dart';

class IncompleteConditions {
  final WidgetRef ref;

  IncompleteConditions({required this.ref});

  bool allocationExists() {
    return ref.watch(classesDataProvider).isNotEmpty &&
        ref.watch(coursesDataProvider).isNotEmpty &&
        ref.watch(lecturersDataProvider).isNotEmpty;
  }

  bool venueExists() {
    var venues = ref.watch(venuesDataProvider);
    return venues.isNotEmpty;
  }

  bool configExists() {
    return ref.watch(configProvider).id != null;
  }

  bool oneStudyModeExists() {
    var config = ref.watch(configProvider);
    var regularExists = config.days.isNotEmpty;
    return regularExists;
  }

  bool regularLibConfigExists() {
    var config = ref.watch(configProvider);
    var regularExists = config.days.isNotEmpty;
    var listRegularLib = ref
        .watch(liberalsDataProvider)
        .where((element) => element.studyMode!.toLowerCase() == 'regular')
        .toList();
    return !regularExists ||
        listRegularLib.isEmpty ||
        (config.regLibDay != null &&
                config.regLibPeriod != null) &&
            (config.regLibDay!.isNotEmpty &&
                config.regLibPeriod!.isNotEmpty &&
                config.regLibLevel!.isNotEmpty);
  }

  bool eveningLibConfigExists() {
    var config = ref.watch(configProvider);
    var listEveningLib = ref
        .watch(liberalsDataProvider)
        .where((element) => element.studyMode!.toLowerCase() == 'evening')
        .toList();
    return listEveningLib.isEmpty ||
        (config.evenLibDay != null &&
            config.evenLibLevel!.isNotEmpty &&
            config.evenLibLevel != null &&
            config.evenLibDay!.isNotEmpty);
  }

  bool specialVenuesFixed() {
    var courses = ref.watch(coursesDataProvider);
    var spcialVenueCourses = courses
        .where((element) =>
            element.specialVenue != null &&
            element.specialVenue!.isNotEmpty &&
            element.specialVenue!.toLowerCase() != 'no')
        .toList();
    if (spcialVenueCourses.isEmpty) return true;
    var withoutVenues = spcialVenueCourses
        .where((element) => element.venues == null || element.venues!.isEmpty)
        .toList();
    return withoutVenues.isEmpty;
  }
}
