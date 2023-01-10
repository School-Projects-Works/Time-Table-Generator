import 'package:hive/hive.dart';

part 'VenueModel.g.dart';

@HiveType(typeId: 3)
class VenueModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? capacity;
  @HiveField(2)
  String? isDisabilityAccessible;
  @HiveField(3)
  String? id;

  VenueModel({this.name, this.capacity, this.isDisabilityAccessible, this.id});

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      name: json['name'],
      capacity: json['capacity'],
      isDisabilityAccessible: json['isDisabilityAccessible'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['capacity'] = capacity;
    data['isDisabilityAccessible'] = isDisabilityAccessible;
    data['id'] = id;
    return data;
  }
}
