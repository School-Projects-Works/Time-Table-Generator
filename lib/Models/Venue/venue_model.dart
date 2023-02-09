// ignore_for_file: file_names

import 'package:hive/hive.dart';
part 'venue_model.g.dart';

@HiveType(typeId: 6)
class VenueModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? capacity;
  @HiveField(2)
  String? isDisabilityAccessible;
  @HiveField(3)
  String? id;
  @HiveField(4)
  String? isSpecialVenue;

  VenueModel({
    this.name,
    this.capacity,
    this.isDisabilityAccessible,
    this.id,
    this.isSpecialVenue,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      name: json['name'],
      capacity: json['capacity'],
      isDisabilityAccessible: json['isDisabilityAccessible'],
      id: json['id'],
      isSpecialVenue: json['isSpecialVenue'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['capacity'] = capacity;
    data['isDisabilityAccessible'] = isDisabilityAccessible;
    data['id'] = id;
    data['isSpecialVenue'] = isSpecialVenue;
    return data;
  }
}
