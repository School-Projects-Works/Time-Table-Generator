// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'VenueTimePairModel.g.dart';

@HiveType(typeId: 6)
class VenueTimePairModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? venueName;
  @HiveField(2)
  String? venueId;
  @HiveField(3)
  String? venueCapacity;
  @HiveField(4)
  String? isDisabilityAccessible;
  @HiveField(5)
  Map<String, dynamic>? periodMap;
  @HiveField(6)
  String? day;
  @HiveField(7)
  String? targetedStudents;
  @HiveField(8)
  String? period;
  @HiveField(9)
  String? academicYear;
  @HiveField(10)
  String? isSpecialVenue;
  @HiveField(11)
  bool isBooked;

  VenueTimePairModel(
      {this.id,
      this.venueName,
      this.venueId,
      this.venueCapacity,
      this.isDisabilityAccessible,
      this.periodMap,
      this.day,
      this.period,
      this.academicYear,
      this.isSpecialVenue,
      this.isBooked = false});
}
