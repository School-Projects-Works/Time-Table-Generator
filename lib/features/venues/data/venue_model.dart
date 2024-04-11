import 'dart:convert';
import 'package:flutter/widgets.dart';


class VenueModel {
  String? id;
  String? name;
  int? capacity;
  bool? disabilityAccess;
  bool? isSpecialVenue;
  VenueModel({
    this.id,
    this.name,
    this.capacity,
    this.disabilityAccess,
    this.isSpecialVenue,
  });

  VenueModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? name,
    ValueGetter<int?>? capacity,
    ValueGetter<bool?>? disabilityAccess,
    ValueGetter<bool?>? isSpecialVenue,
  }) {
    return VenueModel(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      capacity: capacity != null ? capacity() : this.capacity,
      disabilityAccess: disabilityAccess != null ? disabilityAccess() : this.disabilityAccess,
      isSpecialVenue: isSpecialVenue != null ? isSpecialVenue() : this.isSpecialVenue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'disabilityAccess': disabilityAccess,
      'isSpecialVenue': isSpecialVenue,
    };
  }

  factory VenueModel.fromMap(Map<String, dynamic> map) {
    return VenueModel(
      id: map['id'],
      name: map['name'],
      capacity: map['capacity']?.toInt(),
      disabilityAccess: map['disabilityAccess'],
      isSpecialVenue: map['isSpecialVenue'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VenueModel.fromJson(String source) => VenueModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VenueModel(id: $id, name: $name, capacity: $capacity, disabilityAccess: $disabilityAccess, isSpecialVenue: $isSpecialVenue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is VenueModel &&
      other.id == id &&
      other.name == name &&
      other.capacity == capacity &&
      other.disabilityAccess == disabilityAccess &&
      other.isSpecialVenue == isSpecialVenue;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      capacity.hashCode ^
      disabilityAccess.hashCode ^
      isSpecialVenue.hashCode;
  }
}
