import 'package:hive/hive.dart';

part 'VenueTimePairModel.g.dart';

@HiveType(typeId: 6)
class VenueTimePairModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? venueName;
  @HiveField(2)
  String? uniqueId;
  @HiveField(3)
  String? venueCapacity;
  @HiveField(4)
  String? isDisabilityAccessible;
  @HiveField(5)
  Map<String, dynamic>? period;
  @HiveField(6)
  String? day;
  @HiveField(7)
  bool? reg;
  @HiveField(8)
  bool? eve;
  @HiveField(9)
  bool? wnd;

  VenueTimePairModel(
      {this.id,
      this.venueName,
      this.uniqueId,
      this.venueCapacity,
      this.isDisabilityAccessible,
      this.period,
      this.day,
      this.reg,
      this.eve,
      this.wnd});

  factory VenueTimePairModel.fromJson(Map<String, dynamic> json) {
    return VenueTimePairModel(
      id: json['id'],
      venueName: json['venueName'],
      uniqueId: json['uniqueId'],
      venueCapacity: json['venueCapacity'],
      isDisabilityAccessible: json['isDisabilityAccessible'],
      period: json['period'],
      day: json['day'],
      reg: json['reg'],
      eve: json['eve'],
      wnd: json['wnd'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['venueName'] = venueName;
    data['uniqueId'] = uniqueId;
    data['venueCapacity'] = venueCapacity;
    data['isDisabilityAccessible'] = isDisabilityAccessible;
    data['period'] = period;
    data['day'] = day;
    data['reg'] = reg;
    data['eve'] = eve;
    data['wnd'] = wnd;
    return data;
  }
}
