import 'dart:convert';

import 'package:aamusted_timetable_generator/features/tables/data/periods_model.dart';
import 'package:aamusted_timetable_generator/features/venues/data/venue_model.dart';

class EmptyModel {
  PeriodModel period;
  VenueModel venue;
  String day;
  EmptyModel({
    required this.period,
    required this.venue,
    required this.day,
  });

  EmptyModel copyWith({
    PeriodModel? period,
    VenueModel? venue,
    String? day,
  }) {
    return EmptyModel(
      period: period ?? this.period,
      venue: venue ?? this.venue,
      day: day ?? this.day,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'period': period.toMap(),
      'venue': venue.toMap(),
      'day': day,
    };
  }

  factory EmptyModel.fromMap(Map<String, dynamic> map) {
    return EmptyModel(
      period: PeriodModel.fromMap(map['period']),
      venue: VenueModel.fromMap(map['venue']),
      day: map['day'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EmptyModel.fromJson(String source) => EmptyModel.fromMap(json.decode(source));

  @override
  String toString() => 'EmptyModel(period: $period, venue: $venue, day: $day)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is EmptyModel &&
      other.period == period &&
      other.venue == venue &&
      other.day == day;
  }

  @override
  int get hashCode => period.hashCode ^ venue.hashCode ^ day.hashCode;
}
