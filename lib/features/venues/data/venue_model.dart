import 'package:hive/hive.dart';

part 'venue_model.g.dart';

@HiveType(typeId: 5)
class VenueModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? capacity;
  @HiveField(3)
  bool? disabilityAccess;
  @HiveField(4)
  bool? isSpecialVenue;
  VenueModel({
    this.id,
    this.name,
    this.capacity,
    this.disabilityAccess,
    this.isSpecialVenue,
  });
}
