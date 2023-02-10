class VenueTimePairModel {
  String? id;
  String? venueName;
  String? venueId;
  String? venueCapacity;
  String? isDisabilityAccessible;
  Map<String, dynamic>? periodMap;
  String? day;
  String? targetedStudents;
  String? period;
  String? academicYear;
  String? isSpecialVenue;
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
