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
    return ref.watch(configurationProvider).id != null;
  }

  bool oneStudyModeExists() {
    var config = ref.watch(configurationProvider);
    var regularExists = config.regular['days'] != null;
    return regularExists;
  }

  bool regularLibConfigExists() {
    var config = ref.watch(configurationProvider);
    var regularExists = config.regular['days'] != null;
    var listRegularLib = ref
        .watch(liberalsDataProvider)
        .where((element) => element.studyMode!.toLowerCase() == 'regular')
        .toList();
    return !regularExists ||
        listRegularLib.isEmpty ||
        (config.regular['regLibDay'] != null &&
                config.regular['regLibPeriod'] != null) &&
            (config.regular['regLibDay'].isNotEmpty &&
                config.regular['regLibPeriod'].isNotEmpty &&
                config.regular['regLibLevel'].isNotEmpty);
  }

  bool eveningLibConfigExists() {
    var config = ref.watch(configurationProvider);
    var listEveningLib = ref
        .watch(liberalsDataProvider)
        .where((element) => element.studyMode!.toLowerCase() == 'evening')
        .toList();
    return listEveningLib.isEmpty ||
        (config.regular['evenLibDay'] != null &&
            config.regular['evenLibLevel'].isNotEmpty &&
            config.regular['evenLibLevel'] != null &&
            config.regular['evenLibDay'].isNotEmpty);
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
