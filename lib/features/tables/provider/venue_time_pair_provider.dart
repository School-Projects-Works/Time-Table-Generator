//! combine available venues and times(Day and period)

import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:aamusted_timetable_generator/features/tables/data/vtp_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../configurations/data/config/config_model.dart';
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
    List<PeriodsModel> periods = [];
    //? get the configuration data
    var config = ref.watch(configurationProvider);
    //? extract data from the configuration
    //! which contains days and periods and other data
    var data =
        config.regular['days'] != null && config.regular['days'].isNotEmpty
            ? StudyModeModel.fromMap(config.regular)
            : null;
    if (data != null) {
      days = data.days;
      for (var element in data.periods) {
        if (element['period'].toString().replaceAll(' ', '').toLowerCase() !=
            'break') {
          periods.add(PeriodsModel.fromMap(element));
        }
      }
    }
    print('Period ====== ${periods.length}');
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
            venueName: venue.name,
            dissabledAccess: venue.disabilityAccess,
            day: day,
            period: period.period,
            venueCapacity: venue.capacity,
            venueId: venue.id,
            periodMap: period.toMap(),
            studyMode: '',
            year: config.year,
            semester: config.semester,
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
