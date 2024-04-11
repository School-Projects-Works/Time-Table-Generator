//! combine available venues and times(Day and period)

import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/vtp_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../configurations/provider/config_provider.dart';
import '../../main/provider/main_provider.dart';

final venueTimePairProvider =
    StateNotifierProvider<VenueTimePairProvider, List<VTPModel>>(
        (ref) => VenueTimePairProvider());

class VenueTimePairProvider extends StateNotifier<List<VTPModel>> {
  VenueTimePairProvider() : super([]);

  void generateVTP(WidgetRef ref) {
    //! get all available venues
    var venues = ref.watch(venuesDataProvider);
    List<String> days = [];
    List<PeriodModel> periods = [];
    //? get the configuration data
    var config = ref.watch(configProvider);
    //? extract data from the configuration
    if (config.days.isNotEmpty ) {
      days = config.days;
      var periods = config.periods.map((e) => PeriodModel.fromMap(e)).toList();
      //remove breaks from the periods
      periods.removeWhere((element) => element.isBreak == true);
    }
    List<VTPModel> vtp = [];
    // combine the venues with the days and periods
    //loop through the venues and for each venue loop through the days and periods
    for (var venue in venues) {
      for (var day in days) {
        for (var period in periods) {
          var id = '${venue.id}$day${period.period}'
              .trim()
              .replaceAll(' ', '')
              .toLowerCase();
          vtp.add(VTPModel(
            isBooked: false,
            id: id,
            startTime: period.startTime,
            endTime: period.endTime,
            position: period.position,
            venueName: venue.name,
            dissabledAccess: venue.disabilityAccess,
            day: day,
            period: period.period,
            venueCapacity: venue.capacity,
            venueId: venue.id,
            studyMode: '',
            year: config.year!,
            semester: config.semester!,
            isSpecialVenue: venue.isSpecialVenue,
          ));
        }
      }
    }
    state = vtp;
  }

  void bookVTP(VTPModel noneSpecialVTPsList) {
    var index =
        state.indexWhere((element) => element.id == noneSpecialVTPsList.id);
    state[index] = noneSpecialVTPsList.copyWith(isBooked: true);
  }
}
